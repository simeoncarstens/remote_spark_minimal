#!/usr/bin/env bash

export SPARK_HOME=$PWD/.venv/lib/python3.10/site-packages/pyspark
# required to not have Hadoop stuff use the local user name (like carsts02)
export HADOOP_USER_NAME=hdfs
# set this to the directory with the Hadoop configuration (/etc/hadoop/conf) downloaded from the EMR master instance
export HADOOP_CONF_DIR=/hadoop_conf/
# set this to the directory containing necessary extra Java classes for the driver, namely
# - hadoop-common.jar
# - hadoop-aws.jar
# - emrfs-hadoop-assembly-2.47.0.jar
# - hadoop-lzo.jar
export DRIVER_CLASSES_DIRNAME="/driver_dependencies/classes/"
# hadoop_native needs to contain libgplcompression.so, which, for the EMR Hadoop installation, can be found
# in /usr/lib/hadoop-lzo/lib/native/
export HADOOP_OPTS="-Djava.library.path=/driver_dependencies/hadoop_native"
export LD_LIBRARY_PATH="/driver_dependencies/hadoop_native"
