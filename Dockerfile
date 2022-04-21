FROM debian:11

RUN apt-get update \
    && apt-get -y install \
        curl \
        gnupg \
        lsb-release \
    && curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get -y install postgresql-13 \
        postgresql-client-13 \
    && apt-get -y purge \
        curl \
        gnupg \
        lsb-release \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r fsad  \
    && useradd -r -g fsad fsad

COPY docker-entrypoint.sh /docker-entrypoint.sh

USER postgres

RUN pg_ctlcluster 13 main start \
    && createuser --createdb fsad \
    && createdb fsad \
    && psql -c "ALTER USER fsad WITH PASSWORD 'fsad2022'; GRANT pg_read_server_files TO fsad;"

USER root

WORKDIR /app

COPY ./data ./data

ENTRYPOINT [ "sh", "/docker-entrypoint.sh" ]
