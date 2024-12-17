#!/usr/bin/env bash
set -euo pipefail

WEATHER_STATION_VERSION="$(date -u '+%Y%m%d_%H%M%S')"
WEATHER_STATION_TAG="ghcr.io/pamplonetario/weather-station:${WEATHER_STATION_VERSION}"
docker build \
  -t "$WEATHER_STATION_TAG" \
  --file "meta/docker/_/Dockerfile" .
docker push "$WEATHER_STATION_TAG"
