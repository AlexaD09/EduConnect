Feature: CU-02 Registrar Actividad Diaria

  Scenario: TC-CU02-EX-01 Falta una foto (debe rechazar)
    Given tengo la URL base
    When intento registrar actividad SIN fotos para student_id "1"
    Then la respuesta debe ser uno de 400, 422

  Scenario: Smoke - Consultar actividades del estudiante
    Given tengo la URL base
    When hago un GET a "/api/activities/student/1"
    Then la respuesta debe ser 200
