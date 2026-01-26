package com.jws.consig_sniper.controller;

import com.jws.consig_sniper.model.Lead;
import com.jws.consig_sniper.service.LeadService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/leads")
public class LeadController {

    private final LeadService leadService;

    public LeadController(LeadService leadService) {
        this.leadService = leadService;
    }

    @GetMapping("/my")
    public List<Lead> getMyLeads(Authentication authentication) {
        String userCpf = authentication.getName();
        return leadService.getMyLeads(userCpf); // Chama getMyLeads
    }

    @PostMapping("/import")
    public ResponseEntity<?> importLeads(@RequestParam("file") MultipartFile file) {
        try {
            int count = leadService.importLeads(file); // Chama importLeads
            return ResponseEntity.ok(Map.of("message", "Importação concluída!", "count", count));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/distribute")
    public ResponseEntity<?> distributeLeads(@RequestBody Map<String, Object> payload) {
        try {
            String userIdStr = (String) payload.get("userId");
            UUID userId = UUID.fromString(userIdStr);
            int quantity = (int) payload.get("quantity");

            int distributed = leadService.distributeLeads(userId, quantity); // Chama distributeLeads
            return ResponseEntity.ok(Map.of("message", "Leads distribuídos", "count", distributed));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}