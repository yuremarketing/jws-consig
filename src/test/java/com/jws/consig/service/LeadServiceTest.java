package com.jws.consig.service;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.util.Optional;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class LeadServiceTest {

    @Mock
    private LeadRepository repository;

    @InjectMocks
    private LeadService service;

    @Test
    @DisplayName("Se Lead existe, não deve chamar o Save")
    void testNaoDeveSalvarDuplicado() {
        when(repository.findByCpf(anyString())).thenReturn(Optional.of(new Lead()));
        service.importarLeadsMassivo("lista_teste.csv");
        verify(repository, never()).save(any(Lead.class));
    }
}
