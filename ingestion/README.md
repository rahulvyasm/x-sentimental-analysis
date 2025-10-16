# Ingestion Module

This module handles data ingestion from various sources.

## Structure

- **api/** - X (Twitter) API v2 integration
  - Real-time streaming (Filtered Stream)
  - Batch pulls (Recent Search)
  - Authentication and rate limiting

- **offline/** - Offline dataset loaders
  - Sentiment140 dataset loader
  - CSV/JSON parsers
  - Data validation

## Key Features

- X API v2 authentication
- Configurable batch/stream ingestion
- Raw data landing to HDFS
- Error handling and retry logic

