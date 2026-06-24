FROM php:8.1-apache

# Set environment variables
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public \
    MOODLE_PATH=/var/www/html \
    PHP_MEMORY_LIMIT=256M

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    gd \
    xml \
    zip \
    intl \
    opcache

# Configure Apache
RUN a2enmod rewrite
RUN sed -i "s|/var/www/html|${APACHE_DOCUMENT_ROOT}|g" /etc/apache2/sites-available/000-default.conf
RUN echo "DocumentRoot ${APACHE_DOCUMENT_ROOT}" >> /etc/apache2/apache2.conf

# Copy Moodle source into the container
COPY . ${MOODLE_PATH}/

# Set permissions
RUN chown -R www-data:www-data ${MOODLE_PATH}

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
