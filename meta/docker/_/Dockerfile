FROM debian:bookworm-slim AS downloader
WORKDIR /w
RUN apt-get update && apt-get install -y curl
RUN echo "5b97b012fd2515ffe971d6269b9ab7f34e7c59cc3b306a4bef3e108a8745369f  dbmate" > "dbmate.sha256sum"
RUN curl -fsSL -o ./dbmate https://github.com/amacneil/dbmate/releases/download/v2.8.0/dbmate-linux-amd64
RUN sha256sum -c dbmate.sha256sum
RUN chmod +x ./dbmate

FROM php:8.4-apache AS base
WORKDIR /w
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
COPY --from=downloader /w/dbmate /usr/local/bin/dbmate
COPY ./meta/docker/_/bin/* /usr/local/bin/
ENV WEATHER_STATION_ROOT=/app
SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT []
CMD [ "weather-station" ]
HEALTHCHECK --interval=30s --timeout=1s  --start-period=60s --start-interval=1s --retries=1 CMD [ "weather-station-ready" ]

FROM base AS development

FROM base AS release
COPY ./src/migrations /app/migrations
COPY ./src/server /var/www/html
