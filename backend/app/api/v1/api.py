# backend/app/api/v1/api.py

from fastapi import APIRouter
from app.api.v1.endpoints import data_upload
from app.api.v1.endpoints import eda
from app.api.v1.endpoints import ml

api_router = APIRouter()

api_router.include_router(data_upload.router, tags=["Data Upload"], prefix="/data") # Still /api/v1/data
api_router.include_router(eda.router, tags=["EDA"], prefix="/eda") # NEW: Endpoints will be /api/v1/eda/xyz
api_router.include_router(ml.router, tags=["ML"], prefix="/ml") # NEW: Endpoints will be /api/v1/ml/xyz