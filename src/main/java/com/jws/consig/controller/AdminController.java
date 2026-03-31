package com.jws.consig.controller;

import com.jws.consig.service.LeadService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private final LeadService leadService;

    public AdminController(LeadService leadService) {
        this.leadService = leadService;
    }

    @PutMapping("/leads/atribuir")
    public ResponseEntity<?> atribuirLeads(@RequestBody Map<String, Object> payload) {
        try {
            List<Integer> idsInt = (List<Integer>) payload.get("leadIds");
            List<Long> leadIds = idsInt.stream().map(Integer::longValue).toList();
            Long consultorId = Long.valueOf(payload.get("consultorId").toString());
            leadService.atribuirLeads(leadIds, consultorId);
            return ResponseEntity.ok(Map.of("message", "Sucesso!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
