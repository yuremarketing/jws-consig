package com.jws.consig.controller;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/leads")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class LeadController {

    private final LeadRepository repository;

    public LeadController(LeadRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public ResponseEntity<List<Lead>> listarLeads(@RequestParam(defaultValue = "0") BigDecimal minMargem) {
        System.out.println("🕵️ SNIPER: Buscando leads com margem mínima de: " + minMargem);
        List<Lead> leads = repository.findByMargemGreaterThanEqualOrderByMargemDesc(minMargem);
        return ResponseEntity.ok(leads);
    }
}
