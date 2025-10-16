# System Architecture

## Overview

Twitter (X) Sentiment Analysis Pipeline - A distributed big data system for real-time and batch sentiment analysis of social media data.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          DATA SOURCES                                │
├─────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────┐              ┌─────────────────────┐         │
│  │   X API v2       │              │  Sentiment140       │         │
│  │  - Recent Search │              │  Offline Dataset    │         │
│  │  - Filtered Stream│              │  (1.6M tweets)      │         │
│  └────────┬─────────┘              └──────────┬──────────┘         │
└───────────┼────────────────────────────────────┼────────────────────┘
            │                                    │
            v                                    v
┌─────────────────────────────────────────────────────────────────────┐
│                       INGESTION LAYER                                │
├─────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐           │
│  │  Python Ingestion Scripts                            │           │
│  │  - API authentication & rate limiting                │           │
│  │  - Dataset loaders (CSV/JSON)                        │           │
│  │  - Data validation                                   │           │
│  └──────────────────┬───────────────────────────────────┘           │
└─────────────────────┼───────────────────────────────────────────────┘
                      │
                      v
┌─────────────────────────────────────────────────────────────────────┐
│                      STORAGE LAYER (HDFS)                            │
├─────────────────────────────────────────────────────────────────────┤
│  ┌────────────────────────────────────────────────────┐             │
│  │  Raw Data Zone                                     │             │
│  │  Path: /data/raw/tweets/{date}/                   │             │
│  │  Format: JSON/Parquet                              │             │
│  └────────────────────────────────────────────────────┘             │
└─────────────────────┼───────────────────────────────────────────────┘
                      │
                      v
┌─────────────────────────────────────────────────────────────────────┐
│                   PROCESSING LAYER (Spark)                           │
├─────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐           │
│  │  Step 1: Text Normalization (PySpark)               │           │
│  │  - Lowercase conversion                              │           │
│  │  - URL/mention/hashtag removal                       │           │
│  │  - Special character cleaning                        │           │
│  │  - Tokenization                                      │           │
│  └──────────────────┬───────────────────────────────────┘           │
│                     │                                                │
│                     v                                                │
│  ┌──────────────────────────────────────────────────────┐           │
│  │  Step 2: Sentiment Analysis (Parallel)              │           │
│  ├──────────────────────────────────────────────────────┤           │
│  │  ┌────────────────────┐   ┌────────────────────┐    │           │
│  │  │  VADER Lexicon     │   │  Spark ML          │    │           │
│  │  │  - Fast scoring    │   │  - Supervised      │    │           │
│  │  │  - No training     │   │  - TF-IDF features │    │           │
│  │  │  - Social media    │   │  - Logistic Reg.   │    │           │
│  │  │    optimized       │   │  - Model eval      │    │           │
│  │  └────────────────────┘   └────────────────────┘    │           │
│  └──────────────────────────────────────────────────────┘           │
└─────────────────────┼───────────────────────────────────────────────┘
                      │
                      v
┌─────────────────────────────────────────────────────────────────────┐
│                    DATA WAREHOUSE (Hive)                             │
├─────────────────────────────────────────────────────────────────────┤
│  ┌────────────────────────────────────────────────────┐             │
│  │  Curated Tables                                    │             │
│  │  - curated_tweets (ORC, partitioned by date)      │             │
│  │  - ml_predictions (Parquet, partitioned by model) │             │
│  │                                                    │             │
│  │  Columns: id, text, cleaned_text, neg, neu,       │             │
│  │          pos, compound, timestamp, etc.           │             │
│  └────────────────────────────────────────────────────┘             │
└─────────────────────┼───────────────────────────────────────────────┘
                      │
                      v
┌─────────────────────────────────────────────────────────────────────┐
│                      ANALYTICS LAYER                                 │
├─────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐           │
│  │  Spark SQL / Hive Queries                            │           │
│  │  - Sentiment distributions                           │           │
│  │  - Time-series trends                                │           │
│  │  - Topic analysis                                    │           │
│  │  - Model performance metrics                         │           │
│  └──────────────────────────────────────────────────────┘           │
│  ┌──────────────────────────────────────────────────────┐           │
│  │  Visualization & Reporting                           │           │
│  │  - Jupyter notebooks                                 │           │
│  │  - Dashboards                                        │           │
│  │  - Automated reports                                 │           │
│  └──────────────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. Data Sources
- **X API v2**: Real-time tweet ingestion (rate-limited by tier)
- **Sentiment140**: 1.6M labeled tweets for training and development

### 2. Ingestion Layer
- Python scripts for API interaction and file loading
- Authentication and error handling
- Data validation and schema enforcement

### 3. Storage Layer (HDFS)
- **Raw Zone**: Immutable source data in JSON/Parquet
- Single-node/pseudo-distributed setup for development
- Path structure: `/data/raw/tweets/{date}/{batch_id}.parquet`

### 4. Processing Layer (Apache Spark)
- **Text Normalization**: PySpark transformations for cleaning
- **VADER Sentiment**: Lexicon-based, optimized for social media
- **ML Pipeline**: Supervised learning with Spark MLlib
  - Features: TF-IDF vectorization
  - Algorithm: Logistic Regression
  - Evaluation: F1-score, Accuracy

### 5. Data Warehouse (Apache Hive)
- **Table Format**: ORC (curated), Parquet (predictions)
- **Partitioning**: By date for efficient queries
- **Metastore**: Derby/MySQL for table metadata
- **Integration**: Spark enableHiveSupport for seamless access

### 6. Analytics Layer
- **Spark SQL**: Complex aggregations and joins
- **Hive CLI**: Ad-hoc queries
- **Jupyter**: Interactive analysis and visualization

## Data Flow

1. **Ingestion** → Raw tweets loaded to HDFS
2. **Normalization** → Text cleaned via PySpark UDFs
3. **Sentiment Scoring** → VADER/ML applied in parallel
4. **Persistence** → Results written to Hive tables
5. **Analysis** → SQL queries for insights

## Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Compute | Apache Spark | 3.x |
| Storage | Hadoop HDFS | 3.x |
| Warehouse | Apache Hive | 3.x |
| NLP | NLTK VADER | Latest |
| Language | Python | 3.8+ |
| ML | Spark MLlib | 3.x |

## Scalability Considerations

- **Current**: Single-node for development
- **Future**: Can scale to multi-node cluster
- **Partitioning**: Date-based for efficient pruning
- **Caching**: Spark DataFrames cached for iterative ML
- **Compression**: Snappy for ORC/Parquet

## Security & Compliance

- API credentials stored as environment variables
- No PII stored beyond required fields
- Data retention policies via HDFS lifecycle
- Access control via HDFS permissions

## Monitoring & Logging

- Application logs in `/logs` directory
- Spark UI for job monitoring (port 4040)
- HDFS web UI (port 9870)
- Custom logging via Python logging module

