# backend/app/data_store/in_memory_store.py

# This is a simple in-memory store for MVP.
# In a real production app, this would be replaced by a proper database or persistent storage.
datasets: dict = {} # Stores pandas DataFrames: dataset_id -> DataFrame