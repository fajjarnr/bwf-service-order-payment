FROM composer as build

WORKDIR /app

COPY . /app

RUN composer update --no-interaction --no-scripts
RUN composer install --no-interaction --no-scripts

#

FROM php:8.1-apache

ENV APP_ENV=production
ENV APP_DEBUG=false

RUN docker-php-ext-install pdo_mysql

RUN a2enmod rewrite

RUN sed -i 's/Listen 80/Listen 8001/g' /etc/apache2/ports.conf

COPY --from=build /app /var/www/html

COPY vhost.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir -p /var/www/html/bootstrap/cache \
    && chmod -R 777 /var/www/html/bootstrap/cache /var/www/html/storage/* \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 8001

USER www-data
