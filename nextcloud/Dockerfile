FROM nextcloud:latest

ENV TZ=Europe/Moscow

USER root

RUN apt-get clean && apt-get update && apt-get install -y libbz2-dev && docker-php-ext-install bz2
