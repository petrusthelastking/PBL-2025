"""
Main FastAPI application
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.config import (
    API_TITLE,
    API_DESCRIPTION,
    API_VERSION,
    CORS_ORIGINS,
    CORS_CREDENTIALS,
    CORS_METHODS,
    CORS_HEADERS,
    DEVICE
)
from api.routes import router
from api.model_loader import model_manager


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Lifespan context manager for startup and shutdown events
    """
    # Startup
    print("=" * 60)
    print(f"Starting {API_TITLE}")
    print(f"Device: {DEVICE}")
    print("=" * 60)
    
    success = model_manager.load_all_models()
    
    if not success:
        print("WARNING: No models were loaded!")
    else:
        loaded_models = model_manager.get_loaded_models()
        print(f"Successfully loaded {len(loaded_models)} model(s): {loaded_models}")
    
    print("=" * 60)
    
    yield
    
    # Shutdown
    print("Shutting down API...")


def create_app() -> FastAPI:
    """
    Create and configure FastAPI application
    
    Returns:
        Configured FastAPI application
    """
    # Initialize FastAPI app with lifespan
    app = FastAPI(
        title=API_TITLE,
        description=API_DESCRIPTION,
        version=API_VERSION,
        lifespan=lifespan
    )
    
    # Add CORS middleware
    app.add_middleware(
        CORSMiddleware,
        allow_origins=CORS_ORIGINS,
        allow_credentials=CORS_CREDENTIALS,
        allow_methods=CORS_METHODS,
        allow_headers=CORS_HEADERS,
    )
    
    # Include routes
    app.include_router(router)
    
    return app


# Create app instance
app = create_app()
