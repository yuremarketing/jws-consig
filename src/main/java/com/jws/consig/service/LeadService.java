package com.jws.consig.service;

import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.math.BigDecimal;
import java.util.List;

@Service
public class LeadService {
    private final LeadRepository repository;
    private final UserRepository userRepository;

    public LeadService(LeadRepository repository, UserRepository userRepository) {
        this.repository = repository;
        this.userRepository = userRepository;
    }

    public Page<Lead> listarPaginado(List<String> orgao, String margemFiltro, Pageable pageable) {
        BigDecimal min = null;
        BigDecimal max = null;
        if ("COM_MARGEM".equals(margemFiltro)) min = BigDecimal.ZERO;
        if ("SEM_MARGEM".equals(margemFiltro)) max = BigDecimal.ZERO;
        return repository.findWithFilters(orgao, min, max, pageable);
    }

    public void importCSV(MultipartFile file) {
        // Implementação básica para compilar (o Git deve ter a lógica real)
        System.out.println("Importando arquivo: " + file.getOriginalFilename());
    }

    public void atribuirLeads(List<Long> leadIds, Long consultorId) {
        User consultor = userRepository.findById(consultorId).orElseThrow();
        List<Lead> leads = repository.findAllById(leadIds);
        leads.forEach(l -> l.setConsultor(consultor));
        repository.saveAll(leads);
    }

    public Page<Lead> listarMeusLeads(User consultor, Pageable pageable) {
        return repository.findByConsultor(consultor, pageable);
    }
}
