FROM php:8.1-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
        libtidy-dev \
        libzip-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        zlib1g \
        zip \
        unzip \
        git \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-install zip \
    && docker-php-ext-install tidy

RUN apt-get update && apt-get install curl -y 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer -v

COPY . .

COPY .env.example .env

# Apache & PHP configuration
# RUN a2enmod rewrite

RUN composer install --optimize-autoloader

# Configure the virtual host
# COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Install MySQL client
RUN apt-get install -y default-mysql-client

# Install phpMyAdmin
ENV PHPMYADMIN_VERSION=5.2.0
RUN curl -L -o phpmyadmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz \
    && tar xvf phpmyadmin.tar.gz \
    && mv phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages /var/www/html/phpmyadmin \
    && rm phpmyadmin.tar.gz

CMD php -S 0.0.0.0:8080 -t public

EXPOSE 8080
EXPOSE 3306