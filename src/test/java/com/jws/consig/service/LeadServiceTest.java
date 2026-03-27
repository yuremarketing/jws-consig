package com.jws.consig.service;

import com.jws.consig.repository.LeadRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;

import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.times;

@ExtendWith(MockitoExtension.class)
class LeadServiceTest {

    @Mock
    private LeadRepository repository;

    @InjectMocks
    private LeadService service;

    @Test
    void testImportCSV() throws Exception {
        String csvContent = "nome;cpf;margem;telefone;orgao\nJOAO;123;100;61;GDF";
        MockMultipartFile file = new MockMultipartFile("file", "leads.csv", "text/csv", csvContent.getBytes());

        service.importCSV(file);

        verify(repository, times(1)).saveAll(anyList());
    }
}
