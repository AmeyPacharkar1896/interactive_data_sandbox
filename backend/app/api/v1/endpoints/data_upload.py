# backend/app/api/v1/endpoints/data_upload.py

from fastapi import APIRouter, HTTPException, status
from app.schemas.csv import CsvUploadRequest, CsvUploadResponse
from app.services.data_processing import data_processing_service

router = APIRouter()

@router.post("/upload-data", response_model=CsvUploadResponse, status_code=status.HTTP_200_OK)
async def upload_data(request: CsvUploadRequest):
    """
    Endpoint to upload CSV data, process it, and return metadata.
    """
    try:
        results = data_processing_service.process_csv_upload(request.csv_data)
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