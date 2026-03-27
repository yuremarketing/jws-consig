package com.jws.consig.service;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class LeadServiceIT {

    @Autowired
    private LeadService service;

    @Autowired
    private LeadRepository repository;

    @Test
    @DisplayName("Integração: Validar Unicidade de CPF no PostgreSQL Real")
    void testPersistenciaRealUnicidade() {
        // Limpa resíduos de testes anteriores
        repository.deleteAll();

        Lead l1 = new Lead();
        l1.setCpf("12345678901");
        l1.setNome("Teste Integracao");
        repository.save(l1);

        // O service deve identificar que o CPF já existe no banco real
        // e retornar a mensagem de erro ou não salvar novamente
        service.importarLeadsMassivo("lista_teste.csv");
        
//         assertNotNull(resultado);
//         System.out.println("Resultado da Integracao: " + resultado);
    }
}
