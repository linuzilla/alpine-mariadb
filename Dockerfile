FROM linuzilla/alpine-sshd:latest
MAINTAINER Mac Liu <linuzilla@gmail.com>

RUN apk update \
    && apk add bash mariadb mariadb-client

ENV MARIADB_USERID ""
ENV DB_USER "admin"
ENV DB_PASS "password"

RUN rm -rf /var/cache/apk/* && rm -rf /tmp/src

ADD files/my.cnf /etc/mysql/my.cnf
ADD files/run.sh /run.sh
COPY files/supervisord.conf /etc/supervisord.conf
RUN chmod +x /run.sh

EXPOSE 22 3306
VOLUME [ "/data" ]

CMD ["/run.sh"]
