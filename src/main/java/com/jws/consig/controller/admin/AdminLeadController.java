package com.jws.consig.controller.admin;

import com.jws.consig.dto.DistribuirRequest;
import com.jws.consig.service.LeadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.security.PermitAll;

@RestController
@RequestMapping("/api/admin/leads")
public class AdminLeadController {

    @Autowired
    private LeadService leadService;

    @PermitAll
    @PostMapping("/distribuir")
    public ResponseEntity<String> distribuir(@RequestBody DistribuirRequest request) {
        int total = leadService.distribuirAgora(
            request.getConsultorId(),
            request.getUf(),
            request.getOrgao(),
            request.getMargemMin()
        );
        return ResponseEntity.ok("Sucesso! " + total + " leads entregues ao consultor.");
    }
}
