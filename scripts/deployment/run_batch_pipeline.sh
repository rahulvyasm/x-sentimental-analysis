#!/bin/bash
# Run the complete batch sentiment analysis pipeline

echo "==================================="
echo "Twitter Sentiment Analysis Pipeline"
echo "==================================="

# Configuration
SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}

# Activate virtual environment
if [ -d ".venv" ]; then
    source .venv/bin/activate
else
    echo "Error: Virtual environment not found. Run scripts/setup/install_dependencies.sh first."
    exit 1
fi

# Check if Hadoop is running
if ! ${HADOOP_HOME}/bin/hdfs dfs -ls / > /dev/null 2>&1; then
    echo "Warning: HDFS may not be running. Please start Hadoop services."
fi

echo ""
echo "Step 1: Data Ingestion (offline dataset)"
echo "-----------------------------------"
# TODO: Implement ingestion job submission
# spark-submit --master local[*] ingestion/offline/load_sentiment140.py

echo ""
echo "Step 2: Text Normalization"
echo "-----------------------------------"
# TODO: Implement normalization job
# spark-submit --master local[*] processing/normalization/normalize_tweets.py

echo ""
echo "Step 3: VADER Sentiment Analysis"
echo "-----------------------------------"
# TODO: Implement VADER scoring job
# spark-submit --master local[*] processing/sentiment/score_sentiment.py

echo ""
echo "Step 4: ML Model Training (optional)"
echo "-----------------------------------"
# TODO: Implement ML training job
# spark-submit --master local[*] processing/ml_pipeline/train_classifier.py

echo ""
echo "==================================="
echo "Pipeline execution complete!"
echo "==================================="

