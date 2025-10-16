-- Hive Table DDL for Twitter Sentiment Analysis Pipeline

-- Create database
CREATE DATABASE IF NOT EXISTS twitter_sentiment;
USE twitter_sentiment;

-- Raw tweets table (landing zone)
CREATE EXTERNAL TABLE IF NOT EXISTS raw_tweets (
    id STRING,
    text STRING,
    created_at STRING,
    author_id STRING,
    lang STRING,
    raw_json STRING
)
COMMENT 'Raw tweets from X API or offline datasets'
STORED AS PARQUET
LOCATION '/user/hive/warehouse/twitter_sentiment.db/raw_tweets';

-- Curated tweets table (with sentiment scores)
CREATE TABLE IF NOT EXISTS curated_tweets (
    id STRING,
    text STRING,
    cleaned_text STRING,
    created_at TIMESTAMP,
    author_id STRING,
    lang STRING,
    neg FLOAT COMMENT 'VADER negative score',
    neu FLOAT COMMENT 'VADER neutral score',
    pos FLOAT COMMENT 'VADER positive score',
    compound FLOAT COMMENT 'VADER compound score',
    processing_timestamp TIMESTAMP
)
COMMENT 'Curated tweets with VADER sentiment scores'
PARTITIONED BY (processing_date DATE)
STORED AS ORC
LOCATION '/user/hive/warehouse/twitter_sentiment.db/curated_tweets'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- ML predictions table (supervised model results)
CREATE TABLE IF NOT EXISTS ml_predictions (
    id STRING,
    text STRING,
    cleaned_text STRING,
    predicted_label INT COMMENT '0=negative, 1=positive',
    prediction_probability ARRAY<DOUBLE>,
    vader_compound FLOAT,
    model_version STRING,
    prediction_timestamp TIMESTAMP
)
COMMENT 'ML model sentiment predictions'
PARTITIONED BY (model_name STRING)
STORED AS PARQUET
LOCATION '/user/hive/warehouse/twitter_sentiment.db/ml_predictions';

-- Show tables
SHOW TABLES;

