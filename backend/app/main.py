# backend/app/main.py

from fastapi import FastAPI
from app.core.config import settings
from app.api.v1.api import api_router

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json", # Documentation URL
    docs_url="/api/v1/docs", # Swagger UI
    redoc_url="/api/v1/redoc", # ReDoc UI
)

# Include the API router for version 1, with the common prefix
app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/")
async def read_root():
    return {"message": "Welcome to the Interactive Data Science Sandbox Backend! Visit /api/v1/docs for API documentation."}