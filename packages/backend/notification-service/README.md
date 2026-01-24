# Notification Service

## Overview
Notification Service exposes a health endpoint and starts an MQTT client in a background thread. It is configured to use Redis and MQTT broker.

## Responsibilities
- MQTT client connection (background thread)
- Notifications handling through MQTT topics (configured in code)
- Redis integration for caching/state (configured via env vars)
- Health endpoint

## Tech Stack
- FastAPI
- MQTT (Mosquitto broker)
- Redis

## Environment Variables (Docker Compose)
- `MQTT_BROKER` (e.g., `mqtt-broker`)
- `MQTT_PORT` (e.g., `1883`)
- `REDIS_HOST` (e.g., `redis`)
- `REDIS_PORT` (e.g., `6379`)

## API Endpoints
Base (internal): `http://notification-service:8000`

- `GET /health`

## Exposed Port (Docker Compose)
- Host: `http://localhost:8011`

## Dependencies
- MQTT Broker (eclipse-mosquitto)
- Redis

## Run
- `docker compose up -d --build`
