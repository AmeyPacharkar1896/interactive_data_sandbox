# backend/app/api/v1/endpoints/ml.py

from fastapi import APIRouter, HTTPException, status
from app.schemas.ml import KMeansRequest, KMeansResponse
from app.services.ml_service import ml_service

router = APIRouter()

# Now mounted at /api/v1/ml, so this becomes /api/v1/ml/kmeans
@router.post("/kmeans", response_model=KMeansResponse)
async def run_kmeans(request: KMeansRequest):
    try:
        results = ml_service.run_kmeans_clustering(
            request.dataset_id,
            request.feature_x,
            request.feature_y,
            request.n_clusters
        )
        return KMeansResponse(
            plot_data=results["plot_data"],
            centroids=results["centroids"],
            inertia=results["inertia"]
        )
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Internal server error: {e}")