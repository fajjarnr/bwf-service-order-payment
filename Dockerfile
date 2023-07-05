FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www/web

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    libonig-dev \
    libzip-dev \
    jpegoptim optipng pngquant gifsicle \
    ca-certificates \
    vim \
    tmux \
    unzip \
    git \
    cron \
    supervisor \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/
RUN docker-php-ext-install gd
# RUN pecl install -o -f redis &&  rm -rf /tmp/pear && docker-php-ext-enable redis

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Copy project ke dalam container
COPY . /var/www/web
COPY .env /var/www/web/.env

# Copy directory project permission ke container
COPY --chown=www-data:www-data . /var/www/web
RUN chown -R www-data:www-data /var/www/web/storage
RUN chown -R www-data:www-data /var/www/web/bootstrap/cache

# Install dependency
RUN composer install
RUN php artisan key:generate

# Expose port 9000
EXPOSE 9000

# Ganti user ke www-data
USER www-data

# CMD php artisan serve --host=0.0.0.0 --port=8080
