#!/bin/bash
# Install Apache Hive 3.1.3

set -e  # Exit on error

echo "=========================================="
echo "Apache Hive 3.1.3 Installation Script"
echo "=========================================="

# Configuration
HIVE_VERSION="3.1.3"
INSTALL_DIR="/opt"
HIVE_HOME="$INSTALL_DIR/hive"
DOWNLOAD_URL="https://dlcdn.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"

# Check if running as root for /opt installation
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Note: $INSTALL_DIR is not writable. You may need sudo permissions."
    echo "Run with: sudo ./scripts/setup/install_hive.sh"
    exit 1
fi

# Check Java installation
if ! command -v java &> /dev/null; then
    echo "ERROR: Java is not installed. Please install Java 8 or 11."
    exit 1
fi

# Check Hadoop installation
if [ -z "$HADOOP_HOME" ] && [ ! -d "/opt/hadoop" ]; then
    echo "WARNING: Hadoop not found. Please install Hadoop first."
    echo "Run: ./scripts/setup/install_hadoop.sh"
fi

echo "Java version detected:"
java -version

# Create installation directory
echo ""
echo "Step 1: Creating installation directory..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Download Hive if not already present
if [ ! -f "apache-hive-${HIVE_VERSION}-bin.tar.gz" ]; then
    echo ""
    echo "Step 2: Downloading Hive ${HIVE_VERSION}..."
    echo "From: $DOWNLOAD_URL"
    wget "$DOWNLOAD_URL" || {
        echo "ERROR: Failed to download Hive. Please check your internet connection."
        exit 1
    }
else
    echo ""
    echo "Step 2: Hive tarball already exists, skipping download..."
fi

# Extract Hive
echo ""
echo "Step 3: Extracting Hive..."
if [ -d "apache-hive-${HIVE_VERSION}-bin" ]; then
    echo "Removing existing directory..."
    rm -rf "apache-hive-${HIVE_VERSION}-bin"
fi
tar -xzf "apache-hive-${HIVE_VERSION}-bin.tar.gz"

# Create symbolic link
echo ""
echo "Step 4: Creating symbolic link..."
if [ -L "$HIVE_HOME" ]; then
    rm "$HIVE_HOME"
fi
ln -s "$INSTALL_DIR/apache-hive-${HIVE_VERSION}-bin" "$HIVE_HOME"

echo ""
echo "Step 5: Setting up Hive directories..."
mkdir -p "$HIVE_HOME/logs"

echo ""
echo "=========================================="
echo "Hive installation complete!"
echo "=========================================="
echo ""
echo "Hive installed at: $HIVE_HOME"
echo ""
echo "NEXT STEPS:"
echo "1. Configure Hive (run: ./scripts/setup/configure_hive.sh)"
echo "2. Add to ~/.bashrc:"
echo ""
echo "   export HIVE_HOME=$HIVE_HOME"
echo "   export PATH=\$PATH:\$HIVE_HOME/bin"
echo ""
echo "3. Source the file: source ~/.bashrc"
echo "4. Initialize Hive metastore: schematool -dbType derby -initSchema"
echo "5. Start Hive: hive"
echo ""

