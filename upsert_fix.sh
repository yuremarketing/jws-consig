#!/bin/bash

echo "=== 🔄 APLICANDO LÓGICA DE UPSERT (REVISÃO QA) ==="

# 1. Atualizando o Repository para permitir busca por CPF
cat << 'INNER_EOF' > src/main/java/com/jws/consig/repository/LeadRepository.java
package com.jws.consig.repository;

import com.jws.consig.model.Lead;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface LeadRepository extends JpaRepository<Lead, Long>, JpaSpecificationExecutor<Lead> {
    Optional<Lead> findByCpf(String cpf);
    List<Lead> findByMargemGreaterThanEqualOrderByMargemDesc(BigDecimal margem);
    List<Lead> findByConsultorId(Long consultorId);
}
INNER_EOF

# 2. Atualizando o LeadService com lógica de checagem
cat << 'INNER_EOF' > src/main/java/com/jws/consig/service/LeadService.java
package com.jws.consig.service;

import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Optional;

@Service
public class LeadService {
    private final LeadRepository repository;
    private final UserRepository userRepository;

    public LeadService(LeadRepository repository, UserRepository userRepository) {
        this.repository = repository;
        this.userRepository = userRepository;
    }

    public Page<Lead> listarPaginado(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public void importCSV(MultipartFile file) throws Exception {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            boolean firstLine = true;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                if (firstLine) { firstLine = false; continue; }

                String separator = line.contains(";") ? ";" : ",";
                String[] data = line.split(separator);

                if (data.length >= 4) {
                    String cpf = data[0].replace("\"", "").trim();
                    
                    // LÓGICA UPSERT: Busca o lead existente ou cria um novo contêiner
                    Lead lead = repository.findByCpf(cpf).orElse(new Lead());
                    
                    lead.setCpf(cpf);
                    lead.setNome(data[1].replace("\"", "").trim());
                    
                    if (data.length >= 8) { // Formato BMG
                        lead.setOrgao(data[3].trim()); 
                        lead.setEstado(data[5].trim()); 
                        String mStr = data[7].trim().replace(".", "").replace(",", ".");
                        lead.setMargem(new BigDecimal(mStr));
                    } else { // Formato Padrão
                        lead.setOrgao(data[2].trim());
                        lead.setMargem(new BigDecimal(data[3].trim().replace(",", ".")));
                        lead.setEstado(data.length > 4 ? data[4].trim() : "DF");
                    }

                    // Só define status se for um lead novo (id nulo)
                    if (lead.getId() == null) {
                        lead.setStatus("DISPONIVEL");
                    }
                    
                    repository.save(lead);
                }
            }
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

echo "✅ Código atualizado com Sucesso!"
