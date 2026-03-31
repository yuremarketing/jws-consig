#!/bin/bash
# Ajustando apenas o necessário para o React parar de dar erro de JSON.parse
cat << 'INNER_EOF' > src/main/java/com/jws/consig/controller/LeadController.java
package com.jws.consig.controller;

import com.jws.consig.model.Lead;
import com.jws.consig.service.LeadService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/leads")
public class LeadController {

    private final LeadService leadService;

    public LeadController(LeadService leadService) {
        this.leadService = leadService;
    }

    @GetMapping
    public ResponseEntity<Page<Lead>> listar(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ResponseEntity.ok(leadService.listarPaginado(PageRequest.of(page, size)));
    }

    @PostMapping("/importar")
    public ResponseEntity<?> importar(@RequestParam("file") MultipartFile file) {
        try {
            leadService.importCSV(file);
            // Retornando um MAP que o Spring converte automaticamente para JSON
            return ResponseEntity.ok(Map.of("message", "Importação concluída com sucesso!"));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", "Erro ao processar CSV: " + e.getMessage()));
        }
    }
}
INNER_EOF
echo "✅ LeadController atualizado para responder JSON."
./mvnw clean compile
