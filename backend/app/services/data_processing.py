# backend/app/services/data_processing.py

import pandas as pd
import io
import hashlib
from typing import Dict, List, Any

from app.schemas.csv import ColumnInfo
from app.data_store.in_memory_store import datasets # Access our in-memory store

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
        except Exception as e:
            raise ValueError(f"Error processing CSV data: {e}")

data_processing_service = DataProcessingService()