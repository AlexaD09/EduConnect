# Audit Service

## Overview
Audit Service provides querying of audit records stored in MongoDB. It also has configuration to consume domain events from RabbitMQ (exchange/queue/bindings configured via environment variables).

## Responsibilities
- List and filter audit events from MongoDB
- Health endpoint
- RabbitMQ integration configured for domain events

## Tech Stack
- FastAPI
- MongoDB
- RabbitMQ

## Environment Variables (Docker Compose)
- `MONGO_URI` (e.g., `mongodb://audit-mongo:27017`)
- `RABBITMQ_URL` (e.g., `amqp://guest:guest@rabbitmq:5672/`)
- `RABBITMQ_EXCHANGE` (e.g., `domain_events`)
- `RABBITMQ_QUEUE` (e.g., `audit_service_queue`)
- `RABBITMQ_BINDING_KEYS` (e.g., `approval.*`)

## API Endpoints
Base (container): `http://audit-service:80`

- `GET /audit` (filters: event_type, entity_type, entity_id, limit)
- `GET /health`

## Exposed Port (Docker Compose)
- Host: `http://localhost:8010`

## Dependencies
- MongoDB (audit-mongo)
- RabbitMQ (rabbitmq)

## Run
- `docker compose up -d --build`
