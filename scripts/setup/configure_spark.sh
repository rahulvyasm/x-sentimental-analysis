#!/bin/bash
# Configure Apache Spark with Hive Support

set -e

echo "=========================================="
echo "Spark Configuration Script"
echo "=========================================="

SPARK_HOME="${SPARK_HOME:-/opt/spark}"
HADOOP_HOME="${HADOOP_HOME:-/opt/hadoop}"
HIVE_HOME="${HIVE_HOME:-/opt/hive}"

if [ ! -d "$SPARK_HOME" ]; then
    echo "ERROR: Spark not found at $SPARK_HOME"
    echo "Please install Spark first: ./scripts/setup/install_spark.sh"
    exit 1
fi

SPARK_CONF_DIR="$SPARK_HOME/conf"

echo "Configuring Spark at: $SPARK_HOME"
echo ""

# Step 1: Create spark-env.sh
echo "Step 1: Configuring spark-env.sh..."
cp "$SPARK_CONF_DIR/spark-env.sh.template" "$SPARK_CONF_DIR/spark-env.sh" 2>/dev/null || true

cat >> "$SPARK_CONF_DIR/spark-env.sh" << EOF

# Java Home
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

# Hadoop Configuration
export HADOOP_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop

# Hive Configuration
export HIVE_HOME=$HIVE_HOME
export HIVE_CONF_DIR=\$HIVE_HOME/conf

# Spark Configuration
export SPARK_MASTER_HOST=localhost
export SPARK_LOCAL_IP=127.0.0.1
export SPARK_LOG_DIR=\$SPARK_HOME/logs
export SPARK_WORKER_DIR=\$SPARK_HOME/work
EOF

# Step 2: Create spark-defaults.conf
echo "Step 2: Configuring spark-defaults.conf..."
cat > "$SPARK_CONF_DIR/spark-defaults.conf" << 'EOF'
# Spark Configuration for Twitter Sentiment Analysis

# Application Properties
spark.app.name                  TwitterSentimentAnalysis
spark.master                    local[*]

# Driver and Executor Memory
spark.driver.memory             4g
spark.executor.memory           4g
spark.executor.cores            2

# Hive Integration
spark.sql.warehouse.dir         /user/hive/warehouse
spark.sql.catalogImplementation hive

# Hadoop Configuration
spark.hadoop.fs.defaultFS       hdfs://localhost:9000

# Serialization
spark.serializer                org.apache.spark.serializer.KryoSerializer

# UI and History
spark.ui.port                   4040
spark.history.fs.logDirectory   hdfs://localhost:9000/spark-logs

# Python Configuration
spark.pyspark.python            python3
spark.pyspark.driver.python     python3

# Performance Tuning
spark.sql.adaptive.enabled      true
spark.sql.adaptive.coalescePartitions.enabled true
EOF

# Step 3: Create log4j2.properties
echo "Step 3: Configuring logging..."
if [ -f "$SPARK_CONF_DIR/log4j2.properties.template" ]; then
    cp "$SPARK_CONF_DIR/log4j2.properties.template" "$SPARK_CONF_DIR/log4j2.properties"
fi

# Step 4: Create Spark history directory in HDFS (if Hadoop is running)
echo "Step 4: Setting up Spark history directory..."
if command -v hdfs &> /dev/null; then
    hdfs dfs -mkdir -p /spark-logs 2>/dev/null || echo "HDFS not running or spark-logs already exists"
else
    echo "HDFS command not available, skipping history directory creation"
fi

echo ""
echo "=========================================="
echo "Spark configuration complete!"
echo "=========================================="
echo ""
echo "Configuration files created in: $SPARK_CONF_DIR"
echo ""
echo "NEXT STEPS:"
echo "1. Start Spark standalone:"
echo "   \$SPARK_HOME/sbin/start-master.sh"
echo "   \$SPARK_HOME/sbin/start-worker.sh spark://localhost:7077"
echo ""
echo "2. Test Spark:"
echo "   spark-shell --version"
echo "   pyspark"
echo ""
echo "3. Access Spark UI:"
echo "   Master UI: http://localhost:8080"
echo "   Application UI: http://localhost:4040"
echo ""

