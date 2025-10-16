#!/bin/bash
# Install Apache Spark 3.5.1 (Standalone Mode)

set -e  # Exit on error

echo "=========================================="
echo "Apache Spark 3.5.1 Installation Script"
echo "=========================================="

# Configuration
SPARK_VERSION="3.5.1"
HADOOP_VERSION="3"  # Spark built for Hadoop 3
INSTALL_DIR="/opt"
SPARK_HOME="$INSTALL_DIR/spark"
DOWNLOAD_URL="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

# Check if running as root for /opt installation
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Note: $INSTALL_DIR is not writable. You may need sudo permissions."
    echo "Run with: sudo ./scripts/setup/install_spark.sh"
    exit 1
fi

# Check Java installation
if ! command -v java &> /dev/null; then
    echo "ERROR: Java is not installed. Please install Java 8 or 11."
    exit 1
fi

echo "Java version detected:"
java -version

# Create installation directory
echo ""
echo "Step 1: Creating installation directory..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Download Spark if not already present
if [ ! -f "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" ]; then
    echo ""
    echo "Step 2: Downloading Spark ${SPARK_VERSION}..."
    echo "From: $DOWNLOAD_URL"
    wget "$DOWNLOAD_URL" || {
        echo "ERROR: Failed to download Spark. Please check your internet connection."
        exit 1
    }
else
    echo ""
    echo "Step 2: Spark tarball already exists, skipping download..."
fi

# Extract Spark
echo ""
echo "Step 3: Extracting Spark..."
if [ -d "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" ]; then
    echo "Removing existing directory..."
    rm -rf "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
fi
tar -xzf "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

# Create symbolic link
echo ""
echo "Step 4: Creating symbolic link..."
if [ -L "$SPARK_HOME" ]; then
    rm "$SPARK_HOME"
fi
ln -s "$INSTALL_DIR/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" "$SPARK_HOME"

echo ""
echo "Step 5: Setting up Spark directories..."
mkdir -p "$SPARK_HOME/logs"
mkdir -p "$SPARK_HOME/work"

echo ""
echo "=========================================="
echo "Spark installation complete!"
echo "=========================================="
echo ""
echo "Spark installed at: $SPARK_HOME"
echo ""
echo "NEXT STEPS:"
echo "1. Configure Spark (run: ./scripts/setup/configure_spark.sh)"
echo "2. Add to ~/.bashrc:"
echo ""
echo "   export SPARK_HOME=$SPARK_HOME"
echo "   export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin"
echo "   export PYSPARK_PYTHON=python3"
echo ""
echo "3. Source the file: source ~/.bashrc"
echo "4. Test Spark: spark-shell --version"
echo "5. Start Spark: \$SPARK_HOME/sbin/start-all.sh"
echo ""

