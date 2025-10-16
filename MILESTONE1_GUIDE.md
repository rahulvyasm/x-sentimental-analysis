# Milestone 1: Environment Setup Guide

Complete step-by-step guide for setting up Hadoop, Spark, and Hive for the Twitter Sentiment Analysis Pipeline.

## 📋 Prerequisites

- [x] Linux/Ubuntu system
- [x] Java installed (you have Java 21)
- [x] At least 8GB RAM
- [x] 20GB+ free disk space
- [x] sudo access

## 🚀 Installation Options

### Option A: Automated Installation (Recommended)

Run the master setup script that installs everything:

```bash
# From project root
./scripts/setup/setup_bigdata_stack.sh
```

This will:
1. Install Hadoop 3.4.0 to `/opt/hadoop`
2. Install Spark 3.5.1 to `/opt/spark`
3. Install Hive 3.1.3 to `/opt/hive`
4. Configure all components
5. Update your `~/.bashrc` with environment variables

### Option B: Manual Step-by-Step Installation

If you prefer to install components individually:

```bash
# 1. Install Hadoop
sudo ./scripts/setup/install_hadoop.sh
sudo ./scripts/setup/configure_hadoop.sh

# 2. Install Spark
sudo ./scripts/setup/install_spark.sh
sudo ./scripts/setup/configure_spark.sh

# 3. Install Hive
sudo ./scripts/setup/install_hive.sh
sudo ./scripts/setup/configure_hive.sh
```

## 🔧 Post-Installation Setup

### Step 1: Update Your Environment

```bash
# Reload bash configuration
source ~/.bashrc

# Verify environment variables
echo $HADOOP_HOME  # Should show /opt/hadoop
echo $SPARK_HOME   # Should show /opt/spark
echo $HIVE_HOME    # Should show /opt/hive
```

### Step 2: Set Up SSH (Required for Hadoop)

Hadoop requires passwordless SSH to localhost:

```bash
# Generate SSH key (press Enter for all prompts)
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa

# Add key to authorized keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Set correct permissions
chmod 0600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

# Test SSH (type 'yes' to accept fingerprint)
ssh localhost
# Type 'exit' to disconnect
```

### Step 3: Format HDFS (ONE TIME ONLY!)

**⚠️ WARNING: This erases all HDFS data. Only do this for initial setup!**

```bash
hdfs namenode -format
```

You should see: `Storage directory /opt/hadoop/data/namenode has been successfully formatted.`

### Step 4: Start Hadoop Services

```bash
# Start HDFS
start-dfs.sh

# Start YARN
start-yarn.sh

# Verify services are running
jps
```

You should see:
- NameNode
- DataNode
- SecondaryNameNode
- ResourceManager
- NodeManager

### Step 5: Create HDFS Directories

```bash
# Create Hive warehouse directory
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp
hdfs dfs -mkdir -p /user/$USER

# Set permissions
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -chmod g+w /tmp

# Verify
hdfs dfs -ls /
```

### Step 6: Initialize Hive Metastore (ONE TIME ONLY!)

```bash
# Initialize the Derby metastore
$HIVE_HOME/bin/schematool -dbType derby -initSchema
```

You should see: `Initialization script completed`

### Step 7: Start Hive Metastore Service

```bash
# Start metastore in background
nohup hive --service metastore > /tmp/hive-metastore.log 2>&1 &

# Check if it's running
ps aux | grep metastore
```

### Step 8: Test Hive

```bash
# Start Hive CLI
hive

# Inside Hive, run:
SHOW DATABASES;
CREATE DATABASE test;
USE test;
CREATE TABLE test_table (id INT, name STRING);
SHOW TABLES;
DROP TABLE test_table;
DROP DATABASE test;
quit;
```

## ✅ Verification

Run the verification script to check everything:

```bash
./scripts/setup/verify_installation.sh
```

This will check:
- ✓ All components installed
- ✓ Services running
- ✓ HDFS accessible
- ✓ Environment variables set
- ✓ Basic functionality tests

## 🌐 Web Interfaces

Once services are running, access the web UIs:

