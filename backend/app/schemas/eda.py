# backend/app/schemas/eda.py

from pydantic import BaseModel
from typing import List, Dict, Any

class NumericalColumnsResponse(BaseModel):
  numerical_columns: List[str]

class ScatterPlotRequest(BaseModel):
  dataset_id: str
  feature_x: str
  feature_y: str

class ScatterPlotPoint(BaseModel):
  x: float
  y: float

class ScatterPlotResponse(BaseModel):
  plot_data: List[ScatterPlotPoint]