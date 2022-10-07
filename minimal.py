import os

import hail as hl
from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession

def get_remote_spark_context() -> SparkContext:
    hail_all_spark_jar = os.path.join(os.path.dirname(hl.__file__), 'backend/hail-all-spark.jar')
    
    if (driver_classes_dirname := os.getenv('DRIVER_CLASSES_DIRNAME')) is None:
        raise ValueError(f"DRIVER_CLASSES_DIRNAME environment variable not set")
    driver_extra_classes = (
      os.path.join(driver_classes_dirname, "hadoop-common.jar"),
      os.path.join(driver_classes_dirname, "hadoop-aws.jar"),
      os.path.join(driver_classes_dirname, "emrfs-hadoop-assembly-2.47.0.jar"),
    )

    # extra Java classes required for the executors (on the AWS EMR cluster, so paths are relative to the working directory there)
    executor_extra_classes = (
    '/usr/lib/hadoop/hadoop-common.jar',
    '/usr/lib/hadoop/hadoop-aws.jar',
    '/usr/share/aws/emr/emrfs/lib/emrfs-hadoop-assembly-2.47.0.jar',
    '/usr/share/aws/emr/instance-controller/lib/stax2-api-3.1.4.jar',
    './hail-all-spark.jar'
)

    driver_extra_class_path = ':'.join(driver_extra_classes)
    executor_extra_class_path = ':'.join(executor_extra_classes)

    conf = SparkConf() \
      .setAppName("hl") \
      .setMaster("yarn") \
      .set('spark.ui.enabled', False) \
      .set('spark.jars', hail_all_spark_jar) \
      .set('spark.driver.extraClassPath', driver_extra_class_path) \
      .set('spark.executor.extraClassPath', executor_extra_class_path) \
      .set('spark.kryo.registrator','is.hail.kryo.HailKryoRegistrator') \
      .set('spark.serializer', 'org.apache.spark.serializer.KryoSerializer')

    return SparkContext(conf=conf)


if __name__ == '__main__':
    spark = SparkSession(get_remote_spark_context())
    df = spark.read.option('delimiter', ',').csv('s3://simeon-hail-test/minimal_test.csv')
