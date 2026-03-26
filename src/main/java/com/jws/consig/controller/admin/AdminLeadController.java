package com.jws.consig.controller.admin;

import com.jws.consig.model.SystemConfig;
import com.jws.consig.repository.ConfigRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.Map;
import java.util.List;

@RestController
@RequestMapping("/api/admin")
public class AdminLeadController {

    private final ConfigRepository configRepo;

    public AdminLeadController(ConfigRepository configRepo) { 
        this.configRepo = configRepo; 
    }

    @PostMapping("/leads/importar")
    public ResponseEntity<?> importarLeads(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(Map.of("message", "Arquivo " + file.getOriginalFilename() + " recebido com sucesso!"));
    }

    @GetMapping("/config")
    public ResponseEntity<List<SystemConfig>> getConfigs() {
        return ResponseEntity.ok(configRepo.findAll());
    }

    @PostMapping("/config")
    public ResponseEntity<?> saveConfig(@RequestBody Map<String, String> payload) {
        payload.forEach((k, v) -> configRepo.save(new SystemConfig(k, v)));
        return ResponseEntity.ok(Map.of("status", "Configuracoes Salvas no DB"));
    }
}
