FROM postgres:13

ENV POSTGRES_PASSWORD=root \
    POSTGRES_USER=membersy

RUN apt-get update

COPY postgresql.conf /etc/postgresql/postgresql.conf

VOLUME ["/var/lib/postgresql/data"]

CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]