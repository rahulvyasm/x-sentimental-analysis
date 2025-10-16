# Processing Module

PySpark-based data processing pipeline for text normalization and sentiment analysis.

## Structure

- **normalization/** - Text cleaning and preprocessing
  - Lowercasing, URL/mention removal
  - Tokenization
  - Stop word removal

- **sentiment/** - Sentiment scoring
  - NLTK VADER implementation
  - Batch sentiment computation
  - Custom UDFs for Spark

- **ml_pipeline/** - Supervised ML models
  - Feature extraction (TF-IDF)
  - Model training (Logistic Regression)
  - Model evaluation and persistence

## Workflow

Raw HDFS Data → Normalization → Sentiment Analysis → Curated Hive Tables

