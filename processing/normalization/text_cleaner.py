"""
Text normalization and cleaning for tweet data
"""

import re
from pyspark.sql import DataFrame
from pyspark.sql.functions import udf, lower, trim, regexp_replace
from pyspark.sql.types import StringType


class TextCleaner:
    """
    Text cleaning and normalization for social media text
    """
    
    @staticmethod
    def remove_urls(text: str) -> str:
        """Remove URLs from text"""
        return re.sub(r'http\S+|www\S+|https\S+', '', text, flags=re.MULTILINE)
    
    @staticmethod
    def remove_mentions(text: str) -> str:
        """Remove @mentions"""
        return re.sub(r'@\w+', '', text)
    
    @staticmethod
    def remove_hashtags(text: str) -> str:
        """Remove hashtags (keeping the text)"""
        return re.sub(r'#', '', text)
    
    @staticmethod
    def remove_special_chars(text: str) -> str:
        """Remove special characters, keeping alphanumeric and spaces"""
        return re.sub(r'[^a-zA-Z0-9\s]', '', text)
    
    def clean_dataframe(self, df: DataFrame, text_column: str = "text") -> DataFrame:
        """
        Apply cleaning transformations to a Spark DataFrame
        
        Args:
            df: Input DataFrame
            text_column: Name of text column to clean
        
        Returns:
            DataFrame with cleaned text in 'cleaned_text' column
        """
        # Register UDFs
        remove_urls_udf = udf(self.remove_urls, StringType())
        remove_mentions_udf = udf(self.remove_mentions, StringType())
        remove_hashtags_udf = udf(self.remove_hashtags, StringType())
        remove_special_chars_udf = udf(self.remove_special_chars, StringType())
        
        # Apply cleaning pipeline
        df = df.withColumn("cleaned_text", lower(df[text_column]))
        df = df.withColumn("cleaned_text", remove_urls_udf(df.cleaned_text))
        df = df.withColumn("cleaned_text", remove_mentions_udf(df.cleaned_text))
        df = df.withColumn("cleaned_text", remove_hashtags_udf(df.cleaned_text))
        df = df.withColumn("cleaned_text", remove_special_chars_udf(df.cleaned_text))
        df = df.withColumn("cleaned_text", regexp_replace(df.cleaned_text, r'\s+', ' '))
        df = df.withColumn("cleaned_text", trim(df.cleaned_text))
        
        return df

