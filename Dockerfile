FROM composer:1.7 as composer

FROM php:7.1-alpine
RUN apk add --virtual .runtime-deps git subversion openssh-client mercurial tini bash patch make zip unzip coreutils libpng
RUN apk add --virtual .build-deps freetype-dev libjpeg-turbo-dev libpng-dev
RUN docker-php-ext-install gd zip opcache
RUN apk del .build-deps

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /docker-entrypoint.sh /docker-entrypoint.sh

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp

WORKDIR /app
ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
CMD ["composer"]
