# Login

## Login válido devuelve token
* Limpiar headers
* Configurar header <Content-Type> con valor <application/json>
* Guardar body json
"""
{
  "username": "admin",
  "password": "admin123"
}
"""
* Hacer POST a </login> con body
* La respuesta debe ser <200>
* La respuesta json debe tener la clave <access_token>
