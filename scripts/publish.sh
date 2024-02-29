#!/usr/bin/env bash
set -euo pipefail

WEATHER_STATION_VERSION="$(date '+%Y%m%d_%H%M%S')"
export WEATHER_STATION_VERSION
docker compose build weather-station
docker compose push weather-station
