# backend/app/api/v1/api.py

from fastapi import APIRouter
from app.api.v1.endpoints import data_upload # Import your specific endpoint routers

api_router = APIRouter()

# Include all routers for version 1 API here
api_router.include_router(data_upload.router, tags=["Data Upload"], prefix="/data")

# Future endpoints (e.g., kmeans.router) will be included here:
# from app.api.v1.endpoints import kmeans
# api_router.include_router(kmeans.router, tags=["K-Means"], prefix="/kmeans")