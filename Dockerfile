FROM python

ARG DEPENDENCIES_S3_URI=s3://simeon-hail-test/remote_emr_dependencies
RUN apt-get update
RUN apt-get -y install awscli
RUN aws s3 cp ${DEPENDENCIES_S3_URI}/driver_dependencies /driver_dependencies --recursive
RUN aws s3 cp ${DEPENDENCIES_S3_URI}/hadoop_conf /hadoop_conf --recursive

SHELL ["/bin/bash", "-c"]
WORKDIR /mwe

COPY requirements.txt .
RUN apt-get -y install default-jdk
RUN apt-get -y install vim
RUN python -m venv .venv
RUN . ./.venv/bin/activate && python -m pip cache purge && pip install -r requirements.txt
RUN mkdir /jars
ENV JAVA_HOME=/usr/lib/jvm/default-java
COPY minimal.py .
COPY set_remote_cluster_env.sh .
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
