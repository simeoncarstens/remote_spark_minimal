#!/usr/bin/env bash

THIS_DIR=$(pwd)

export SPARK_HOME=/usr/local/lib/python3.10/site-packages/pyspark
# required to not have Hadoop stuff use the local user name (like carsts02)
export HADOOP_USER_NAME=hdfs
# set this to the directory with the Hadoop configuration (/etc/hadoop/conf) downloaded from the EMR master instance
export HADOOP_CONF_DIR=/hadoop_conf/
# set this to the directory containing necessary extra Java classes for the driver, namely
# - hadoop-common.jar
# - hadoop-aws.jar
# - emrfs-hadoop-assembly-2.47.0.jar
export DRIVER_CLASSES_DIRNAME=/driver_classes/
