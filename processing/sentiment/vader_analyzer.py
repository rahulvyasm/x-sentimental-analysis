"""
VADER sentiment analysis for social media text
"""

from nltk.sentiment.vader import SentimentIntensityAnalyzer
from pyspark.sql import DataFrame
from pyspark.sql.functions import udf
from pyspark.sql.types import StructType, StructField, FloatType


class VaderSentimentAnalyzer:
    """
    NLTK VADER sentiment analyzer for Spark DataFrames
    """
    
    def __init__(self):
        """Initialize VADER analyzer"""
        # Note: Ensure VADER lexicon is downloaded
        # nltk.download('vader_lexicon')
        self.analyzer = SentimentIntensityAnalyzer()
    
    def get_sentiment_scores(self, text: str) -> tuple:
        """
        Get VADER sentiment scores for text
        
        Args:
            text: Input text string
        
        Returns:
            Tuple of (neg, neu, pos, compound) scores
        """
        if not text or not isinstance(text, str):
            return (0.0, 0.0, 0.0, 0.0)
        
        scores = self.analyzer.polarity_scores(text)
        return (
            scores['neg'],
            scores['neu'],
            scores['pos'],
            scores['compound']
        )
    
    def analyze_dataframe(self, df: DataFrame, text_column: str = "cleaned_text") -> DataFrame:
        """
        Apply VADER sentiment analysis to Spark DataFrame
        
        Args:
            df: Input DataFrame
            text_column: Column containing text to analyze
        
        Returns:
            DataFrame with sentiment score columns added
        """
        # Define schema for sentiment scores
        sentiment_schema = StructType([
            StructField("neg", FloatType(), nullable=False),
            StructField("neu", FloatType(), nullable=False),
            StructField("pos", FloatType(), nullable=False),
            StructField("compound", FloatType(), nullable=False)
        ])
        
        # Register UDF
        sentiment_udf = udf(self.get_sentiment_scores, sentiment_schema)
        
        # Apply sentiment analysis
        df = df.withColumn("sentiment_scores", sentiment_udf(df[text_column]))
        df = df.withColumn("neg", df.sentiment_scores.neg)
        df = df.withColumn("neu", df.sentiment_scores.neu)
        df = df.withColumn("pos", df.sentiment_scores.pos)
        df = df.withColumn("compound", df.sentiment_scores.compound)
        df = df.drop("sentiment_scores")
        
        return df

