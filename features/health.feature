Feature: Disponibilidad del sistema

  Scenario: El sistema responde en health
    Given tengo la URL base
    When hago un GET a "/health"
    Then la respuesta debe ser 200
