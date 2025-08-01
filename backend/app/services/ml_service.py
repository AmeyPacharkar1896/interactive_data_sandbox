# backend/app/services/ml_service.py

import pandas as pd
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from typing import List, Dict, Any, Optional

from app.data_store.in_memory_store import datasets
from app.schemas.ml import KMeansPlotPoint, KMeansCentroid


class MlService:
    def run_kmeans_clustering(
        self, dataset_id: str, feature_x: str, feature_y: str, n_clusters: int
    ) -> Dict[str, Any]:
        """
        Performs K-Means clustering on specified features of a dataset.
        """
        df = datasets.get(dataset_id)
        if df is None:
            raise ValueError("Dataset not found.")

        if feature_x not in df.columns or feature_y not in df.columns:
            raise ValueError("Selected features not found in dataset.")

        X = df[[feature_x, feature_y]].dropna()

        if not pd.api.types.is_numeric_dtype(X[feature_x]) or not pd.api.types.is_numeric_dtype(X[feature_y]):
            raise ValueError(
                "Selected features must be numerical for clustering.")

        if len(X) < n_clusters:
            raise ValueError(
                f"Not enough data points ({len(X)}) for {n_clusters} clusters.")

        try:
            kmeans = KMeans(n_clusters=n_clusters, random_state=0, n_init=10)
            clusters = kmeans.fit_predict(X)
            cluster_centers = kmeans.cluster_centers_
            inertia = kmeans.inertia_

            silhouette_avg: Optional[float] = None
            if n_clusters > 1 and len(X) >= n_clusters and len(set(clusters)) > 1:
                try:
                    silhouette_avg = silhouette_score(X, clusters)
                except Exception as e:
                    print(
                        f"Warning: Could not calculate Silhouette Score: {e}")

            plot_data = []
            for i, (original_index, row) in enumerate(X.iterrows()):
                plot_data.append(
                    KMeansPlotPoint(
                        x=float(row[feature_x]),
                        y=float(row[feature_y]),
                        cluster_id=int(clusters[i])
                    )
                )

            centroids = []
            for i, center in enumerate(cluster_centers):
                centroids.append(
                    KMeansCentroid(
                        x=float(center[0]),
                        y=float(center[1]),
                        cluster_id=i
                    )
                )

            return {
                "plot_data": plot_data,
                "centroids": centroids,
                "inertia": inertia,
                "silhouette_score": silhouette_avg
            }
        except Exception as e:
            raise ValueError(f"K-Means execution failed: {e}")


ml_service = MlService()
