FROM registry.cn-hangzhou.aliyuncs.com/yulinzhihou/gs_php:v2.0.0


# FROM php:7.4.20-fpm-alpine

# LABEL author="yulinzhihou" website="https://gsgameshare.com"

# ARG PHP_EXTENSIONS="pdo_mysql,mysqli,mbstring,gd,curl,opcache,redis,swoole"

# RUN  sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories;

# COPY ./extensions /tmp/extensions
# COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
# COPY ./php.ini /usr/local/etc/php/php.ini

# WORKDIR /tmp/extensions
# RUN chmod +x install.sh \
#     && sh install.sh \
#     && rm -rf /tmp/extensions

# ADD ./extensions/install-php-extensions  /usr/local/bin/

# RUN chmod uga+x /usr/local/bin/install-php-extensions

# RUN apk --no-cache add tzdata \
#     && cp "/usr/share/zoneinfo/Asia/Shanghai" /etc/localtime \
#     && echo "Asia/Shanghai" > /etc/timezone

# # Fix: https://github.com/docker-library/php/issues/240
# RUN apk add gnu-libiconv libstdc++ --no-cache --repository http://mirrors.aliyun.com/alpine/edge/community/ --allow-untrusted
# ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# # Install composer and change it's cache home
# RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
#     && chmod +x /usr/bin/composer
# ENV COMPOSER_HOME=/tmp/composer

# # php image's www-data user uid & gid are 82, change them to 1000 (primary user)
# RUN apk --no-cache add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data

# WORKDIR /home/www
