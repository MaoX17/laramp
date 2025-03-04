FROM php:8.2-fpm-alpine

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql

RUN apk update

RUN apk add libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd && docker-php-ext-install gd && docker-php-ext-install gd

#LDAP
RUN apk add ldb-dev libldap openldap-dev --no-cache ldb-dev && docker-php-ext-install ldap

RUN apk add --update --no-cache autoconf g++ imagemagick imagemagick-dev libgomp libtool make pcre-dev imagemagick-libs 
RUN pecl install imagick 
RUN docker-php-ext-enable imagick 
RUN apk del autoconf g++ libtool make pcre-dev

#RUN apk add php82-pecl-imagick --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
#RUN apk --update add imagemagick imagemagick-dev
#RUN pecl install imagick
#RUN docker-php-ext-enable imagick


#ZIP
RUN apk add --no-cache zip libzip-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

## Personalizzazione 
RUN echo 'max_execution_time = 150' >> /usr/local/etc/php/conf.d/docker-php-maxexectime.ini;
RUN echo 'mmemory_limit = 512' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN mkdir -p /home/laravel/.composer && \
    chown -R laravel:laravel /home/laravel

RUN apk add --update --no-cache git nodejs npm 

RUN apk add gmp-dev && docker-php-ext-install gmp exif 


