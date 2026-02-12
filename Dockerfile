FROM php:8.2-apache

# 1. Inštalácia systémových závislostí pre EspoCRM
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Inštalácia a povolenie PHP rozšírení
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip bcmath intl exif

# 3. OPRAVA MPM: Vypneme event a zapneme prefork (rieši tvoju chybu)
RUN a2dismod mpm_event && a2enmod mpm_prefork && a2enmod rewrite

# 4. Skopírovanie tvojho kódu z GitHubu do kontajnera
COPY . /var/www/html/

# 5. Nastavenie správnych prístupových práv
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Railway vyžaduje, aby aplikácia počúvala na porte, ktorý pridelí
ENV PORT=80
EXPOSE 80

CMD ["apache2-foreground"]
