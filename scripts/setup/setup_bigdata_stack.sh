#!/bin/bash
# Master Setup Script for Hadoop + Spark + Hive

set -e

echo "=================================================================="
echo "  Twitter Sentiment Analysis - Big Data Stack Setup"
echo "=================================================================="
echo ""
echo "This script will install and configure:"
echo "  - Apache Hadoop 3.4.0 (Single-Node)"
echo "  - Apache Spark 3.5.3 (Standalone)"
echo "  - Apache Hive 3.1.3"
echo ""
echo "Installation directory: /opt"
echo "NOTE: This requires sudo access!"
echo ""
read -p "Continue with installation? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Store the project directory
PROJECT_DIR=$(pwd)
SCRIPTS_DIR="$PROJECT_DIR/scripts/setup"

echo ""
echo "=================================================================="
echo "Step 1: Installing Hadoop"
echo "=================================================================="
sudo "$SCRIPTS_DIR/install_hadoop.sh"

echo ""
echo "=================================================================="
echo "Step 2: Configuring Hadoop"
echo "=================================================================="
sudo "$SCRIPTS_DIR/configure_hadoop.sh"

echo ""
echo "=================================================================="
echo "Step 3: Installing Spark"
echo "=================================================================="
sudo "$SCRIPTS_DIR/install_spark.sh"

echo ""
echo "=================================================================="
echo "Step 4: Configuring Spark"
echo "=================================================================="
sudo "$SCRIPTS_DIR/configure_spark.sh"

echo ""
echo "=================================================================="
echo "Step 5: Installing Hive"
echo "=================================================================="
sudo "$SCRIPTS_DIR/install_hive.sh"

echo ""
echo "=================================================================="
echo "Step 6: Configuring Hive"
echo "=================================================================="
sudo "$SCRIPTS_DIR/configure_hive.sh"

echo ""
echo "=================================================================="
echo "Step 7: Setting up environment variables"
echo "=================================================================="

ENV_CONFIG="
# Big Data Stack - Added by Twitter Sentiment Analysis setup
export HADOOP_HOME=/opt/hadoop
export SPARK_HOME=/opt/spark
export HIVE_HOME=/opt/hive

export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export SPARK_CONF_DIR=\$SPARK_HOME/conf
export HIVE_CONF_DIR=\$HIVE_HOME/conf

export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin
export PATH=\$PATH:\$HIVE_HOME/bin

export PYSPARK_PYTHON=python3
export PYSPARK_DRIVER_PYTHON=python3
"

# Check if already added
if ! grep -q "Big Data Stack" ~/.bashrc; then
    echo "$ENV_CONFIG" >> ~/.bashrc
    echo "Environment variables added to ~/.bashrc"
else
    echo "Environment variables already present in ~/.bashrc"
fi

echo ""
echo "=================================================================="
echo "  Installation Complete!"
echo "=================================================================="
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Source your environment:"
echo "   source ~/.bashrc"
echo ""
echo "2. Set up SSH for Hadoop:"
echo "   ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"
echo "   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
echo "   chmod 0600 ~/.ssh/authorized_keys"
echo "   ssh localhost  # Test and accept fingerprint"
echo ""
echo "3. Format HDFS (ONLY DO THIS ONCE):"
echo "   hdfs namenode -format"
echo ""
echo "4. Start services:"
echo "   start-dfs.sh        # Start Hadoop"
echo "   start-yarn.sh       # Start YARN"
echo "   \$HIVE_HOME/bin/schematool -dbType derby -initSchema  # Init Hive"
echo ""
echo "5. Verify installation:"
echo "   ./scripts/setup/verify_installation.sh"
echo ""
echo "6. Create Hive tables:"
echo "   hive -f analytics/queries/create_tables.sql"
echo ""
echo "=================================================================="

