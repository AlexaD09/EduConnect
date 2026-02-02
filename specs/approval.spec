# CU-03 Aprobar Jornada

## TC-CU03-HP-01 Aprobar actividad pendiente
* Limpiar headers
* Configurar header Content-Type con valor application/json
* Guardar body json
"""
{ "estado": "APROBADA" }
"""
* Hacer POST a /coordinator/activities/1/status con body
* La respuesta debe ser 200

## TC-CU03-EX-01 Rechazo sin observación (debe fallar)
* Limpiar headers
* Configurar header Content-Type con valor application/json
* Guardar body json
"""
{ "estado": "RECHAZADA" }
"""
* Hacer POST a /coordinator/activities/1/status con body
* La respuesta debe ser 400

## TC-CU03-ALT-01 Rechazo con observación
* Limpiar headers
* Configurar header Content-Type con valor application/json
* Guardar body json
"""
{ "estado": "RECHAZADA", "observacion": "Foto no corresponde a la jornada" }
"""
* Hacer POST a /coordinator/activities/1/status con body
* La respuesta debe ser 200
