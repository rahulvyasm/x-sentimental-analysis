#!/bin/bash
# Install and configure Hadoop 3.4.0 (Single-Node/Pseudo-Distributed)

set -e  # Exit on error

echo "=========================================="
echo "Hadoop 3.4.0 Installation Script"
echo "=========================================="

# Configuration
HADOOP_VERSION="3.4.0"
INSTALL_DIR="/opt"
HADOOP_HOME="$INSTALL_DIR/hadoop"
DOWNLOAD_URL="https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

# Check if running as root for /opt installation
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Note: $INSTALL_DIR is not writable. You may need sudo permissions."
    echo "Run with: sudo ./scripts/setup/install_hadoop.sh"
    echo "Or change INSTALL_DIR in this script to a user-writable location."
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

# Download Hadoop if not already present
if [ ! -f "hadoop-${HADOOP_VERSION}.tar.gz" ]; then
    echo ""
    echo "Step 2: Downloading Hadoop ${HADOOP_VERSION}..."
    echo "From: $DOWNLOAD_URL"
    wget "$DOWNLOAD_URL" || {
        echo "ERROR: Failed to download Hadoop. Please check your internet connection."
        exit 1
    }
else
    echo ""
    echo "Step 2: Hadoop tarball already exists, skipping download..."
fi

# Extract Hadoop
echo ""
echo "Step 3: Extracting Hadoop..."
if [ -d "hadoop-${HADOOP_VERSION}" ]; then
    echo "Removing existing hadoop-${HADOOP_VERSION} directory..."
    rm -rf "hadoop-${HADOOP_VERSION}"
fi
tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz"

# Create symbolic link
echo ""
echo "Step 4: Creating symbolic link..."
if [ -L "$HADOOP_HOME" ]; then
    rm "$HADOOP_HOME"
fi
ln -s "$INSTALL_DIR/hadoop-${HADOOP_VERSION}" "$HADOOP_HOME"

echo ""
echo "Step 5: Setting up Hadoop directories..."
mkdir -p "$HADOOP_HOME/data/namenode"
mkdir -p "$HADOOP_HOME/data/datanode"
mkdir -p "$HADOOP_HOME/logs"

echo ""
echo "=========================================="
echo "Hadoop installation complete!"
echo "=========================================="
echo ""
echo "Hadoop installed at: $HADOOP_HOME"
echo ""
echo "NEXT STEPS:"
echo "1. Configure Hadoop (run: ./scripts/setup/configure_hadoop.sh)"
echo "2. Add to ~/.bashrc:"
echo ""
echo "   export HADOOP_HOME=$HADOOP_HOME"
echo "   export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop"
echo "   export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin"
echo ""
echo "3. Source the file: source ~/.bashrc"
echo "4. Format HDFS: hdfs namenode -format"
echo "5. Start Hadoop: start-dfs.sh"
echo ""

