# User Service

## Overview
User Service provides authentication and user-related queries. It is implemented with a hexagonal structure (adapters + application use cases).

## Responsibilities
- User login (JWT issuance)
- User/student/coordinator lookup endpoints
- Agreement listing and agreement details queries

## Tech Stack
- FastAPI
- PostgreSQL

## Environment Variables (Docker Compose)
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

## API Endpoints
Base (internal): `http://user-service:8000`

- `POST /login`
- `GET /students/{student_id}`
- `GET /students/by-username/{username}`
- `GET /coordinators/by-username/{username}`
- `GET /agreements`
- `GET /agreements/{agreement_id}`
- `GET /health`

## Run
- `docker compose up -d --build`
- Swagger: `http://localhost:8000/api/users/docs` (via gateway prefix) or `http://localhost:8000/docs` (inside container network)

## Notes
The gateway maps `/api/users/` to this service.
