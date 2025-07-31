# backend/app/api/v1/endpoints/eda.py

from fastapi import APIRouter, HTTPException, status, Depends
from app.schemas.eda import NumericalColumnsResponse, ScatterPlotRequest, ScatterPlotResponse
from app.services.data_processing import data_processing_service
from app.services.eda_service import eda_service

router = APIRouter()

# Now mounted at /api/v1/eda, so this becomes /api/v1/eda/numerical-columns/{dataset_id}
@router.get("/numerical-columns/{dataset_id}", response_model=NumericalColumnsResponse)
async def get_numerical_columns(dataset_id: str):
    try:
        numerical_cols = data_processing_service.get_numerical_columns(dataset_id)
        return NumericalColumnsResponse(numerical_columns=numerical_cols)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Internal server error: {e}")

# Now mounted at /api/v1/eda, so this becomes /api/v1/eda/scatter-plot
@router.post("/scatter-plot", response_model=ScatterPlotResponse)
async def get_scatter_plot(request: ScatterPlotRequest):
    try:
        plot_data = eda_service.get_scatter_plot_data(
            request.dataset_id,
            request.feature_x,
            request.feature_y
        )
        return ScatterPlotResponse(plot_data=plot_data)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Internal server error: {e}")