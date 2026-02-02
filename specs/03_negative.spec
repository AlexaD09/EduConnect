# Pruebas Negativas

## Ruta inexistente
* Hacer GET a </ruta-que-no-existe>
* La respuesta debe ser <404>

## Login inválido
* Limpiar headers
* Configurar header <Content-Type> con valor <application/json>
* Guardar body json
"""
{
  "username": "usuario_invalido",
  "password": "clave_incorrecta"
}
"""
* Hacer POST a </login> con body
* La respuesta debe ser <401>
