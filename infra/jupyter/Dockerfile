FROM quay.io/jupyter/pyspark-notebook:spark-3.5.0

USER root
RUN pip install --no-cache-dir boto3 s3fs
USER ${NB_UID}

WORKDIR /home/jovyan/work
