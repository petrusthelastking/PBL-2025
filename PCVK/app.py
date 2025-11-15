"""
FastAPI Application Entry Point (Backward Compatible)

This file maintains backward compatibility by importing from the modular structure.
To use the new modular structure, run: python main.py
To use this file directly, run: python app.py
"""

from api.app import app
from api.config import SERVER_HOST, SERVER_PORT, MODEL_PATHS

if __name__ == "__main__":
    import uvicorn
    
    print("Starting FastAPI server")
    print(f"Device: {app.extra.get('device', 'N/A')}" if hasattr(app, 'extra') else "")
    print(f"Available model types: {list(MODEL_PATHS.keys())}")
    
    for model_type, path in MODEL_PATHS.items():
        print(f"  {model_type}: {path}")
    
    uvicorn.run(
        app,
        host=SERVER_HOST,
        port=SERVER_PORT,
        reload=False
    )
