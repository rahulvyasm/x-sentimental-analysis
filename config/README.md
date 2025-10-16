# Configuration Module

Configuration files for Hadoop, Spark, and Hive setup.

## Structure

- **hadoop/** - Hadoop configuration
  - core-site.xml
  - hdfs-site.xml
  - Single-node cluster settings

- **spark/** - Spark configuration
  - spark-defaults.conf
  - spark-env.sh
  - Hive integration settings

- **hive/** - Hive configuration
  - hive-site.xml
  - Metastore configuration
  - Warehouse location

## Notes

- All configurations for no-Docker local setup
- Single-node/pseudo-distributed mode
- enableHiveSupport integration

