# CU-04 Generar Documentos para Impresión

## TC-CU04-HP-01 Genera y descarga 3 PDFs
* Limpiar headers
* Hacer GET a /reports/evidence.pdf?from=2026-01-01&to=2026-12-31
* La respuesta debe ser 200
* El contenido debe ser PDF

* Limpiar headers
* Hacer GET a /reports/activities.pdf?from=2026-01-01&to=2026-12-31
* La respuesta debe ser 200
* El contenido debe ser PDF

* Limpiar headers
* Hacer GET a /reports/hours.pdf?from=2026-01-01&to=2026-12-31
* La respuesta debe ser 200
* El contenido debe ser PDF

## TC-CU04-EX-01 Sin aprobadas (no genera)
* Limpiar headers
* Hacer GET a /reports/evidence.pdf?from=2030-01-01&to=2030-01-02
* La respuesta debe ser 400
