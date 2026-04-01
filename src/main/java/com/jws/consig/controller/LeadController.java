package com.jws.consig.controller;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Arrays;

@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "http://localhost:5173")
public class LeadController {

    private final LeadRepository leadRepository;

    public LeadController(LeadRepository leadRepository) {
        this.leadRepository = leadRepository;
    }

    @GetMapping("/leads")
    public ResponseEntity<org.springframework.data.domain.Page<Lead>> listarLeads(
            @org.springframework.web.bind.annotation.RequestParam(defaultValue = "0") int page,
            @org.springframework.web.bind.annotation.RequestParam(defaultValue = "50") int size) {
        return ResponseEntity.ok(leadRepository.findAll(org.springframework.data.domain.PageRequest.of(page, size)));
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
