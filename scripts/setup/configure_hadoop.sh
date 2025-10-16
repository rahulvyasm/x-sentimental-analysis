#!/bin/bash
# Configure Hadoop for Single-Node/Pseudo-Distributed Mode

set -e

echo "=========================================="
echo "Hadoop Configuration Script"
echo "=========================================="

HADOOP_HOME="${HADOOP_HOME:-/opt/hadoop}"

if [ ! -d "$HADOOP_HOME" ]; then
    echo "ERROR: Hadoop not found at $HADOOP_HOME"
    echo "Please install Hadoop first: ./scripts/setup/install_hadoop.sh"
    exit 1
fi

HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"

echo "Configuring Hadoop at: $HADOOP_HOME"
echo ""

# Get Java home
JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which java))))
echo "Detected JAVA_HOME: $JAVA_HOME_PATH"

# Step 1: Configure hadoop-env.sh
echo "Step 1: Configuring hadoop-env.sh..."
cat >> "$HADOOP_CONF_DIR/hadoop-env.sh" << EOF

# Java Home
export JAVA_HOME=$JAVA_HOME_PATH

# Hadoop directories
export HADOOP_LOG_DIR=\${HADOOP_HOME}/logs
export HADOOP_PID_DIR=\${HADOOP_HOME}/pids
EOF

# Step 2: Configure core-site.xml
echo "Step 2: Configuring core-site.xml..."
cat > "$HADOOP_CONF_DIR/core-site.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
        <description>NameNode URI</description>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/opt/hadoop/data/tmp</value>
        <description>Temporary directory</description>
    </property>
</configuration>
EOF

# Step 3: Configure hdfs-site.xml
echo "Step 3: Configuring hdfs-site.xml..."
cat > "$HADOOP_CONF_DIR/hdfs-site.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
        <description>Replication factor (1 for single-node)</description>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///opt/hadoop/data/namenode</value>
        <description>NameNode directory</description>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///opt/hadoop/data/datanode</value>
        <description>DataNode directory</description>
    </property>
    <property>
        <name>dfs.namenode.http-address</name>
        <value>localhost:9870</value>
        <description>NameNode Web UI</description>
    </property>
</configuration>
EOF

# Step 4: Configure mapred-site.xml
echo "Step 4: Configuring mapred-site.xml..."
cat > "$HADOOP_CONF_DIR/mapred-site.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
        <description>Execution framework</description>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
EOF

# Step 5: Configure yarn-site.xml
echo "Step 5: Configuring yarn-site.xml..."
cat > "$HADOOP_CONF_DIR/yarn-site.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
EOF

# Create necessary directories
echo ""
echo "Step 6: Creating Hadoop directories..."
mkdir -p "$HADOOP_HOME/data/tmp"
mkdir -p "$HADOOP_HOME/data/namenode"
mkdir -p "$HADOOP_HOME/data/datanode"
mkdir -p "$HADOOP_HOME/logs"
mkdir -p "$HADOOP_HOME/pids"

echo ""
echo "=========================================="
echo "Hadoop configuration complete!"
echo "=========================================="
echo ""
echo "Configuration files created in: $HADOOP_CONF_DIR"
echo ""
echo "NEXT STEPS:"
echo "1. Set up SSH passwordless login:"
echo "   ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"
echo "   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
echo "   chmod 0600 ~/.ssh/authorized_keys"
echo ""
echo "2. Format HDFS (ONLY DO THIS ONCE):"
echo "   hdfs namenode -format"
echo ""
echo "3. Start Hadoop:"
echo "   start-dfs.sh"
echo "   start-yarn.sh"
echo ""
echo "4. Verify installation:"
echo "   hdfs dfs -ls /"
echo "   Visit: http://localhost:9870"
echo ""

