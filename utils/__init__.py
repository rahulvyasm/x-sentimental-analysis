"""
Utility functions and helpers for the sentiment analysis pipeline
"""

from .spark_utils import create_spark_session, stop_spark_session, get_hdfs_path
from .logger import setup_logger

__all__ = [
    'create_spark_session',
    'stop_spark_session', 
    'get_hdfs_path',
    'setup_logger'
]

__version__ = "0.1.0"

