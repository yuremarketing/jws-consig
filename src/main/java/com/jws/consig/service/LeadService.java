package com.jws.consig.service;

import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.repository.UserRepository;
import com.opencsv.bean.CsvToBean;
import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.HeaderColumnNameMappingStrategy;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.List;

@Service
public class LeadService {

    private final LeadRepository repository;
    private final UserRepository userRepository;

    public LeadService(LeadRepository repository, UserRepository userRepository) {
        this.repository = repository;
        this.userRepository = userRepository;
    }

    public void importCSV(MultipartFile file) throws Exception {
        try (Reader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
            HeaderColumnNameMappingStrategy<Lead> strategy = new HeaderColumnNameMappingStrategy<>();
            strategy.setType(Lead.class);

            CsvToBean<Lead> csvToBean = new CsvToBeanBuilder<Lead>(reader)
                    .withMappingStrategy(strategy)
                    .withIgnoreLeadingWhiteSpace(true)
                    .withSeparator(';')
                    .withType(Lead.class)
                    .build();

            List<Lead> leads = csvToBean.parse();
            
            leads.forEach(lead -> {
                if (lead.getStatus() == null) lead.setStatus("DISPONIVEL");
            });

            repository.saveAll(leads);
        }
    }

    public void atribuirLeads(List<Long> leadIds, Long consultorId) {
        User consultor = userRepository.findById(consultorId)
                .orElseThrow(() -> new RuntimeException("Consultor não encontrado"));

        List<Lead> leads = repository.findAllById(leadIds);
        leads.forEach(lead -> {
            lead.setConsultor(consultor);
            lead.setStatus("EM_ATENDIMENTO");
        });

        repository.saveAll(leads);
    }
}
