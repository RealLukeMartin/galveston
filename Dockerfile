# from https://www.drupal.org/requirements/php#drupalversions
FROM php:5.6-apache
MAINTAINER Luke Martin <lukemartinwebdev@gmail.com>

RUN a2enmod rewrite

# install the dependencies we need
RUN apt-get update && apt-get install -y php5-cli git libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:8.*
RUN composer global update
# Unfortunately, adding the composer vendor dir to the PATH doesn't seem to work. So:
RUN ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.0.3
ENV DRUPAL_MD5 7d5f5278a870b8f4a29cda4fe915d619
ENV COMPOSER_HOME /root/composer

RUN composer global require drush/drush:"8.*" --prefer-dist \
    && ln -sf $COMPOSER_HOME/vendor/bin/drush.php /usr/local/bin/drush \
    && drush make https://raw.githubusercontent.com/poetic/houston/docker/makefiles/stubs/build.make.yml -y \
	&& chown -R www-data:www-data sites