# Event Service

## Overview
Event Service publishes domain events to Kafka. Other services call this service to emit events such as activity approvals/rejections.

## Responsibilities
- Publish domain events to Kafka (topic-based)
- Provide a health endpoint

## Tech Stack
- FastAPI
- Kafka (apache/kafka)

## Environment Variables (Docker Compose)
- `KAFKA_BOOTSTRAP_SERVERS` (e.g., `kafka:9092`)
- `KAFKA_DEFAULT_TOPIC` (e.g., `system.events`)

## API Endpoints
Base (internal): `http://event-service:8000`

- `POST /events/publish`
- `GET /health`

## Dependencies
- Kafka broker

## Run
- `docker compose up -d --build`
- Health: `http://localhost:8000/health` (container network) or mapped port if exposed separately

## Notes
This service is used internally by Approval Service via `EVENT_SERVICE_URL`.
