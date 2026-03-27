package com.jws.consig.service;

import com.jws.consig.repository.LeadRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.assertFalse;

@SpringBootTest
@Transactional
class LeadServiceIT {

    @Autowired
    private LeadService service;

    @Autowired
    private LeadRepository repository;

    @Test
    void testImportCSVIntegration() throws Exception {
        String csvContent = "nome;cpf;margem;telefone;orgao\nTESTE;00011122233;500.00;61999998888;GDF";
        MockMultipartFile file = new MockMultipartFile("file", "leads.csv", "text/csv", csvContent.getBytes());

        service.importCSV(file);

        assertFalse(repository.findAll().isEmpty(), "O banco não deveria estar vazio após a importação");
    }
}
