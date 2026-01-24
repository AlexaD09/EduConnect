# Agreement Service (Assignment)

## Overview
Agreement Service manages assignment-related operations for agreements, including fetching an assignment for a student, assigning resources, and listing assignments by coordinator. It calls User Service to enrich data when needed.

## Responsibilities
- Fetch student assignment
- Assign resources to a student (uses User Service)
- Query tutor details
- List assignments for a coordinator (enriched via User Service)

## Tech Stack
- FastAPI
- PostgreSQL
- Internal HTTP client to User Service

## Environment Variables (Docker Compose)
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

## API Endpoints
Base (internal): `http://agreement-service:8000`

- `GET /assignment/{student_id}`
- `POST /assign/{student_id}`
- `GET /tutors/{tutor_id}`
- `GET /assignments/coordinator/{coordinator_id}`

## Dependencies
- PostgreSQL (agreement-db)
- User Service (`user-service:8000`)

## Run
- `docker compose up -d --build`
- Swagger: `http://localhost:8000/api/agreements/docs` (via gateway)

## Notes
The gateway maps `/api/agreements/` to this service.
