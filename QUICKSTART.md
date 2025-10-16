# Quick Start Guide

Get up and running with the Twitter Sentiment Analysis Pipeline in minutes.

## 📋 Prerequisites Checklist

- [ ] Python 3.8 or higher installed
- [ ] Java 8 or 11 installed (for Hadoop/Spark/Hive)
- [ ] At least 8GB RAM available
- [ ] 20GB free disk space

## 🚀 Quick Setup (5 Steps)

### Step 1: Install Python Dependencies

```bash
cd /home/rahulvyasm/Personal/Projects/x-sentimental-analysis
./scripts/setup/install_dependencies.sh
```

This will:
- Create a virtual environment in `.venv/`
- Install all required Python packages
- Download NLTK VADER lexicon

### Step 2: Activate Virtual Environment

```bash
source .venv/bin/activate
```

You should see `(.venv)` in your terminal prompt.

### Step 3: Verify Installation

```bash
python -c "from pyspark.sql import SparkSession; print('PySpark OK')"
python -c "from nltk.sentiment.vader import SentimentIntensityAnalyzer; print('NLTK OK')"
```

Expected output:
```
PySpark OK
NLTK OK
```

### Step 4: Configure Environment (Optional)

If you have X API credentials:

```bash
export X_BEARER_TOKEN="your_token_here"
```

### Step 5: Test the Components

```bash
# Run unit tests
pytest tests/unit/ -v

# Test text cleaner
python -c "
from processing.normalization.text_cleaner import TextCleaner
cleaner = TextCleaner()
text = 'Check out https://example.com @user #awesome!'
print('Original:', text)
print('Cleaned:', cleaner.remove_urls(text))
"

# Test VADER analyzer
python -c "
from processing.sentiment.vader_analyzer import VaderSentimentAnalyzer
analyzer = VaderSentimentAnalyzer()
text = 'This is absolutely wonderful!'
scores = analyzer.get_sentiment_scores(text)
print('Text:', text)
print('Sentiment scores:', scores)
"
```

## 📊 Next Steps

### For Hadoop/Spark/Hive Setup

If you haven't installed Hadoop, Spark, and Hive yet:

1. **Install Hadoop** (Single-Node)
   - Follow: https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
   - Set `HADOOP_HOME` environment variable

2. **Install Spark** (Standalone)
   - Download from: https://spark.apache.org/downloads.html
   - Set `SPARK_HOME` environment variable

3. **Install Hive**
   - Follow: https://cwiki.apache.org/confluence/display/Hive/Manual+Installation
   - Set `HIVE_HOME` environment variable

4. **Create Hive Tables**
   ```bash
   # Start Hive CLI
   hive
   
   # Run table creation script
   source analytics/queries/create_tables.sql;
   ```

### For Testing Without Big Data Stack

You can test the core Python components without Hadoop/Spark/Hive:

```python
# Test text processing
from processing.normalization.text_cleaner import TextCleaner
from processing.sentiment.vader_analyzer import VaderSentimentAnalyzer

cleaner = TextCleaner()
analyzer = VaderSentimentAnalyzer()

# Sample tweet
tweet = "I absolutely love this new feature! It's amazing! 🎉 @company #awesome"

# Clean
cleaned = cleaner.remove_urls(tweet)
cleaned = cleaner.remove_mentions(cleaned)
cleaned = cleaner.remove_hashtags(cleaned)
cleaned = cleaner.remove_special_chars(cleaned)

# Analyze sentiment
scores = analyzer.get_sentiment_scores(cleaned)
print(f"Original: {tweet}")
print(f"Cleaned: {cleaned}")
print(f"Sentiment: {scores}")
```

## 🎯 Your First Pipeline Run

Once Hadoop/Spark/Hive are set up:

```bash
# 1. Download Sentiment140 dataset
# https://www.kaggle.com/datasets/kazanova/sentiment140
# Save to: data/raw/sentiment140.csv

# 2. Run the complete pipeline
./scripts/deployment/run_batch_pipeline.sh

# 3. Query results
spark-sql --master local[*] -e "
SELECT sentiment_category, COUNT(*) 
FROM twitter_sentiment.curated_tweets 
GROUP BY sentiment_category;
"
```

## 📚 Learning Path

1. ✅ **Week 1**: Setup environment, test Python components
2. **Week 2**: Install Hadoop/Spark/Hive, create tables
3. **Week 3**: Process Sentiment140 dataset with VADER
4. **Week 4**: Train ML classifier, compare with VADER
5. **Week 5**: Integrate X API (if credentials available)

## 🐛 Troubleshooting

### "ModuleNotFoundError: No module named 'pyspark'"
```bash
source .venv/bin/activate
pip install -r requirements.txt
```

### "NLTK VADER lexicon not found"
```bash
python -c "import nltk; nltk.download('vader_lexicon')"
```

### "PySpark cannot connect to Hive"
- Ensure Hive metastore is running: `hive --service metastore &`
- Check Hive connection in `utils/spark_utils.py`

### Need Help?
- Check `documentation.md` for detailed architecture
- Check `ARCHITECTURE.md` for system design
- Check `status.md` for current project state
- Review individual module READMEs

## 🎉 Success Indicators

You'll know everything is working when:
- ✅ All unit tests pass
- ✅ Spark can create a simple DataFrame
- ✅ VADER produces sentiment scores
- ✅ (Optional) Hive tables are queryable

## 📝 Common Commands

```bash
# Activate environment
source .venv/bin/activate

# Run tests
pytest tests/unit/ -v

# Run specific test file
pytest tests/unit/test_vader_analyzer.py -v

# Start Jupyter notebook (if installed)
jupyter notebook analytics/notebooks/

# Submit Spark job (example)
spark-submit --master local[*] processing/sentiment/vader_analyzer.py

# Query Hive
hive -e "SHOW DATABASES;"
```

Happy analyzing! 🚀

