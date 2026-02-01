# User Service

## Overview
The User Service is responsible for authentication and user-related queries within the Academic Linkage platform.  
It follows a hexagonal architecture, separating domain logic, application use cases, and infrastructure adapters.

## Responsibilities
- User authentication and JWT generation
- Student and coordinator information queries
- Agreement listing and agreement detail queries
- Service health check 

## Architecture
- Architecture style: Hexagonal (Ports & Adapters)
- Communication: Internal REST API
- Default port:8000

## Tech Stack
- Python
- FastAPI
- PostgreSQL
- Docker
- JWT Authentication

## Environment Variables
The following environment variables are required when running the service:

```env
DB_HOST
DB_PORT
DB_NAME
DB_USER
DB_PASSWORD
   