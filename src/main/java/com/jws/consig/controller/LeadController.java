package com.jws.consig.controller;
import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.repository.UserRepository;
import com.jws.consig.service.LeadService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "http://localhost:5173")
public class LeadController {
    private final LeadRepository leadRepository;
    private final LeadService leadService;
    private final UserRepository userRepository;

    public LeadController(LeadRepository leadRepository, LeadService leadService, UserRepository userRepository) {
        this.leadRepository = leadRepository;
        this.leadService = leadService;
        this.userRepository = userRepository;
    }

    @GetMapping("/leads")
    public ResponseEntity<Page<Lead>> listarLeads(
            @RequestParam(required = false) List<String> orgaos,
            @RequestParam(required = false) String margem,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        return ResponseEntity.ok(leadService.listarPaginado(orgaos, margem, PageRequest.of(page, size)));
    }

    @PostMapping("/leads/upload")
    public ResponseEntity<Map<String, Integer>> uploadCSV(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(leadService.importCSV(file));
    }

    @GetMapping("/leads/orgaos")
    public ResponseEntity<List<String>> listarOrgaos() {
        return ResponseEntity.ok(leadRepository.findDistinctOrgaos());
    }

    // Retorna consultores reais do banco (ativos, com role CONSULTOR ou ADMIN)
    @GetMapping("/consultores")
    public ResponseEntity<List<Map<String, Object>>> listarConsultores() {
        List<Map<String, Object>> consultores = userRepository.findAll().stream()
            .filter(User::isAtivo)
            .map(u -> Map.of("id", (Object) u.getId(), "nome", (Object) u.getNome()))
            .collect(Collectors.toList());
        return ResponseEntity.ok(consultores);
    }
}
