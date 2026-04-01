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
        return ResponseEntity.ok(leadRepository.findDistinctOrgaos());
    }

    @GetMapping("/consultores")
    public ResponseEntity<List<String>> listarConsultores() {
        return ResponseEntity.ok(Arrays.asList("Consultor 1", "Consultor 2"));
    }
}
