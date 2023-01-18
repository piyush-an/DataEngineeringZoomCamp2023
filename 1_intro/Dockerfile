FROM python:3.9.1

RUN apt-get update \
  && apt-get install -y wget \
  && pip install --upgrade pip

COPY requirements.txt /requirements.txt

RUN pip install -r requirements.txt

WORKDIR /app

COPY ingest_data.py ingest_data.py

ENTRYPOINT [ "python", "ingest_data.py" ]