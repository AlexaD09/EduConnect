# CU-02 Registrar Actividad Diaria

## TC-CU02-HP-01 Registrar actividad (pendiente)
* Limpiar headers
* Configurar header Content-Type con valor application/json
# Si tu API requiere token, primero corre 01_login.spec y deja Authorization en headers
* Guardar body json
"""
{
  "descripcion": "Actividad diaria de prueba",
  "problema": "N/A",
  "solucion": "N/A",
  "foto_entrada_base64": "REEMPLAZAR_O_USAR_DEMO",
  "foto_salida_base64": "REEMPLAZAR_O_USAR_DEMO"
}
"""
* Hacer POST a /activities con body
* La respuesta debe ser 201

## TC-CU02-EX-01 Falta una foto / metadatos inválidos
* Limpiar headers
* Configurar header Content-Type con valor application/json
* Guardar body json
"""
{
  "descripcion": "Sin foto de salida",
  "foto_entrada_base64": "REEMPLAZAR_O_USAR_DEMO"
}
"""
* Hacer POST a /activities con body
* La respuesta debe ser 400
