# 🎯 Milestone 1 Ready to Execute!

All installation scripts for Hadoop, Spark, and Hive have been created and are ready to run.

## 📦 What Was Created

### Installation Scripts (9 files)
1. ✅ `install_hadoop.sh` - Installs Hadoop 3.4.0
2. ✅ `install_spark.sh` - Installs Spark 3.5.3  
3. ✅ `install_hive.sh` - Installs Hive 3.1.3
4. ✅ `configure_hadoop.sh` - Configures Hadoop for single-node
5. ✅ `configure_spark.sh` - Configures Spark with Hive support
6. ✅ `configure_hive.sh` - Configures Hive with Derby metastore
7. ✅ `setup_bigdata_stack.sh` - Master installation script
8. ✅ `verify_installation.sh` - Verification and testing tool
9. ✅ `install_dependencies.sh` - Python dependencies (from earlier)

### Documentation
- ✅ `MILESTONE1_GUIDE.md` - Complete step-by-step guide (200+ lines)

## 🚀 Quick Start

### Option 1: Automated Installation (Easiest)

Run one command to install everything:

```bash
cd /home/rahulvyasm/Personal/Projects/x-sentimental-analysis
./scripts/setup/setup_bigdata_stack.sh
```

This will:
- Install Hadoop, Spark, and Hive to `/opt/`
- Configure all three components
- Update your `~/.bashrc` with environment variables
- Prompt you through each step

**Time required:** ~30-45 minutes (mostly download time)

### Option 2: Manual Step-by-Step

If you prefer control over each step:

```bash
# 1. Hadoop
sudo ./scripts/setup/install_hadoop.sh
sudo ./scripts/setup/configure_hadoop.sh

# 2. Spark  
sudo ./scripts/setup/install_spark.sh
sudo ./scripts/setup/configure_spark.sh

# 3. Hive
sudo ./scripts/setup/install_hive.sh
sudo ./scripts/setup/configure_hive.sh
```

## 📋 Post-Installation Checklist

After running the installation, you need to:

### 1. Reload Environment
```bash
source ~/.bashrc
```

### 2. Setup SSH (for Hadoop)
```bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
ssh localhost  # Test it
```

### 3. Format HDFS (ONE TIME ONLY!)
```bash
hdfs namenode -format
```

### 4. Start Services
```bash
start-dfs.sh                    # Start HDFS
start-yarn.sh                   # Start YARN
```

### 5. Initialize Hive
```bash
$HIVE_HOME/bin/schematool -dbType derby -initSchema
```

### 6. Start Hive Metastore
```bash
nohup hive --service metastore > /tmp/hive-metastore.log 2>&1 &
```

### 7. Create Project Tables
```bash
hive -f analytics/queries/create_tables.sql
```

### 8. Verify Everything
```bash
./scripts/setup/verify_installation.sh
```

## ✅ Success Indicators

You'll know everything is working when:

1. ✅ `jps` shows: NameNode, DataNode, ResourceManager, NodeManager
2. ✅ `hdfs dfs -ls /` works without errors
3. ✅ `hive -e "SHOW DATABASES;"` returns databases
4. ✅ `spark-submit --version` shows Spark 3.5.1
5. ✅ Web UI at http://localhost:9870 is accessible
6. ✅ Verification script passes all checks

## 🌐 Web Interfaces

After services start, visit:

| Service | URL | Purpose |
|---------|-----|---------|
| HDFS NameNode | http://localhost:9870 | Browse HDFS files |
| YARN ResourceManager | http://localhost:8088 | Monitor jobs |
| Spark Master | http://localhost:8080 | Spark cluster |
| Spark App | http://localhost:4040 | Running Spark application |

## 📚 Documentation

For detailed instructions, see:
- **MILESTONE1_GUIDE.md** - Complete setup guide with troubleshooting
- **QUICKSTART.md** - Quick start guide
- **documentation.md** - Project architecture and references

## ⚙️ System Requirements Met

- ✅ Java 21 installed (may prefer Java 11, but will work)
- ✅ Linux/Ubuntu system
- ✅ sudo access available
- ✅ Sufficient disk space
- ✅ Network access for downloads

## 🐛 If Something Goes Wrong

1. Check the logs:
   - Hadoop: `/opt/hadoop/logs/`
   - Spark: `/opt/spark/logs/`
   - Hive: `/tmp/hive-metastore.log`

2. Run verification:
   ```bash
   ./scripts/setup/verify_installation.sh
   ```

3. Review troubleshooting section in MILESTONE1_GUIDE.md

4. Common issues:
   - Port conflicts: Kill existing processes on ports 9000, 9870, 8088
   - SSH issues: Check permissions on `~/.ssh/`
   - HDFS format: Only format once, or you'll lose data
   - Java version: If issues persist, try Java 11

## 🎯 What's Next?

After Milestone 1 is complete:

1. **Milestone 2**: Data Processing Pipeline
   - Download Sentiment140 dataset
   - Load to HDFS
   - Run text normalization
   - Apply VADER sentiment analysis

2. **Milestone 3**: ML Pipeline
   - Train supervised classifier
   - Evaluate performance
   - Compare with VADER

3. **Milestone 4**: X API Integration
   - Implement live tweet ingestion
   - Real-time sentiment scoring

## 💡 Pro Tips

1. **Bookmark web UIs** - You'll use them frequently
2. **Alias commands** - Add to `~/.bashrc`:
   ```bash
   alias start-hadoop='start-dfs.sh && start-yarn.sh'
   alias stop-hadoop='stop-yarn.sh && stop-dfs.sh'
   alias hdfs-browse='firefox http://localhost:9870'
   ```
3. **Keep services running** - Once started, keep them running during development
4. **Backup metastore** - Before major changes: `cp -r /opt/hive/metastore_db /opt/hive/metastore_db.backup`

## 📞 Need Help?

- Read MILESTONE1_GUIDE.md for detailed instructions
- Check status.md for current progress
- Review official documentation links in documentation.md
- Test each component individually before running the full pipeline

---

**Ready to proceed?** 

Run: `./scripts/setup/setup_bigdata_stack.sh`

Good luck! 🚀

