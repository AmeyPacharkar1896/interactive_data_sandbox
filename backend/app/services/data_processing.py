# backend/app/services/data_processing.py

import pandas as pd
import io
import hashlib
from typing import Dict, List, Any
from pandas.errors import ParserError

from app.schemas.csv import ColumnInfo
from app.data_store.in_memory_store import datasets

class DataProcessingService:
    def process_csv_upload(self, csv_content: str) -> Dict[str, Any]:
        """
        Reads CSV content, stores DataFrame, and returns metadata.
        Raises ValueError on processing errors.
        """
        try:
            df = pd.read_csv(io.StringIO(csv_content))

            dataset_id = hashlib.md5(csv_content.encode('utf-8')).hexdigest()
            datasets[dataset_id] = df

            column_info = [
                ColumnInfo(name=col, dtype=str(df[col].dtype)) for col in df.columns
            ]
            sample_data = df.head(5).where(pd.notnull(df), None).to_dict(orient="records")

            return {
                "dataset_id": dataset_id,
                "column_info": column_info,
                "sample_data": sample_data
            }
        except ParserError:
            raise ValueError("Failed to parse CSV file. Please ensure it has a valid format (e.g., correct delimiters, no missing quotes).")
        except Exception:
            raise ValueError("An unexpected internal error occurred during CSV processing. Please try again later.")

    def get_numerical_columns(self, dataset_id: str) -> List[str]:
        """
        Retrieves a DataFrame by ID and returns the names of its numerical columns.
        """
        df = datasets.get(dataset_id)
        if df is None:
            raise ValueError("Dataset not found.")

        numerical_cols = []
        for col in df.columns:
            # Check if the column can be converted to a numeric type
            # .apply(pd.to_numeric, errors='coerce') converts non-numeric to NaN
            # .notna().all() checks if all values are non-NaN after conversion
            if pd.api.types.is_numeric_dtype(df[col]):
                numerical_cols.append(col)
        return numerical_cols


data_processing_service = DataProcessingService()