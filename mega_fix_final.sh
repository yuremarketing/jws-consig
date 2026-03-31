#!/bin/bash

echo "=== 🚀 INICIANDO MEGA FIX: REGRAS DE NEGÓCIO + INFRA ==="

# PASSO 1: Aumentar limite de upload no application.properties
echo "[1/3] Ajustando limites de tamanho de arquivo..."
PROPS="src/main/resources/application.properties"
sed -i '/spring.servlet.multipart/d' $PROPS
echo "spring.servlet.multipart.max-file-size=10MB" >> $PROPS
echo "spring.servlet.multipart.max-request-size=10MB" >> $PROPS
echo "✅ Limites de 10MB configurados."

# PASSO 2: Injetar LeadService inteligente (Aceita ; e , e limpa números)
echo "[2/3] Atualizando LeadService com lógica de detecção de CSV..."
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

                // Detecta separador e limpa aspas se houver
                String separator = line.contains(";") ? ";" : ",";
                String[] data = line.split(separator);

                if (data.length >= 4) {
                    Lead lead = new Lead();
                    lead.setCpf(data[0].replace("\"", "").trim());
                    lead.setNome(data[1].replace("\"", "").trim());
                    
                    // Mapeamento dinâmico baseado no seu arquivo real
                    // Se for BMG (len > 7), usa índices específicos, senão usa padrão
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

                    lead.setStatus("DISPONIVEL");
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
echo "✅ LeadService atualizado com inteligência de separador."

# PASSO 3: Reset de Ambiente e Compilação
echo "[3/3] Limpando processos e compilando..."
fuser -k 8080/tcp 2>/dev/null
./mvnw clean compile

echo -e "\n=== 🏁 TUDO PRONTO! RODE: ./mvnw spring-boot:run ==="
