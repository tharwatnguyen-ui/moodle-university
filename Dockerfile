FROM php:8.1-apache

# Install PHP extensions Moodle needs
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy Moodle into Apache root
COPY . /var/www/html/

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html

# Update Apache config to use /var/www/html
RUN sed -i 's|/var/www/html/public|/var/www/html|' /etc/apache2/sites-available/000-default.conf
