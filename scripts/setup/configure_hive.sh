#!/bin/bash
# Configure Apache Hive with Derby Metastore

set -e

echo "=========================================="
echo "Hive Configuration Script"
echo "=========================================="

HIVE_HOME="${HIVE_HOME:-/opt/hive}"
HADOOP_HOME="${HADOOP_HOME:-/opt/hadoop}"

if [ ! -d "$HIVE_HOME" ]; then
    echo "ERROR: Hive not found at $HIVE_HOME"
    echo "Please install Hive first: ./scripts/setup/install_hive.sh"
    exit 1
fi

HIVE_CONF_DIR="$HIVE_HOME/conf"
mkdir -p "$HIVE_CONF_DIR"

echo "Configuring Hive at: $HIVE_HOME"
echo ""

# Step 1: Create hive-env.sh
echo "Step 1: Configuring hive-env.sh..."
if [ -f "$HIVE_CONF_DIR/hive-env.sh.template" ]; then
    cp "$HIVE_CONF_DIR/hive-env.sh.template" "$HIVE_CONF_DIR/hive-env.sh"
fi

cat >> "$HIVE_CONF_DIR/hive-env.sh" << EOF

# Hadoop Configuration
export HADOOP_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop

# Hive Configuration
export HIVE_CONF_DIR=$HIVE_CONF_DIR
export HIVE_AUX_JARS_PATH=\$HIVE_HOME/lib
EOF

# Step 2: Create hive-site.xml
echo "Step 2: Configuring hive-site.xml..."
cat > "$HIVE_CONF_DIR/hive-site.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <!-- Metastore Configuration (Derby) -->
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:derby:;databaseName=/opt/hive/metastore_db;create=true</value>
        <description>Derby metastore database</description>
    </property>
    
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.apache.derby.jdbc.EmbeddedDriver</value>
        <description>Derby driver</description>
    </property>
    
    <!-- Warehouse Location -->
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive/warehouse</value>
        <description>Hive warehouse location in HDFS</description>
    </property>
    
    <!-- Metastore Service -->
    <property>
        <name>hive.metastore.uris</name>
        <value>thrift://localhost:9083</value>
        <description>Metastore server URI</description>
    </property>
    
    <!-- Execution Engine -->
    <property>
        <name>hive.execution.engine</name>
        <value>mr</value>
        <description>Execution engine: mr (MapReduce) or spark</description>
    </property>
    
    <!-- Security and Permissions -->
    <property>
        <name>hive.metastore.schema.verification</name>
        <value>false</value>
    </property>
    
    <property>
        <name>hive.server2.enable.doAs</name>
        <value>false</value>
    </property>
    
    <!-- Performance -->
    <property>
        <name>hive.exec.dynamic.partition.mode</name>
        <value>nonstrict</value>
    </property>
    
    <property>
        <name>hive.exec.max.dynamic.partitions</name>
        <value>10000</value>
    </property>
    
    <!-- CLI Configuration -->
    <property>
        <name>hive.cli.print.header</name>
        <value>true</value>
        <description>Print column names in query results</description>
    </property>
    
    <property>
        <name>hive.cli.print.current.db</name>
        <value>true</value>
        <description>Show current database in CLI prompt</description>
    </property>
</configuration>
EOF

# Step 3: Create Hive directories in HDFS
echo "Step 3: Creating Hive directories in HDFS..."
if command -v hdfs &> /dev/null; then
    echo "Creating /user/hive/warehouse in HDFS..."
    hdfs dfs -mkdir -p /user/hive/warehouse 2>/dev/null || echo "Directory already exists"
    hdfs dfs -mkdir -p /tmp 2>/dev/null || echo "Directory already exists"
    hdfs dfs -chmod g+w /user/hive/warehouse 2>/dev/null || true
    hdfs dfs -chmod g+w /tmp 2>/dev/null || true
else
    echo "WARNING: HDFS not available. Make sure to create directories after starting Hadoop."
fi

# Step 4: Remove problematic JAR (Guava conflict)
echo "Step 4: Checking for JAR conflicts..."
if [ -f "$HIVE_HOME/lib/guava-19.0.jar" ]; then
    echo "Removing conflicting Guava JAR..."
    rm "$HIVE_HOME/lib/guava-19.0.jar"
fi

echo ""
echo "=========================================="
echo "Hive configuration complete!"
echo "=========================================="
echo ""
echo "Configuration files created in: $HIVE_CONF_DIR"
echo ""
echo "NEXT STEPS:"
echo "1. Initialize Hive metastore schema (ONLY DO THIS ONCE):"
echo "   \$HIVE_HOME/bin/schematool -dbType derby -initSchema"
echo ""
echo "2. Start Hive metastore service (in background):"
echo "   hive --service metastore &"
echo ""
echo "3. Start Hive CLI:"
echo "   hive"
echo ""
echo "4. Test Hive:"
echo "   SHOW DATABASES;"
echo "   CREATE DATABASE test;"
echo ""
echo "5. Create project tables:"
echo "   source analytics/queries/create_tables.sql"
echo ""

