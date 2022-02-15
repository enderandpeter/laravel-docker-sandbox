FROM php:8-fpm

ENV DEPLOY_USER=membersy
ENV DEPLOY_USER_HOME=/home/$DEPLOY_USER \
    WORKDIR=/var/www/html \
    PROJECTDIR=/root/Downloads/project

RUN apt-get update \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update \
    && apt-get -y install gnupg wget git vim mlocate inetutils-ping \
	net-tools telnet ca-certificates \
    zlib1g-dev unzip libzip-dev nodejs libpq-dev \
	&& update-ca-certificates \
	&& docker-php-ext-install pdo pdo_pgsql zip

COPY *.sh /usr/local/bin/

RUN chmod -R +x /usr/local/bin/*.sh && install-composer.sh

WORKDIR "$WORKDIR"

VOLUME "$WORKDIR"

ENTRYPOINT start.sh
