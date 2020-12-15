ARG PHP_IMAGE=7.4-fpm-alpine

FROM php:${PHP_IMAGE} 

LABEL maintainer="Aron Peyroteo <aron@mqx.com.br>" \
  org.label-schema.name="aronpc/php" \
  org.label-schema.description=":coffee: Docker images for PHP" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/aronpc/docker-php-alpine"

ARG PHP_VERSION_BASE=7.4

# Set correct environment variables
ENV HOME=/home/abc
ENV COMPOSER_HOME=$HOME/.composer
ENV PHP_VERSION_BASE="${PHP_VERSION_BASE}"

# Install bash
RUN apk --update --no-cache add bash

# Install composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

USER root

WORKDIR /tmp

COPY ./fpm/scripts/*.sh /tmp/

RUN chmod +x /tmp/*.sh

RUN apk update \
	&& apk --no-cache add \
    g++ \
    gcc \
    git \
    grep \
    jq \
    libc-dev \
    make \
    mariadb-client \
    openssh-client \
    openssl \
    patch \
    rsync \
    sudo \
    zip

# persistent / runtime deps
RUN apk add --no-cache --virtual .persistent-deps \
		ca-certificates \
		tar \
		xz \
    curl

RUN apk add --no-cache \
    autoconf \
    build-base \
    file \
    openssl-dev

RUN apk --update --no-cache add \
  bzip2 \
  bzip2-dev \
  cassandra-cpp-driver \
  curl-dev \
  cyrus-sasl-dev \
  freetype-dev \
  gmp-dev \
  icu-dev \
  imagemagick \
  imagemagick-dev \
  imap-dev \
  krb5-dev \
  libbz2 \
  libedit-dev \
  libintl \
  libjpeg-turbo-dev \
  libltdl \
  libmemcached-dev \
  libpng-dev \
  libtool \
  libxml2-dev \
  libxslt-dev \
  openldap-dev \
  pcre-dev \
  postgresql-dev \
  rabbitmq-c \
  rabbitmq-c-dev \
  readline-dev \
  sqlite-dev \
  zlib-dev

RUN /tmp/extensions.sh

RUN adduser --disabled-password --gecos "" abc 
RUN echo "abc  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir -p /var/www/html
RUN composer global require "hirak/prestissimo:^0.3" 
RUN rm -rf ${COMPOSER_HOME}/cache/*
RUN chown -R abc:abc /var/www $HOME

ADD ./fpm/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
ADD ./fpm/php.ini /etc/php7/conf.d/zzz_custom.ini

RUN /tmp/cleanup.sh

ENV PATH "$PATH:$COMPOSER_HOME/vendor/bin"

VOLUME ${HOME}

USER abc

WORKDIR /var/www/html
EXPOSE 9000