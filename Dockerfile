FROM stmops/php:7-apache
ENV DAVICAL_VERSION=1.1.5 AWL_VERSION=0.57 DAVICAL_ADMIN_EMAIL='' \
    DAVICAL_ADMIN_DB_USER='davical_dba' DAVICAL_ADMIN_DB_PASS='' \
    DAVICAL_ADMIN_DB_HOST='' DAVICAL_ADMIN_DB_NAME='davical' \
    DAVICAL_ADMIN_DB_PORT='5432' DAVICAL_APP_DB_USER='davical_app' \
    DAVICAL_APP_DB_PASS='' DAVICAL_ENABLE_AUTO_SCHEDULE='true'
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
COPY docker-php-entrypoint /usr/local/bin/docker-php-entrypoint
