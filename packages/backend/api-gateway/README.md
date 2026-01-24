# API Gateway (NGINX)

## Overview
This service is the single entry point for the backend. It routes HTTP requests to internal services on the Docker network and applies basic controls such as rate limiting and CORS.

## Responsibilities
- Reverse proxy and routing
- Rate limiting (per IP)
- CORS headers (configured for http://localhost:3000)

## Tech Stack
- NGINX (containerized)

## Exposed Port (Docker Compose)
- Host: `http://localhost:8000`
- Container: `80`

## Routed Paths
The gateway routes these prefixes to internal services:

- `/api/users/` -> `user-service:8000`
- `/api/activities/` -> `activity-service:8000`
- `/api/agreements/` -> `agreement-service:8000`
- `/api/approvals/` -> `approval-service:8000`

## How to Run
From repository root:
- `docker compose up -d --build`

## Notes
Some internal services (event-service, audit-service, notification-service) are not routed through NGINX in the current configuration and are accessed via their own ports or internal calls.
