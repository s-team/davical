FROM php:7-apache
ENV DAVICAL_VERSION=1.1.5
ENV AWL_VERSION=0.57
ENV DAVICAL_PG_CONNECT=''
ENV DAVICAL_ADMIN_EMAIL=''
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libicu-dev \
        libpq-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt soap intl \
         mysqli gettext pgsql pdo_pgsql calendar \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite
RUN curl -o /usr/share/davical.tar.gz https://gitlab.com/davical-project/davical/repository/archive.tar.gz?ref=r${DAVICAL_VERSION} \
    && curl -o /usr/share/awl.tar.gz https://gitlab.com/davical-project/awl/repository/archive.tar.gz?ref=r${AWL_VERSION} \
    && cd /usr/share && tar -xzvf davical.tar.gz && tar -xzvf awl.tar.gz && rm *.tar.gz && mv awl-* awl && mv davical-* davical
RUN apt-get update && apt-get install -y \
      libyaml-perl \
      libdbd-pg-perl \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/*
COPY 000-default.conf /etc/apache2/sites-available/
COPY config.php /etc/davical/config.php
COPY administration.yml /etc/davical/administration.yml
#COPY apache-davical.conf /usr/share/davical/config/apache-davical.conf
