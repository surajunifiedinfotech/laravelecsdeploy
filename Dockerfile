FROM ubuntu:latest

# Updating and adding repos
RUN apt-get update && \
	apt-get install -y software-properties-common && \ 
	add-apt-repository ppa:ondrej/php && \
	apt-get update


## Installing php dependency libraries 

RUN apt-get install -y php7.3-cli \
			php7.3-dev \
			php7.3-gd php7.3-curl php-memcached php7.3-imap \
			php7.3-mysql php7.3-mbstring php7.3-xml php-imagick \
			php7.3-zip php7.3-bcmath php7.3-soap php7.3-intl \
			php7.3-readline php7.3-common php7.3-pspell \
			php7.3-tidy php7.3-xmlrpc php7.3-xsl \
			php7.3-opcache php-apcu libapache2-mod-php7.3

# Installing Apache 
RUN apt install -y apache2

WORKDIR /var/www/html/laravel
ADD . .

#installing Composer 
RUN apt-get install -y composer && composer install -d /var/www/html/laravel/ 

#enabling 
RUN a2enmod php7.3 && a2dismod mpm_event && a2enmod mpm_prefork 
RUN php artisan key:generate

RUN cat 000-default.conf > /etc/apache2/sites-available/000-default.conf

RUN chgrp -R www-data /var/www/html/laravel
RUN chmod -R 775 /var/www/html/laravel/storage

CMD apachectl -D FOREGROUND
