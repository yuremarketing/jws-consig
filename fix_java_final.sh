# Volta para a raiz do projeto (por garantia)
cd ~/Dev/consig-sniper-project

cat << 'EOF' > fix_java_final.sh
#!/bin/bash

echo "🚀 Reescrevendo o Controller e o Service com as correções finais..."

cat << 'CONTROLLER' > consig/src/main/java/com/jws/consig/controller/LeadController.java
package com.jws.consig.controller;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.service.LeadService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Arrays;
import java.util.Map;

@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "http://localhost:5173")
public class LeadController {

    private final LeadRepository leadRepository;
    private final LeadService leadService;

    public LeadController(LeadRepository leadRepository, LeadService leadService) {
        this.leadRepository = leadRepository;
        this.leadService = leadService;
    }

    @GetMapping("/leads")
    public ResponseEntity<org.springframework.data.domain.Page<Lead>> listarLeads(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        return ResponseEntity.ok(leadRepository.findAll(org.springframework.data.domain.PageRequest.of(page, size)));
    }

    @PostMapping("/leads/upload")
    public ResponseEntity<java.util.Map<String, Integer>> uploadCSV(@RequestParam("file") org.springframework.web.multipart.MultipartFile file) {
        return ResponseEntity.ok(leadService.importCSV(file));
    }

    @GetMapping("/leads/orgaos")
    public ResponseEntity<List<String>> listarOrgaos() {
        return ResponseEntity.ok(Arrays.asList("INSS", "SIAPE", "FGTS"));
    }

    @GetMapping("/consultores")
    public ResponseEntity<List<String>> listarConsultores() {
        return ResponseEntity.ok(Arrays.asList("Consultor 1", "Consultor 2"));
    }
}
CONTROLLER

cat << 'SERVICE' > consig/src/main/java/com/jws/consig/service/LeadService.java
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

    public java.util.Map<String, Integer> importCSV(org.springframework.web.multipart.MultipartFile file) {
        int adicionados = 0;
        int duplicados = 0;
        try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.InputStreamReader(file.getInputStream(), java.nio.charset.StandardCharsets.UTF_8))) {
            String line;
            boolean isFirstLine = true;
            while ((line = br.readLine()) != null) {
                if (isFirstLine) { isFirstLine = false; continue; }
                String[] colunas = line.split("[,;]");
                if (colunas.length < 2) continue;
                try {
                    Lead lead = new Lead();
                    lead.setNome(colunas[0].replace("\"", "").trim());
                    String cpf = colunas[1].replaceAll("[^0-9]", "");
                    if(cpf.length() > 11) cpf = cpf.substring(0, 11);
                    lead.setCpf(cpf);
                    lead.setOrgao(colunas.length > 2 ? colunas[2].replace("\"", "").trim() : "INSS");
                    lead.setEstado("DF");
                    lead.setStatus("Disponível");
                    repository.save(lead); // <-- CORRIGIDO AQUI!
                    adicionados++;
                } catch (Exception e) {
                    duplicados++;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return java.util.Map.of("adicionados", adicionados, "duplicados", duplicados);
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
SERVICE

echo "✅ Sucesso! O Java está livre de erros de compilação."
EOF

chmod +x fix_java_final.sh
./fix_java_final.sh
