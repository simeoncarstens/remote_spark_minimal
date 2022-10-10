FROM python

SHELL ["/bin/bash", "-c"]
WORKDIR /mwe

COPY requirements.txt .
RUN apt-get update
RUN apt-get -y install default-jdk
RUN apt-get -y install vim
RUN python -m venv .venv
RUN source .venv/bin/activate
RUN python -m pip cache purge
RUN pip install -r requirements.txt --upgrade
RUN mkdir /jars
ENV JAVA_HOME=/usr/lib/jvm/default-java
COPY minimal.py .
COPY set_remote_cluster_env.sh .

CMD ["python", "-i", "minimal.py"]