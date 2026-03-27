package com.jws.consig.controller.admin;

import com.jws.consig.dto.AssignLeadsRequest;
import com.jws.consig.service.LeadService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/leads")
@CrossOrigin(origins = "http://localhost:5173")
public class AdminLeadController {

    private final LeadService leadService;

    public AdminLeadController(LeadService leadService) {
        this.leadService = leadService;
    }

    @PostMapping("/import")
    public ResponseEntity<?> importLeads(@RequestParam("file") MultipartFile file) {
        try {
            leadService.importCSV(file);
            return ResponseEntity.ok(Map.of("message", "Leads importados com sucesso!"));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", "Erro ao processar CSV: " + e.getMessage()));
        }
    }

    @PostMapping("/assign")
    public ResponseEntity<?> assignLeads(@RequestBody AssignLeadsRequest request) {
        try {
            leadService.atribuirLeads(request.leadIds(), request.consultorId());
            return ResponseEntity.ok(Map.of("message", "Leads distribuídos com sucesso!"));
        } catch (Exception e) {
            return ResponseEntity.status(400).body(Map.of("error", e.getMessage()));
        }
    }
}
