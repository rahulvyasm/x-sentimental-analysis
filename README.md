# Twitter (X) Sentiment Analysis Pipeline

A comprehensive big data pipeline for sentiment analysis of Twitter data using Apache Spark, Hadoop HDFS, Apache Hive, and Python NLTK.

## 🏗️ Architecture

```
X API / Offline Dataset → HDFS (Raw) → PySpark Processing → Hive (Curated) → Analytics
                                            ↓
                                    Text Normalization
                                            ↓
                                    VADER Sentiment / ML Classifier
```

## 📋 Features

- **Multi-source ingestion**: X API v2 (Recent Search, Filtered Stream) or offline datasets (Sentiment140)
- **Text processing**: Cleaning, normalization, tokenization using PySpark
- **Dual sentiment analysis**:
  - Lexicon-based: NLTK VADER for fast, unsupervised scoring
  - ML-based: Spark ML pipeline with Logistic Regression for supervised classification
- **Big data storage**: HDFS for raw data, Hive tables (Parquet/ORC) for curated analytics
- **SQL analytics**: Spark SQL queries for insights and reporting

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Compute | Apache Spark | Distributed processing, ML |
| Storage | Hadoop HDFS | Distributed file system |
| Data Warehouse | Apache Hive | SQL-like querying |
| NLP | NLTK VADER | Sentiment scoring |
| Language | Python 3.8+ | PySpark, data processing |

## 📁 Project Structure

```
x-sentimental-analysis/
├── ingestion/              # Data ingestion modules
│   ├── api/               # X API v2 client
│   └── offline/           # Offline dataset loaders
├── processing/            # PySpark processing jobs
│   ├── normalization/     # Text cleaning
│   ├── sentiment/         # VADER sentiment analysis
│   └── ml_pipeline/       # Spark ML classifier
├── analytics/             # SQL queries and reports
│   ├── queries/           # Hive/Spark SQL queries
│   ├── reports/           # Report generation
│   └── notebooks/         # Jupyter notebooks
├── config/                # Configuration files
│   ├── hadoop/            # Hadoop configs
│   ├── spark/             # Spark configs
│   └── hive/              # Hive configs
├── data/                  # Data directories
│   ├── raw/               # Raw data landing
│   ├── curated/           # Processed data
│   └── models/            # Saved ML models
├── scripts/               # Setup and deployment
│   ├── setup/             # Installation scripts
│   └── deployment/        # Pipeline runners
├── utils/                 # Utility functions
├── tests/                 # Unit and integration tests
└── logs/                  # Application logs
```

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- Apache Hadoop 3.x (single-node setup)
- Apache Spark 3.x (standalone mode)
- Apache Hive 3.x
- Java 8 or 11

### Installation

1. **Clone the repository**
   ```bash
   cd /path/to/x-sentimental-analysis
   ```

2. **Install Python dependencies**
   ```bash
   ./scripts/setup/install_dependencies.sh
   ```

3. **Activate virtual environment**
   ```bash
   source .venv/bin/activate
   ```

4. **Configure Hadoop, Spark, and Hive**
   - Follow configuration templates in `config/` directory
   - Set up single-node Hadoop cluster
   - Configure Spark with Hive support
   - Initialize Hive metastore

5. **Create Hive tables**
   ```bash
   # From Hive CLI or Spark SQL
   source analytics/queries/create_tables.sql
   ```

## 📊 Usage

### Running the Complete Pipeline

```bash
./scripts/deployment/run_batch_pipeline.sh
```

### Individual Components

**Load offline dataset:**
```python
from ingestion.offline.sentiment140_loader import Sentiment140Loader
from utils.spark_utils import create_spark_session

spark = create_spark_session()
loader = Sentiment140Loader(spark)
df = loader.load_csv("path/to/sentiment140.csv")
```

**Text normalization:**
```python
from processing.normalization.text_cleaner import TextCleaner

cleaner = TextCleaner()
cleaned_df = cleaner.clean_dataframe(df)
```

**VADER sentiment analysis:**
```python
from processing.sentiment.vader_analyzer import VaderSentimentAnalyzer

analyzer = VaderSentimentAnalyzer()
sentiment_df = analyzer.analyze_dataframe(cleaned_df)
```

**Train ML classifier:**
```python
from processing.ml_pipeline.classifier import SentimentClassifier

classifier = SentimentClassifier()
model = classifier.train(training_data)
metrics = classifier.evaluate(test_data)
```

## 📈 Analytics Queries

Run SQL queries from `analytics/queries/`:

```sql
-- Overall sentiment distribution
SELECT sentiment_category, COUNT(*) 
FROM curated_tweets 
GROUP BY sentiment_category;

-- Sentiment trends over time
SELECT date, AVG(compound) as avg_sentiment
FROM curated_tweets
GROUP BY date
ORDER BY date;
```

## 🎯 Project Milestones

- [x] **Milestone 0**: Project structure setup
- [ ] **Milestone 1**: Hadoop, Spark, Hive installation and validation
- [ ] **Milestone 2**: Sample dataset processing with VADER
- [ ] **Milestone 3**: ML classifier training and evaluation
- [ ] **Milestone 4**: X API integration (if access permits)

## 📝 Configuration

### Environment Variables

```bash
# X API credentials (optional, for live ingestion)
export X_BEARER_TOKEN="your_bearer_token_here"

# Hadoop/Spark paths
export HADOOP_HOME="/opt/hadoop"
export SPARK_HOME="/opt/spark"
export HIVE_HOME="/opt/hive"
```

## 🧪 Testing

```bash
# Run unit tests
python -m pytest tests/unit/

# Run integration tests
python -m pytest tests/integration/
```

## 📚 Documentation

- See `documentation.md` for detailed project overview and architecture
- See `status.md` for current development status
- Individual module READMEs in each directory

## 🔗 References

- [Apache Spark MLlib Documentation](https://spark.apache.org/docs/latest/ml-guide.html)
- [Hadoop Single Node Setup](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)
- [Spark-Hive Integration](https://spark.apache.org/docs/latest/sql-data-sources-hive-tables.html)
- [NLTK VADER Sentiment](https://www.nltk.org/howto/sentiment.html)
- [X API v2 Documentation](https://developer.x.com/en/docs/x-api)
- [Sentiment140 Dataset](https://www.kaggle.com/datasets/kazanova/sentiment140)

## 📄 License

Educational project for Big Data sentiment analysis pipeline demonstration.

## 👤 Author

Rahul Vyasm

---

**Note**: This is a no-Docker setup designed for local development and learning. For production deployments, consider containerization and cloud-native solutions.

