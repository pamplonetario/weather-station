FROM debian:bookworm-slim AS downloader
WORKDIR /workdir
RUN apt-get update && apt-get install -y curl
RUN echo "5b97b012fd2515ffe971d6269b9ab7f34e7c59cc3b306a4bef3e108a8745369f  dbmate" > "dbmate.sha256sum"
RUN curl -fsSL -o ./dbmate https://github.com/amacneil/dbmate/releases/download/v2.8.0/dbmate-linux-amd64
RUN sha256sum -c dbmate.sha256sum
RUN chmod +x ./dbmate

FROM php:5.6-apache AS base
WORKDIR /weather-station
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
COPY --from=downloader /workdir/dbmate /usr/local/bin/dbmate
COPY ./src/docker/start.sh ./start.sh
CMD [ "/weather-station/start.sh" ]

FROM base AS development

FROM base AS release
COPY ./src/database ./database
COPY ./src/server /var/www/html
