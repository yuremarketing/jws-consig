import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
package com.jws.consig.controller.consultor;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/consultor/leads")
public class ConsultorLeadController {
    private static final Logger log = LoggerFactory.getLogger(ConsultorLeadController.class);

    private final LeadRepository repository;

    public ConsultorLeadController(LeadRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Lead> listar() {
        // Retorna apenas leads que ainda não foram trabalhados (Status NULL ou PENDING)
        return repository.findAll().stream()
                .filter(l -> l.getStatus() == null || l.getStatus().equals("PENDENTE"))
                .toList();
    }

    @PatchMapping("/{id}/status")
    @PatchMapping("/{id}/contato")
    public ResponseEntity<Void> registrarContato(@PathVariable Long id) {
        return repository.findById(id).map(lead -> {
            log.info("[CONTATO] Tentativa de abordagem para Lead ID: {}", id);
            return ResponseEntity.ok().<Void>build();
        }).orElse(ResponseEntity.notFound().build());
    }

    public ResponseEntity<Void> atualizarStatus(@PathVariable Long id, @RequestParam String status) {
        return repository.findById(id).map(lead -> {
            lead.setStatus(status.toUpperCase());
            repository.save(lead);
            log.info("[AUDITORIA] Lead ID: {} mudou para Status: {} em {}", id, status.toUpperCase(), java.time.LocalDateTime.now());
            return ResponseEntity.ok().<Void>build();
        }).orElse(ResponseEntity.notFound().build());
    }
}
