# Activity Service

## Overview
Activity Service registers student activities with entry/exit photos, stores them, and exposes queries used by other services. It also provides an endpoint to update activity status (used by Approval Service).

## Responsibilities
- Register activity with entry/exit photos
- List activities by student
- List pending activities by agreement
- Provide activity details
- Update activity status (approve/reject) via internal endpoint

## Tech Stack
- FastAPI 
- PostgreSQL
- File storage volume (Docker volume)

## Environment Variables (Docker Compose)
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

## API Endpoints
Base (internal): `http://activity-service:8000`

- `POST /activity` (multipart form-data with photos)
- `GET /student/{student_id}`
- `GET /pending-by-agreement/{agreement_id}`
- `GET /student-activity/{activity_id}`
- `PATCH /activities/{activity_id}/status`

## Storage
A Docker volume is mounted for storage:
- Volume: `activity_storage`
- Container path: `/app/storage`

## Dependencies
- PostgreSQL (activity-db)
- Agreement Service (used as a gateway/dependency in code)

## Run
- `docker compose up -d --build`
- Swagger: `http://localhost:8000/api/activities/docs` (via gateway)

## Notes
The gateway maps `/api/activities/` to this service.