| Service | URL | Description |
|---------|-----|-------------|
| HDFS NameNode | http://localhost:9870 | Browse HDFS files |
| YARN ResourceManager | http://localhost:8088 | Monitor jobs |
| Spark Master | http://localhost:8080 | Spark cluster status |
| Spark Application | http://localhost:4040 | Running Spark app |

## 🎯 Create Project Hive Tables

```bash
# From project root, create the sentiment analysis tables
hive -f analytics/queries/create_tables.sql

# Verify tables were created
hive -e "USE twitter_sentiment; SHOW TABLES;"
```

You should see:
- `raw_tweets`
- `curated_tweets`
- `ml_predictions`

## 🔄 Daily Operations

### Starting Services

```bash
# Start Hadoop
start-dfs.sh
start-yarn.sh

# Start Hive Metastore (if not running)
nohup hive --service metastore > /tmp/hive-metastore.log 2>&1 &
```

### Stopping Services

```bash
# Stop Hadoop
stop-yarn.sh
stop-dfs.sh

# Stop Hive Metastore
ps aux | grep metastore | grep -v grep | awk '{print $2}' | xargs kill
```

### Check Status

```bash
# See all Java processes (Hadoop/Spark/Hive)
jps

# Check HDFS
hdfs dfsadmin -report

# Check HDFS web UI
curl -s http://localhost:9870 | grep title
```

## 🐛 Troubleshooting

### Issue: "Permission denied" for SSH

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Issue: HDFS not starting

```bash
# Check logs
cat $HADOOP_HOME/logs/hadoop-*-namenode-*.log

# Format namenode (WARNING: erases data!)
stop-dfs.sh
rm -rf /opt/hadoop/data/*
hdfs namenode -format
start-dfs.sh
```

### Issue: Port already in use

```bash
# Check what's using port 9000 (HDFS)
lsof -i :9000

# Kill the process if needed
kill -9 <PID>
```

### Issue: Java version incompatibility

Hadoop/Spark work best with Java 8 or 11. You have Java 21. If you encounter issues:

```bash
# Install Java 11
sudo apt install openjdk-11-jdk

# Set Java 11 as default
sudo update-alternatives --config java
```

### Issue: Hive metastore connection error

```bash
# Remove existing metastore and reinitialize
rm -rf $HIVE_HOME/metastore_db
$HIVE_HOME/bin/schematool -dbType derby -initSchema
```

## 📚 Next Steps

Once Milestone 1 is complete:

1. ✅ Verify all services are running
2. ✅ Create Hive tables
3. ✅ Test with sample data
4. ➡️ Move to **Milestone 2**: Data Processing Pipeline
5. ➡️ Download Sentiment140 dataset
6. ➡️ Run first sentiment analysis job

## 📝 Useful Commands Reference

```bash
# HDFS Commands
hdfs dfs -ls /
hdfs dfs -mkdir /mydir
hdfs dfs -put localfile.txt /hdfs/path/
hdfs dfs -get /hdfs/path/file.txt localfile.txt
hdfs dfs -rm /hdfs/path/file.txt

# Hive Commands (CLI)
hive -e "SHOW DATABASES;"
hive -f script.sql
hive  # Interactive mode

# Spark Commands
spark-shell  # Scala REPL
pyspark      # Python REPL
spark-submit myapp.py

# Check services
jps  # List Java processes
hdfs dfsadmin -report  # HDFS status
```

## ✅ Milestone 1 Checklist

- [ ] Hadoop installed and configured
- [ ] Spark installed and configured
- [ ] Hive installed and configured
- [ ] SSH passwordless login set up
- [ ] HDFS formatted and running
- [ ] YARN running
- [ ] Hive metastore initialized
- [ ] Hive tables created
- [ ] All web UIs accessible
- [ ] Verification script passes

Once all items are checked, Milestone 1 is complete! 🎉

---

**Need Help?**
- Check logs in `/opt/hadoop/logs/`, `/opt/spark/logs/`
- Run `./scripts/setup/verify_installation.sh`
- Review official documentation links in `documentation.md`

