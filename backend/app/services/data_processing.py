# backend/app/services/data_processing.py

import pandas as pd
import io
import hashlib
from typing import Dict, List, Any

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
            raise ValueError("An unexpected internal error occurred during data processing. Please try again later.")

data_processing_service = DataProcessingService()
