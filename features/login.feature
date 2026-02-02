Feature: CU-01 Iniciar Sesión

  Scenario: TC-CU01-HP-01 Login exitoso (estudiante o coordinador)
    Given tengo la URL base
    When hago un POST a "/api/users/login" con JSON
      """
      { "username": "chpell", "password": "123456" }
      """
    Then la respuesta debe ser 200
    And guardo el token de acceso

  Scenario: TC-CU01-EX-01 Credenciales incorrectas
    Given tengo la URL base
    When hago un POST a "/api/users/login" con JSON
      """
      { "username": "chpell", "password": "mala" }
      """
    Then la respuesta debe ser 401
