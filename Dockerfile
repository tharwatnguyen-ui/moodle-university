FROM php:8.1-apache

# Install PHP extensions Moodle needs
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy Moodle source
COPY . /var/www/html/

# Copy custom Apache config
COPY apache-conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# Enable rewrite module (needed by Moodle)
RUN a2enmod rewrite

# Set permissions
RUN chown -R www-data:www-data /var/www/html
