# backend/app/api/v1/endpoints/data_upload.py

from fastapi import APIRouter, HTTPException, status, Request # Make sure Request is imported
from app.schemas.csv import CsvUploadRequest, CsvUploadResponse
from app.services.data_processing import data_processing_service

router = APIRouter()

@router.post("/upload-data", response_model=CsvUploadResponse, status_code=status.HTTP_200_OK) # Added /data prefix back for consistency
async def upload_data(request_body: CsvUploadRequest, http_request: Request): # <-- ADDED THIS ARGUMENT
    """
    Endpoint to upload CSV data, process it, and return metadata.
    """
    # --- DEBUG PRINT ---
    raw_body = await http_request.body() # Read the raw body
    print(f"FASTAPI DEBUG: Backend received raw body: {raw_body.decode('utf-8')}")
    try:
        # Pydantic v2 uses model_dump_json(), v1 uses json()
        print(f"FASTAPI DEBUG: Backend parsed request_body: {request_body.model_dump_json()}")
    except AttributeError: # Fallback for Pydantic v1
        print(f"FASTAPI DEBUG: Backend parsed request_body: {request_body.json()}")
    # --- END DEBUG PRINT ---

    try:
        results = data_processing_service.process_csv_upload(request_body.csv_data)
        return CsvUploadResponse(
            message="CSV uploaded successfully",
            dataset_id=results["dataset_id"],
            column_info=results["column_info"],
            sample_data=results["sample_data"]
        )
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        # Catch any unexpected errors
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Internal server error: {e}")