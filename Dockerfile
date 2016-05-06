FROM linuzilla/alpine-sshd:latest
MAINTAINER Mac Liu <linuzilla@gmail.com>

COPY files/my.cnf /etc/mysql/my.cnf
COPY files/09init-mysql.sh /etc/init-scripts
COPY files/supervisord-mysql.conf /etc/supervisor.d/mysql.conf

RUN apk update \
    && apk add mariadb mariadb-client; \
    rm -rf /var/cache/apk/* && rm -rf /tmp/src; \
    chmod +x /etc/init-scripts/09init-mysql.sh

ENV MARIADB_USERID ""
ENV DB_USER "admin"
ENV DB_PASS "password"

EXPOSE 3306
# VOLUME [ "/data" ]
