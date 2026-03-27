package com.jws.consig.controller;

import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/leads")
@CrossOrigin(origins = "*")
public class ConsultorLeadController {

    private final LeadRepository leadRepository;
    private final UserRepository userRepository;

    public ConsultorLeadController(LeadRepository leadRepository, UserRepository userRepository) {
        this.leadRepository = leadRepository;
        this.userRepository = userRepository;
    }

    @GetMapping("/meus-leads")
    public ResponseEntity<?> getMeusLeads() {
        // Pega o usuário logado pelo Token
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();

        User consultor = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // Busca leads vinculados a este consultor
        List<Lead> leads = leadRepository.findByConsultorId(consultor.getId());

        return ResponseEntity.ok(leads);
    }
}
