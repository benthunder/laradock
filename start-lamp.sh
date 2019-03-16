#!/bin/bash
#Start lamp for linux enviroment
docker-compose up -d apache2 php-fpm mysql phpmyadmin workspace

php-fpm/xdebug status
php-fpm/xdebug stop
echo 'Xdebug is stop'
echo 'press any key to continues .... !';
read -r ;