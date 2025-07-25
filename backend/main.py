#backend/main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import io
import hashlib

app = FastAPI()

datasets = {}

class CsvUploadRequest(BaseModel):
  csv_data: str # We'll send the CSV content as a string for now

class ColumnInfo(BaseModel):
  name: str
  dtype: str
  
class UploadResponse(BaseModel):
  message: str
  dataset_id: str
  column_info: list[ColumnInfo]
  sample_data: list[dict]
  
#API Endpoints

@app.get("/")
async def read_root():
  return {"message": "Welcome to the Interactive Data Science Sandbox Backend!"}

@app.post("/upload-data", response_model = UploadResponse)
async def upload_data(request: CsvUploadRequest):
  try:
    data = pd.read_csv(io.StringIO(request.csv_data))
    
    dataset_id = hashlib.md5(request.csv_data.encode('utf-8')).hexdigest()
    datasets[dataset_id] = df
    
    column_info = [
      {"name": col, "dtype": strstr(df[col].dtype)} for col in df.columns
    ]
    
    sample_data = df.head(5).to_dict(orient="records")
    
    return UploadResponse(
      message = "CSV uploaded successfully",
      dataset_id = dataset_id,
      column_info=column_info,
      sample_data=sample_data
    )
  except Exception as e:
    raise HTTPException(status_code=400, detail=f"Error processing CSV: {e}")