"""
Spark utility functions and helpers
"""

from pyspark.sql import SparkSession


def create_spark_session(app_name: str = "TwitterSentimentAnalysis", 
                         enable_hive: bool = True,
                         **kwargs) -> SparkSession:
    """
    Create and configure SparkSession with Hive support
    
    Args:
        app_name: Application name
        enable_hive: Enable Hive support for table access
        **kwargs: Additional Spark configuration options
    
    Returns:
        Configured SparkSession
    """
    builder = SparkSession.builder.appName(app_name)
    
    # Default configurations
    default_config = {
        "spark.sql.warehouse.dir": "/user/hive/warehouse",
        "spark.sql.catalogImplementation": "hive",
        "spark.hadoop.hive.metastore.uris": "thrift://localhost:9083",
        "spark.driver.memory": "4g",
        "spark.executor.memory": "4g"
    }
    
    # Merge with user-provided config
    config = {**default_config, **kwargs}
    
    # Apply configurations
    for key, value in config.items():
        builder = builder.config(key, value)
    
    # Enable Hive support if requested
    if enable_hive:
        builder = builder.enableHiveSupport()
    
    spark = builder.getOrCreate()
    
    return spark


def stop_spark_session(spark: SparkSession):
    """
    Properly stop SparkSession
    
    Args:
        spark: SparkSession to stop
    """
    if spark:
        spark.stop()


def get_hdfs_path(relative_path: str, base_path: str = "hdfs://localhost:9000") -> str:
    """
    Construct full HDFS path
    
    Args:
        relative_path: Relative path within HDFS
        base_path: HDFS base URL
    
    Returns:
        Full HDFS path
    """
    return f"{base_path}/{relative_path.lstrip('/')}"

