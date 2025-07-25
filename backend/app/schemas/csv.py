# backend/app/schemas/csv.py

from pydantic import BaseModel
from typing import List, Dict, Any

class CsvUploadRequest(BaseModel):
    csv_data: str 

class ColumnInfo(BaseModel):
    name: str
    dtype: str

class CsvUploadResponse(BaseModel):
    message: str
    dataset_id: str
    column_info: List[ColumnInfo]
    sample_data: List[Dict[str, Any]] 