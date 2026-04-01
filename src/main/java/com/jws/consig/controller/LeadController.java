package com.jws.consig.controller;

import com.jws.consig.model.Lead;
import com.jws.consig.service.LeadService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/admin/leads") // Ajustado para bater com o seu Front
@CrossOrigin(origins = "http://localhost:5173")
public class LeadController {

    private final LeadService leadService;

    public LeadController(LeadService leadService) {
        this.leadService = leadService;
    }

    @GetMapping
    public ResponseEntity<Page<Lead>> listar(
            @RequestParam(required = false) List<String> orgao,
            @RequestParam(required = false) String margem,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        
        System.out.println("🚀 ADMIN: Buscando leads na base...");
        return ResponseEntity.ok(leadService.listarPaginado(orgao, margem, PageRequest.of(page, size)));
    }
}
