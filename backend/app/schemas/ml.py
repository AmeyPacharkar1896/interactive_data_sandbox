# backend/app/schemas/ml.py

from pydantic import BaseModel
from typing import List, Dict, Any

class KMeansRequest(BaseModel): 
    dataset_id: str
    feature_x: str
    feature_y: str
    n_clusters: int 

class KMeansPlotPoint(BaseModel):
    x: float
    y: float
    cluster_id: int 

class KMeansCentroid(BaseModel):
    x: float
    y: float
    cluster_id: int 

class KMeansResponse(BaseModel):
    plot_data: List[KMeansPlotPoint]
    centroids: List[KMeansCentroid]
    inertia: float