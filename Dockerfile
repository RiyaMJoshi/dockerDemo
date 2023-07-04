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

RUN composer install --optimize-autoloader

# RUN php artisan key:generate

CMD php -S 0.0.0.0:8080 -t public

EXPOSE 8080