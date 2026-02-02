Feature: CU-05 Asignar Tutor Académico

  Scenario: Consultar asignación actual del estudiante
    Given tengo la URL base
    When hago un GET a "/api/agreements/assignment/1"
    Then la respuesta debe ser uno de 200, 404

  Scenario: Asignar tutor manualmente al estudiante
    Given tengo la URL base
    When hago un POST a "/api/agreements/assign/1" con JSON
      """
      { "tutor_id": 1 }
      """
    Then la respuesta debe ser uno de 200, 201, 400, 422
