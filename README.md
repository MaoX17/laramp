# Laramp


## Nuova creazione ambiente

Creo la struttura:

	export PROJECT_NAME=project-z
	cd /opt/docker-compose
	mkdir $PROJECT_NAME
	cd $PROJECT_NAME
	mkdir mysqldata
	#mkdir redisdata
	mkdir src
	chmod -R 777 ./*

Clono il repo:

	cd /opt/docker-compose/$PROJECT_NAME
	git clone REPO
	cd laramp
	vim .env
	###Modifica le variabili###

Inizializzo il progetto

	cd /opt/docker-compose/$PROJECT_NAME/laramp

	docker compose run --rm php composer create-project laravel/laravel .
	docker compose run --rm php php artisan migrate

	docker compose run --rm php composer require directorytree/ldaprecord-laravel
	docker compose run --rm php php artisan vendor:publish --provider="LdapRecord\Laravel\LdapServiceProvider"

	docker compose run --rm php php artisan migrate

	docker compose run --rm php composer require laravel/ui
	docker compose run --rm php php artisan ui bootstrap --auth

	docker compose run --rm php npm install

	docker compose run --rm php php artisan storage:link
	docker compose run --rm php php artisan ldap:test
	docker compose run --rm php npm run dev
	q
	docker compose run --rm php npm install
	
	chmod -R 777 ../src/storage/

	docker compose run --rm php npm install bootstrap-icons

	vim ../src/resources/sass/app.scss
	###
	// Fonts
	@import url('https://fonts.bunny.net/css?family=Nunito');

	// Variables
	@import 'variables';

	// Bootstrap
	@import 'bootstrap/scss/bootstrap';
	@import 'bootstrap-icons/font/bootstrap-icons.css';
	###

	docker compose run --rm php npm install
	docker compose run --rm php npm run build

	vim ../src/app/Providers/AppServiceProvider.php
	###
	...
		public function boot(): void
		{
				//
			if($this->app->environment('production')) {
				\URL::forceScheme('https');
			}
		}
	...
	###

Esempio modifiche laravel env

	vim ../src/.env
	###
	APP_NAME=Servicemp
	#APP_ENV=local
	APP_ENV=production
	APP_KEY=base64:zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
	APP_DEBUG=true
	#APP_URL=http://localhost
	#APP_URL=https://localhost
	APP_URL=https://service.proietti.net

	LOG_CHANNEL=stack
	LOG_DEPRECATIONS_CHANNEL=null
	LOG_LEVEL=debug

	DB_CONNECTION=mysql
	### ATTENZIONE - varia in base alla variabile
	## PRJ_NAME=projectz
	DB_HOST=mysql-projectz
	DB_PORT=3306
	DB_DATABASE=homestead
	DB_USERNAME=root
	DB_PASSWORD=secret
	...
	...
	...
	###


Esempio modifiche laravel env diverso

	APP_NAME=Servicemp
	#APP_ENV=local
	APP_ENV=production
	APP_KEY=base64:zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
	APP_DEBUG=true
	#APP_URL=http://localhost
	#APP_URL=https://localhost
	APP_URL=https://service.proietti.net

	LOG_CHANNEL=stack
	LOG_DEPRECATIONS_CHANNEL=null
	LOG_LEVEL=debug

	DB_CONNECTION=mysql
	DB_HOST=172.17.1.34
	DB_PORT=3306
	DB_DATABASE=dbname
	DB_USERNAME=userReader
	DB_PASSWORD=Password2022

	SECOND_DB_CONNECTION=mysql
	### ATTENZIONE - varia in base alla variabile
        ## PRJ_NAME=projectz
	SECOND_DB_HOST=mysql-projectz
	SECOND_DB_PORT=3306
	SECOND_DB_DATABASE=homestead
	SECOND_DB_USERNAME=root
	SECOND_DB_PASSWORD=secret

	BROADCAST_DRIVER=log
	CACHE_DRIVER=file
	FILESYSTEM_DISK=local
	QUEUE_CONNECTION=sync
	SESSION_DRIVER=file
	SESSION_LIFETIME=120

	MEMCACHED_HOST=127.0.0.1

	REDIS_HOST=127.0.0.1
	REDIS_PASSWORD=null
	REDIS_PORT=6379

	MAIL_MAILER=smtp
	MAIL_HOST=smtp.pippo.local
	MAIL_URL=null
	MAIL_PORT=25
	MAIL_USERNAME=null
	MAIL_PASSWORD=null
	MAIL_ENCRYPTION=null
	MAIL_FROM_ADDRESS="servicemp@proietti.net"
	MAIL_FROM_NAME="${APP_NAME}"
	

## Attivo livewire e creo esempio

	docker compose run --rm php composer require livewire/livewire
	docker compose run --rm php php artisan make:livewire counter

	Edit app/Livewire/Counter.php

	<?php
 
	namespace App\Livewire;
	use Livewire\Component;
 
	class Counter extends Component
	{
	    public $count = 1;
	 
	    public function increment()
	    {
	        $this->count++;
	    }
	 
	    public function decrement()
	    {
	        $this->count--;
	    }
	 
	    public function render()
	    {
	        return view('livewire.counter');
	    }
	}


	Edit resources/views/livewire/counter.blade.php

	<div>
		<h1>{{ $count }}</h1>
	 
		<button wire:click="increment">+</button>
	 
		<button wire:click="decrement">-</button>
	</div>


	Register a route for the component
	Edit routes/web.php

	use App\Livewire\Counter;
 	Route::get('/counter', Counter::class);

	Create layout per livewire:

	docker compose run --rm php php artisan livewire:layout


ATTENZIONE!!!!

Nonostante tutto il componente NON funziona per una configurazione non corretta di ngnix.

Per correggere ho eseguito i seguenti passaggi:

	Edit nginx/default.conf

	Aggiunto la seguente sezione:

	location = /livewire/livewire.js {
	    expires off;
	    try_files $uri $uri/ /index.php?$query_string;
	}

	Ricostruisco e riavvio

	docker compose down
	docker compose build
	./restart.sh




## Preparazione Ambiente sviluppo con VSCode

Prima di tutto copio il file project-z.proietti.net.code-workspace e la directory .vscode in una nuova Dir che sarà la dir dello sviluppo

Un esempio di file è il seguente:

	project-z.proietti.net.code-workspace :

	{
		"folders": [
			{
				"path": "C:\\Users\\mproietti\\Documents\\mp-project-z"
			}
		]
	}


	.vscode/sftp.json :

	{
	  "name": "project-z.proietti.net",
	  "protocol": "sftp",
	  "host": "srv-docker.pippo.local",
	  "port": 22,
	  "username": "user",
	  "password": "XXXPASSXXX",
	  "remotePath": "/opt/docker-compose/project-z/src/",
	  "uploadOnSave": true,
	  "ignore": [
		"*.code-workspace",
		".git",
		".vscode",
		".DS_Store",
		"node_modules",
		"storage",
		"test",
		"tmp",
		"vendor"
	  ]
	}


Fatto questo posso creare un nuovo repository su GitLab per il codice sorgente del progetto.
Creo quindi il repository che ha indirizzo (per es.)

https://gitlab.proietti.net/mp_pub/project-z.git

A questo punto apro VSCode, apro l'area di lavoro e dal terminale do i seguenti comandi per sincronizzare il repo con il codice:

	git init
	git remote add origin https://gitlab.proietti.net/mp_pub/project-z.git
	git fetch --all
	git reset --hard origin/main

	git pull
	git add .
	git commit -m "Primo commit del codice"
	git branch -M main
	git push -uf origin main


Fatto

	


## Definizione ambiente



	/opt/docker-compose/service

	cat composer.dockerfile

	FROM composer:latest

	RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

	WORKDIR /var/www/html

	cat nginx.dockerfile

	FROM nginx:stable-alpine

	ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
	ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf

	RUN mkdir -p /var/www/html

	RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

	RUN chown laravel:laravel /var/www/html

	Uso la 8.2 per un bug su imagemagik della 8.3

	cat php.dockerfile
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


	RUN echo 'max_execution_time = 150' >> /usr/local/etc/php/conf.d/docker-php-maxexectime.ini;

	# Get latest Composer
	COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

	# Create system user to run Composer and Artisan Commands
	RUN mkdir -p /home/laravel/.composer && \
		chown -R laravel:laravel /home/laravel

	RUN apk add --update --no-cache git nodejs npm

	RUN apk add gmp-dev && docker-php-ext-install gmp exif

	 cat docker-compose.yml
	version: '3'

	services:
	  site:
		build:
		  context: .
		  dockerfile: nginx.dockerfile
		container_name: nginx_service.proietti.net
		# ports:
		#   - "8080:80"
		environment:
		  VIRTUAL_HOST: ${VIRTUAL_HOST}
		  VIRTUAL_PORT: ${VIRTUAL_PORT}
		  LETSENCRYPT_HOST: ${LETSENCRYPT_HOST}
		  LETSENCRYPT_EMAIL: ${LETSENCRYPT_EMAIL}
		labels:
		  - traefik.enable=true
		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-http.entrypoints=web
		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-http.rule=Host(`${LETSENCRYPT_HOST}`)
		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-http.middlewares=https-redirect@file

		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-https.entrypoints=websecure
		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-https.rule=Host(`${LETSENCRYPT_HOST}`)
		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-https.tls=true
	#      - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-https.tls.certresolver=lets-encr
		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-https.middlewares=secured@file
		  - traefik.http.routers.${TRAEFIK_ROUTE_NAME}-https.middlewares=mp-maox-ldapAuth@file

		  - traefik.http.services.${TRAEFIK_ROUTE_NAME}.loadbalancer.server.port=${VIRTUAL_PORT}
		  - traefik.docker.network=nginx-proxy



		volumes:
		  - ./src:/var/www/html:delegated
		depends_on:
		  - php
		  - mysql
		networks:
		  - backend_service
		  - proxy

	  mysql:
		image: mariadb
		container_name: mysql_service.proietti.net
		hostname: mysql-service
		restart: unless-stopped
		tty: true
		# ports:
		#   - "3306:3306"
		environment:
		  MYSQL_DATABASE: ${MYSQL_DATABASE}
		  MYSQL_USER: ${MYSQL_USER}
		  MYSQL_PASSWORD: ${MYSQL_PASSWORD}
		  MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
		  SERVICE_NAME: ${SERVICE_NAME}
		labels:
		  - traefik.enable=false
		volumes:
		  - ./mysqldata:/var/lib/mysql
		networks:
		  - backend_service

	  php:
		build:
		  context: .
		  dockerfile: php.dockerfile
		container_name: php_service.proietti.net
		labels:
		  - traefik.enable=false
		volumes:
		  - ./src:/var/www/html:delegated
		# ports:
		#   - "9000:9000"
		networks:
		  - backend_service


	  redis:
		image: redis:6
		container_name: redis_service.proietti.net
		labels:
		  - traefik.enable=false
		restart: always
		sysctls:
		  - net.core.somaxconn=1024
		volumes:
		  - ./redis:/data
		networks:
		  - backend_service
		# launch Redis in cache mode with :
		#     #  - max memory up to 50% of your RAM if needed (--maxmemory 512mb)
		#         #  - deleting oldest data when max memory is reached (--maxmemory-policy allkeys-lru)
	#    entrypoint: redis-server --maxmemory 512mb -maxmemory-policy allkeys-lru
		entrypoint: redis-server /data/redis.conf




	networks:
	  proxy:
		external: true
		name: nginx-proxy
	  backend_service:

	cat .env

	VIRTUAL_HOST=service.proietti.net
	VIRTUAL_PORT=80
	LETSENCRYPT_HOST=service.proietti.net
	LETSENCRYPT_EMAIL=xxxxxx@proietti.net

	## MYSQL ENV
	MYSQL_DATABASE=homestead
	MYSQL_USER=homestead
	MYSQL_PASSWORD=secret
	MYSQL_ROOT_PASSWORD=secret
	SERVICE_NAME=mysql

	##TRAEFIK
	TRAEFIK_ROUTE_NAME=www_service

	docker compose run --rm php composer create-project laravel/laravel .
	docker compose run --rm php php artisan migrate
	docker compose run --rm php composer require directorytree/ldaprecord-laravel
	docker compose run --rm php php artisan vendor:publish --provider="LdapRecord\Laravel\LdapServiceProvider"
	docker compose run --rm php php artisan migrate
	docker compose run --rm php composer require laravel/ui
	docker compose run --rm php php artisan ui bootstrap --auth

	docker compose run --rm php npm install

	docker compose run --rm php php artisan storage:link
	docker compose run --rm php php artisan ldap:test
	docker compose run --rm php npm run dev
	docker compose run --rm php npm install
	docker compose run --rm php npm run dev
	chmod -R 777 src/storage/

	docker compose run --rm php npm install bootstrap-icons
	vim src/resources/sass/app.scss
	###
	// Fonts
	@import url('https://fonts.bunny.net/css?family=Nunito');

	// Variables
	@import 'variables';

	// Bootstrap
	@import 'bootstrap/scss/bootstrap';
	@import 'bootstrap-icons/font/bootstrap-icons.css';
	###

	docker compose run --rm php npm install
	docker compose run --rm php npm run build

	vim src/.env
	vim src/app/Providers/AppServiceProvider.php
	###
	...
		public function boot(): void
		{
				//
			if($this->app->environment('production')) {
				\URL::forceScheme('https');
			}
		}
	...
	###

	vim src/.env
	###
	APP_NAME=Servicemp
	#APP_ENV=local
	APP_ENV=production
	APP_KEY=base64:zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
	APP_DEBUG=true
	#APP_URL=http://localhost
	#APP_URL=https://localhost
	APP_URL=https://service.proietti.net

	LOG_CHANNEL=stack
	LOG_DEPRECATIONS_CHANNEL=null
	LOG_LEVEL=debug

	DB_CONNECTION=mysql
	DB_HOST=mysql-service
	DB_PORT=3306
	DB_DATABASE=homestead
	DB_USERNAME=root
	DB_PASSWORD=secret
	...
	...
	...
	###


