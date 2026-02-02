Feature: CU-03 Aprobar Jornada

  Scenario: Sin token, aprobar debe fallar
    Given tengo la URL base
    When hago un PATCH a "/api/approvals/activities/1/approve" con JSON
      """
      { "observations": "OK" }
      """
    Then la respuesta debe ser uno de 401, 403

  Scenario: TC-CU03-EX-01 Rechazo sin observación (debe fallar)
    Given tengo la URL base
    # Si tienes credenciales de coordinador, descomenta estas 3 líneas:
    # When hago un POST a "/api/users/login" con JSON
    #   """{"username":"coordinador","password":"123456"}"""
    # Then la respuesta debe ser 200
    # And guardo el token de acceso
    # And preparo Authorization Bearer

    When hago un PATCH a "/api/approvals/activities/1/reject" con JSON
      """
      { "observations": "" }
      """
    Then la respuesta debe ser uno de 400, 401, 403
