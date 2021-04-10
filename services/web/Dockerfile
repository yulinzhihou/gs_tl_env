FROM creativitykills/nginx-php-server:latest

FROM nginx:1.19.9-alpine

LABEL maintainer="yulinzhihou <yulinzhihou@gmail.com>"

RUN apk --update --no-cache add ca-certificates \
    bash \
    supervisor

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

# IMAGE ARGUMENTS WITH DEFAULTS.
ARG PHP_VERSION=7.2
ARG ALPINE_VERSION=3.8
ARG NGINX_HTTP_PORT=80
ARG NGINX_HTTPS_PORT=443

# CONFIGURE ALPINE REPOSITORIES AND PHP BUILD DIR.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
    echo "@php https://dl.bintray.com/php-alpine/v${ALPINE_VERSION}/php-${PHP_VERSION}" >> /etc/apk/repositories

RUN apk add --no-cache --update php-fpm@php \
    php@php \
    php-openssl@php \
    php-pdo@php \
    php-pdo_mysql@php \
    php-mbstring@php \
    php-phar@php \
    php-session@php \
    php-dom@php \
    php-ctype@php \
    php-zlib@php \
    php-json@php \
    php-xml@php && \
    ln -s /usr/bin/php7 /usr/bin/php

# CONFIGURE WEB SERVER.
RUN mkdir -p /var/www && \
    mkdir -p /run/php && \
    mkdir -p /run/nginx && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/nginx/sites-enabled && \
    mkdir -p /etc/nginx/sites-available && \
    rm /etc/nginx/nginx.conf && \
    rm /etc/php7/php-fpm.d/www.conf && \
    rm /etc/php7/php.ini

# INSTALL COMPOSER.
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

ADD start.sh /start.sh
ADD config/supervisor/supervisord.conf /etc/supervisord.conf
ADD config/nginx/nginx.conf /etc/nginx/nginx.conf
ADD config/nginx/gsgm.conf /etc/nginx/sites-available/gsgm.conf
ADD config/nginx/ow.conf /etc/nginx/sites-available/ow.conf
ADD config/php/php.ini /etc/php7/php.ini
ADD config/php-fpm/www.conf /etc/php7/php-fpm.d/www.conf
RUN chmod 755 /start.sh

#EXPOSE ${NGINX_HTTPS_PORT} ${NGINX_HTTP_PORT}

WORKDIR /var/www

CMD ["/start.sh"]