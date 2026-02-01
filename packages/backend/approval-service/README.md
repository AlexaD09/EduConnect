# Approval Service

## Overview
Approval Service manages the approval workflow for activities. It requires a coordinator role (JWT) and integrates with Activity Service, User Service, and Event Service.

## Responsibilities
- Approve an activity (writes approval log + updates activity status)
- Reject an activity (writes approval log + updates activity status)
- Publish domain events when approval/rejection occurs

## Tech Stack
- FastAPI
- PostgreSQL
- JWT-based authorization (coordinator)
- HTTP clients: Activity Service, User Service, Event Service

## Environment Variables (Docker Compose).
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
- `ACTIVITY_SERVICE_URL` (e.g., `http://activity-service:8000`)
- `EVENT_SERVICE_URL` (e.g., `http://event-service:8000`)
- `USER_SERVICE_URL` (e.g., `http://user-service:8000`)

## API Endpoints
Base (internal): `http://approval-service:8000`

- `PATCH /activities/{activity_id}/approve`
- `PATCH /activities/{activity_id}/reject`

## Dependencies
- PostgreSQL (approval-db)
- Activity Service
- User Service
- Event Service

## Run
- `docker compose up -d --build`
- Swagger: `http://localhost:8000/api/approvals/docs` (via gateway)

## Notes
The gateway maps `/api/approvals/` to this service.
