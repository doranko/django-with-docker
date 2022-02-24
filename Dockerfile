FROM python:3

ENV PYTHONUNBUFFERED 1

RUN python -m pip install --upgrade pip \
# PostgreSQL 以外を使用する場合は psycopg2 ではなく、対応するデータベースバインディングに変更
    && pip install Django psycopg2 \
    && pip cache purge \
    && django-admin startproject sample \
# DB の設定を修正
    && sed -i sample/sample/settings.py \
        -e "s/'ENGINE': 'django.db.backends.sqlite3',/'ENGINE': 'django.db.backends.postgresql',/" \
        -e "s/'NAME': BASE_DIR \/ 'db.sqlite3',/'NAME': 'mydb',/" \
        -e "/'NAME': 'mydb',/a<SPACE>'USER': 'user'," \
    && sed -i sample/sample/settings.py \
        -e "/'USER': 'user',/a<SPACE>'PASSWORD': 'pass'," \
    && sed -i sample/sample/settings.py \
        -e "/'PASSWORD': 'pass',/a<SPACE>'HOST': 'postgres',"  \
    && sed -i sample/sample/settings.py \
        -e "s/<SPACE>/        /"
