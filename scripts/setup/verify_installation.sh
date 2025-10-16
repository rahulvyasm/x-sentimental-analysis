#!/bin/bash
# Verification script for Big Data Stack installation

echo "=================================================================="
echo "  Big Data Stack Installation Verification"
echo "=================================================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check function
check_command() {
    local name=$1
    local command=$2
    
    if command -v $command &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name is installed"
        return 0
    else
        echo -e "${RED}✗${NC} $name is NOT installed"
        return 1
    fi
}

# Check service
check_service() {
    local name=$1
    local check_cmd=$2
    
    if eval "$check_cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name is running"
        return 0
    else
        echo -e "${YELLOW}!${NC} $name is NOT running"
        return 1
    fi
}

echo "1. Checking Installations..."
echo "----------------------------"
check_command "Java" "java"
check_command "Hadoop" "hadoop"
check_command "Spark" "spark-submit"
check_command "Hive" "hive"
check_command "HDFS" "hdfs"
check_command "PySpark" "pyspark"

echo ""
echo "2. Checking Versions..."
echo "----------------------------"

if command -v java &> /dev/null; then
    echo "Java version:"
    java -version 2>&1 | head -1 | sed 's/^/  /'
fi

if command -v hadoop &> /dev/null; then
    echo "Hadoop version:"
    hadoop version 2>&1 | head -1 | sed 's/^/  /'
fi

if command -v spark-submit &> /dev/null; then
    echo "Spark version:"
    spark-submit --version 2>&1 | grep version | head -1 | sed 's/^/  /'
fi

if command -v hive &> /dev/null; then
    echo "Hive version:"
    hive --version 2>&1 | head -1 | sed 's/^/  /'
fi

echo ""
echo "3. Checking Services..."
echo "----------------------------"
check_service "HDFS NameNode" "jps | grep -q NameNode"
check_service "HDFS DataNode" "jps | grep -q DataNode"
check_service "YARN ResourceManager" "jps | grep -q ResourceManager"
check_service "YARN NodeManager" "jps | grep -q NodeManager"

echo ""
echo "4. Checking HDFS..."
echo "----------------------------"
if hdfs dfs -ls / &> /dev/null; then
    echo -e "${GREEN}✓${NC} HDFS is accessible"
    echo "HDFS directories:"
    hdfs dfs -ls / 2>/dev/null | sed 's/^/  /'
else
    echo -e "${YELLOW}!${NC} HDFS is not accessible or not formatted"
fi

echo ""
echo "5. Checking Environment Variables..."
echo "----------------------------"
[ -n "$HADOOP_HOME" ] && echo -e "${GREEN}✓${NC} HADOOP_HOME = $HADOOP_HOME" || echo -e "${RED}✗${NC} HADOOP_HOME not set"
[ -n "$SPARK_HOME" ] && echo -e "${GREEN}✓${NC} SPARK_HOME = $SPARK_HOME" || echo -e "${RED}✗${NC} SPARK_HOME not set"
[ -n "$HIVE_HOME" ] && echo -e "${GREEN}✓${NC} HIVE_HOME = $HIVE_HOME" || echo -e "${RED}✗${NC} HIVE_HOME not set"

echo ""
echo "6. Checking Web UIs..."
echo "----------------------------"
echo "If services are running, access them at:"
echo "  - HDFS NameNode UI: http://localhost:9870"
echo "  - YARN ResourceManager: http://localhost:8088"
echo "  - Spark Master UI: http://localhost:8080"
echo "  - Spark Application UI: http://localhost:4040"

echo ""
echo "7. Testing Basic Functionality..."
echo "----------------------------"

# Test HDFS
if command -v hdfs &> /dev/null && hdfs dfs -ls / &> /dev/null; then
    TEST_FILE="/test_$(date +%s).txt"
    echo "test" | hdfs dfs -put - "$TEST_FILE" 2>/dev/null && \
    hdfs dfs -cat "$TEST_FILE" &>/dev/null && \
    hdfs dfs -rm "$TEST_FILE" &>/dev/null && \
    echo -e "${GREEN}✓${NC} HDFS read/write test passed" || \
    echo -e "${YELLOW}!${NC} HDFS read/write test failed"
fi

# Test PySpark
if command -v pyspark &> /dev/null; then
    if pyspark --version &> /dev/null; then
        echo -e "${GREEN}✓${NC} PySpark is functional"
    else
        echo -e "${YELLOW}!${NC} PySpark test inconclusive"
    fi
fi

echo ""
echo "=================================================================="
echo "  Verification Complete!"
echo "=================================================================="
echo ""
echo "If any services are not running, start them with:"
echo "  - Hadoop: start-dfs.sh && start-yarn.sh"
echo "  - Hive Metastore: hive --service metastore &"
echo ""

