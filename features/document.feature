@wip
Feature: CU-04 Generar Documentos para Impresión

  Scenario: TC-CU04-EX-01 Si no hay actividades aprobadas, debe avisar
    Given tengo la URL base
    When hago un GET a "/api/reports/pdfs?from=2026-01-01&to=2026-01-31"
    Then la respuesta debe ser uno de 400, 404
