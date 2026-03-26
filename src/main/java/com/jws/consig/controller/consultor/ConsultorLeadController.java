package com.jws.consig.controller.consultor;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/consultor")
public class ConsultorLeadController {

    private static final Logger log = LoggerFactory.getLogger(ConsultorLeadController.class);
    private final LeadRepository repository;

    public ConsultorLeadController(LeadRepository repository) {
        this.repository = repository;
    }

    // Lista apenas leads PENDENTES (visão do consultor)
    @GetMapping("/leads")
    public List<Lead> getLeads() {
        return repository.findAll().stream()
            .filter(l -> l.getStatus() == null || "PENDENTE".equals(l.getStatus()))
            .toList();
    }

    // Atualiza status via query param — alinhado com o frontend
    // Frontend chama: PATCH /consultor/leads/{id}/status?status=VENDIDO
    @PatchMapping("/leads/{id}/status")
    public ResponseEntity<Void> updateStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        return repository.findById(id).map(lead -> {
            lead.setStatus(status.toUpperCase());
            repository.save(lead);
            log.info("[AUDITORIA] Lead ID: {} → status: {}", id, status.toUpperCase());
            return ResponseEntity.ok().<Void>build();
        }).orElse(ResponseEntity.notFound().build());
    }

    // Registra tentativa de contato (log de auditoria)
    @PatchMapping("/leads/{id}/contato")
    public ResponseEntity<Void> registrarContato(@PathVariable Long id) {
        log.info("[CONTATO] Abordagem registrada para Lead ID: {}", id);
        return ResponseEntity.ok().build();
    }
}
