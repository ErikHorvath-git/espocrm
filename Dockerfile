FROM php:8.1-apache

# Inštalácia potrebných rozšírení
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip bcmath

# Kopírovanie kódu do kontajnera
COPY . /var/www/html/

# Nastavenie práv
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

EXPOSE 80
