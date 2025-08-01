# backend/app/services/data_processing.py

import pandas as pd
import io
import hashlib
from typing import Dict, List, Any, Optional
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
            sample_data = df.head(5).where(
                pd.notnull(df), None).to_dict(orient="records")

            return {
                "dataset_id": dataset_id,
                "column_info": column_info,
                "sample_data": sample_data
            }
        except ParserError:
            raise ValueError(
                "Failed to parse CSV file. Please ensure it has a valid format (e.g., correct delimiters, no missing quotes).")
        except Exception:
            raise ValueError(
                "An unexpected internal error occurred during CSV processing. Please try again later.")

    def get_numerical_columns(self, dataset_id: str) -> List[str]:
        """
        Retrieves a DataFrame by ID and returns the names of its numerical columns.
        """
        df = datasets.get(dataset_id)
        if df is None:
            raise ValueError("Dataset not found.")

        if df.empty:  # Handle empty DataFrame
            return []

        numerical_cols = []
        for col in df.columns:
            try:
                # Attempt to convert to numeric, coercing errors
                # This is more robust than just checking dtype for mixed types
                temp_series = pd.to_numeric(df[col], errors='coerce')
                # If all values (after coercing errors) are not NaN, it's numeric
                if not temp_series.isna().all():  # Check if at least one non-NaN numeric value
                    numerical_cols.append(col)
            except Exception as e:
                # Log columns that cause issues but don't crash
                print(
                    f"DEBUG: Could not process column '{col}' for numerical check: {e}")
                continue  # Skip this column if it causes an unhandled error

        return numerical_cols


data_processing_service = DataProcessingService()
