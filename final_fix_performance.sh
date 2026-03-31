#!/bin/bash

echo "=== ⚡ OTIMIZAÇÃO SUPREMA DE PERSISTÊNCIA ==="

# Ajustando o LeadService para limpar a memória durante o processo
cat << 'INNER_EOF' > src/main/java/com/jws/consig/service/LeadService.java
package com.jws.consig.service;

import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Service
public class LeadService {
    private final LeadRepository repository;
    private final UserRepository userRepository;
    
    @PersistenceContext
    private EntityManager entityManager;

    public LeadService(LeadRepository repository, UserRepository userRepository) {
        this.repository = repository;
        this.userRepository = userRepository;
    }

    public Page<Lead> listarPaginado(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Transactional
    public void importCSV(MultipartFile file) throws Exception {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            boolean firstLine = true;
            int count = 0;
            
            System.out.println("🚀 Iniciando importação de alta performance...");

            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                if (firstLine) { firstLine = false; continue; }

                String separator = line.contains(";") ? ";" : ",";
                String[] data = line.split(separator);

                if (data.length >= 4) {
                    String cpf = data[0].replace("\"", "").trim();
                    
                    // Upsert rápido
                    Lead lead = repository.findByCpf(cpf).orElse(new Lead());
                    lead.setCpf(cpf);
                    lead.setNome(data[1].replace("\"", "").trim());
                    
                    if (data.length >= 8) {
                        lead.setOrgao(data[3].trim()); 
                        lead.setEstado(data[5].trim()); 
                        String mStr = data[7].trim().replace(".", "").replace(",", ".");
                        lead.setMargem(new BigDecimal(mStr));
                    } else {
                        lead.setOrgao(data[2].trim());
                        lead.setMargem(new BigDecimal(data[3].trim().replace(",", ".")));
                        lead.setEstado(data.length > 4 ? data[4].trim() : "DF");
                    }

                    if (lead.getId() == null) lead.setStatus("DISPONIVEL");
                    
                    repository.save(lead);
                    count++;

                    // LIMPEZA DE CACHE (Crucial para não travar o Java)
                    if (count % 100 == 0) {
                        entityManager.flush();
                        entityManager.clear();
                        System.out.println("⏳ Sincronizados: " + count + " leads com o banco...");
                    }
                }
            }
            System.out.println("✅ TOTAL: " + count + " leads persistidos com sucesso!");
        }
    }

    public void atribuirLeads(List<Long> leadIds, Long consultorId) {
        User consultor = userRepository.findById(consultorId)
                .orElseThrow(() -> new RuntimeException("Consultor não encontrado"));
        List<Lead> leads = repository.findAllById(leadIds);
        leads.forEach(lead -> {
            lead.setConsultor(consultor);
            lead.setStatus("ATRIBUIDO");
        });
        repository.saveAll(leads);
    }

    public List<Lead> listarLeadsFiltrados(String nome, String cpf, String orgao, String estado) {
        return repository.findAll();
    }
}
INNER_EOF

echo "✅ LeadService turbinado com Flush/Clear."
./mvnw clean compile
