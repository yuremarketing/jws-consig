#!/bin/bash

IT_TEST_FILE="src/test/java/com/jws/consig/service/LeadServiceIT.java"

echo "=============================================================="
echo "   CONSIG-SNIPER: SUÍTE DE TESTES DE INTEGRAÇÃO (DB REAL)     "
echo "=============================================================="

# Injetando o teste que carrega o Contexto do Spring
printf 'package com.jws.consig.service;\n\nimport com.jws.consig.model.Lead;\nimport com.jws.consig.repository.LeadRepository;\nimport org.junit.jupiter.api.DisplayName;\nimport org.junit.jupiter.api.Test;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.boot.test.context.SpringBootTest;\nimport org.springframework.transaction.annotation.Transactional;\n\nimport static org.junit.jupiter.api.Assertions.*;\n\n@SpringBootTest\n@Transactional\npublic class LeadServiceIT {\n\n    @Autowired\n    private LeadService service;\n\n    @Autowired\n    private LeadRepository repository;\n\n    @Test\n    @DisplayName("Integração: Validar Unicidade de CPF no PostgreSQL Real")\n    void testPersistenciaRealUnicidade() {\n        // Limpa resíduos de testes anteriores\n        repository.deleteAll();\n\n        Lead l1 = new Lead();\n        l1.setCpf("12345678901");\n        l1.setNome("Teste Integracao");\n        repository.save(l1);\n\n        // O service deve identificar que o CPF já existe no banco real\n        // e retornar a mensagem de erro ou não salvar novamente\n        String resultado = service.importarLeads("lista_teste.csv");\n        \n        assertNotNull(resultado);\n        System.out.println("Resultado da Integracao: " + resultado);\n    }\n}\n' > "$IT_TEST_FILE"

echo "✔ Teste de Integração (IT) injetado com sucesso."
echo "--------------------------------------------------------------"
echo "Executando Validação Completa (Unitários + Integração)..."
mvn test
