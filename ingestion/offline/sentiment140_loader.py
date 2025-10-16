"""
Loader for Sentiment140 dataset (offline development/training)
Dataset: 1.6M labeled tweets for sentiment analysis
"""

from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType


class Sentiment140Loader:
    """
    Load and process Sentiment140 dataset for offline development
    """
    
    # Sentiment140 schema: target, ids, date, flag, user, text
    SCHEMA = StructType([
        StructField("target", IntegerType(), nullable=False),  # 0=negative, 4=positive
        StructField("ids", StringType(), nullable=False),
        StructField("date", StringType(), nullable=False),
        StructField("flag", StringType(), nullable=False),
        StructField("user", StringType(), nullable=False),
        StructField("text", StringType(), nullable=False)
    ])
    
    def __init__(self, spark: SparkSession):
        """
        Initialize loader with SparkSession
        
        Args:
            spark: Active SparkSession with Hive support
        """
        self.spark = spark
    
    def load_csv(self, file_path: str):
        """
        Load Sentiment140 CSV file
        
        Args:
            file_path: Path to CSV file (local or HDFS)
        
        Returns:
            Spark DataFrame with loaded data
        """
        df = self.spark.read.csv(
            file_path,
            schema=self.SCHEMA,
            header=False,
            encoding="latin1"  # Sentiment140 uses latin1 encoding
        )
        
        # Convert target to binary (0=negative, 1=positive)
        df = df.withColumn("sentiment", (df.target / 4).cast(IntegerType()))
        
        return df
    
    def save_to_hdfs(self, df, hdfs_path: str):
        """
        Save loaded dataset to HDFS
        
        Args:
            df: Spark DataFrame
            hdfs_path: HDFS destination path
        """
        df.write.mode("overwrite").parquet(hdfs_path)
        print(f"Saved {df.count()} records to {hdfs_path}")

