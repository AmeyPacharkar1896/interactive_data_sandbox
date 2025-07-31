# backend/app/services/eda_service.py

import pandas as pd
from typing import List, Dict, Any

from app.data_store.in_memory_store import datasets
from app.schemas.eda import ScatterPlotPoint

class EdaService:
    def get_scatter_plot_data(self, dataset_id: str, feature_x: str, feature_y: str) -> List[ScatterPlotPoint]:
        """
        Retrieves data for a scatter plot for specified features.
        Handles missing values by dropping rows.
        """
        df = datasets.get(dataset_id)
        if df is None:
            raise ValueError("Dataset not found.")

        if feature_x not in df.columns or feature_y not in df.columns:
            raise ValueError("Selected features not found in dataset.")

        # Select only the relevant columns and drop rows with any NaN values in them
        # This is a basic form of cleaning for plotting
        plot_df = df[[feature_x, feature_y]].dropna()

        # Ensure features are numeric
        if not pd.api.types.is_numeric_dtype(plot_df[feature_x]) or not pd.api.types.is_numeric_dtype(plot_df[feature_y]):
            raise ValueError("Selected features must be numerical for plotting.")

        plot_data = []
        for _, row in plot_df.iterrows():
            plot_data.append(
                ScatterPlotPoint(x=float(row[feature_x]), y=float(row[feature_y]))
            )
        return plot_data

eda_service = EdaService()