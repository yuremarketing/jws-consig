package com.jws.consig.controller;

import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import com.jws.consig.service.LeadService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/meus-leads")
@CrossOrigin(origins = "*")
public class ConsultorController {
    private final LeadService leadService;
    private final UserRepository userRepository;

    public ConsultorController(LeadService leadService, UserRepository userRepository) {
        this.leadService = leadService;
        this.userRepository = userRepository;
    }

    @GetMapping
    public ResponseEntity<Page<Lead>> listar(@AuthenticationPrincipal UserDetails userDetails, Pageable pageable) {
        User consultor = userRepository.findByEmail(userDetails.getUsername()).orElseThrow();
        return ResponseEntity.ok(leadService.listarMeusLeads(consultor, pageable));
    }
}
