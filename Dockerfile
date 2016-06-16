FROM php:7-apache
MAINTAINER Fabien Dubosson <fabien.dubosson@gmail.com>

RUN apt-get update && apt-get install -y \
      cron \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
      ssmtp \
      supervisor \
      zlib1g-dev \
      unzip \
    && docker-php-ext-install -j$(nproc) mcrypt mysqli zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

COPY webapp/redcap/ /var/www/html/
COPY config_redcap.sh /usr/bin/
COPY local.conf /etc/redcap.conf
COPY redcap_php.ini /usr/local/etc/php/conf.d/
COPY supervisord.conf /etc/supervisor/conf.d/

WORKDIR /var/www/html
RUN /usr/bin/config_redcap.sh
RUN mkdir /var/files/ && chown www-data:www-data /var/files
RUN chown -R www-data:www-data temp edocs
RUN echo "* * * * * /usr/local/bin/php /var/www/html/cron.php > /dev/null" >> /tmp/crontab \
    && crontab /tmp/crontab \
    && rm /tmp/crontab
RUN echo "mailhub=mail.example.com:25\n" >> /etc/ssmtp/ssmtp.conf

CMD ["/usr/bin/supervisord"]
