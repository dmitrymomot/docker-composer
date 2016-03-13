# Pull base image
FROM dmitrymomot/php-cli

MAINTAINER "Dmitry Momot" <mail@dmomot.com>

# Set environment variables
ENV COMPOSER_HOME /root/composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

# Install Composer
RUN apt-get update -y && \
    apt-get install -y curl git php5-mcrypt php5-gd && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer --ansi --version && \
    apt-get remove --purge curl -y && \
    apt-get clean

# Memory Limit
RUN PHP_INI_PATH=`php -i | grep 'Loaded Configuration File' | awk '{print $5}'` && \
    sed -i "s|memory_limit =.*|memory_limit = -1|" PHP_INI_PATH

# Define working directory
RUN mkdir -p /data/www
VOLUME ["/data/www"]
WORKDIR /data/www

# Set up the command arguments
ENTRYPOINT ["composer", "--ansi"]
CMD ["--help"]
