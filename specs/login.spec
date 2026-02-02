# CU-01 Iniciar Sesión

## TC-CU01-HP-01 Login exitoso
* Limpiar headers
* Configurar header Content-Type con valor application/json
* Guardar body json
"""
{
  "email": "estudiante@demo.com",
  "password": "123456"
}
"""
* Hacer POST a /auth/login con body
* La respuesta debe ser 200
* El json debe tener la clave access_token
* Guardar token desde clave access_token como header Authorization

## TC-CU01-EX-01 Credenciales incorrectas
* Limpiar headers
* Configurar header Content-Type con valor application/json
* Guardar body json
"""
{
  "email": "estudiante@demo.com",
  "password": "MAL"
}
"""
* Hacer POST a /auth/login con body
* La respuesta debe ser 401
