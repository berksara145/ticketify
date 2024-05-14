FROM python:3.11.9-alpine


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


ENV FLASK_APP=api.py

RUN apk add --no-cache mariadb-connector-c-dev && \
    apk add --no-cache --virtual .build-deps mariadb-dev gcc musl-dev && \
    pip install mysqlclient && \
    apk del .build-deps

WORKDIR /api

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .