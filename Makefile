up: docker-compose.yml .env
	docker-compose up -d mysql nginx php-fpm workspace phpmyadmin
	php-fpm/xdebug stop
	
restart: docker-compose.yml .env
	docker-compose restart mysql nginx php-fpm workspace phpmyadmin
	
up-with-debug: docker-compose.yml .env
	docker-compose up -d mysql nginx php-fpm workspace phpmyadmin