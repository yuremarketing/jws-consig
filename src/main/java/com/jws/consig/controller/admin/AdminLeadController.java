package com.jws.consig.controller.admin;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import com.jws.consig.service.LeadService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/leads")
public class AdminLeadController {

    private final LeadService service;
    private final LeadRepository repository;

    public AdminLeadController(LeadService service, LeadRepository repository) {
        this.service = service;
        this.repository = repository;
    }

    @PostMapping("/importar")
    public ResponseEntity<String> importar(@RequestParam("file") MultipartFile file) {
        try {
            String path = "/tmp/" + file.getOriginalFilename();
            file.transferTo(new java.io.File(path));
            return ResponseEntity.ok(service.importarLeads(path));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Erro: " + e.getMessage());
        }
    }

    @GetMapping("/exportar")
    public ResponseEntity<byte[]> exportarVendidos() {
        List<Lead> vendidos = repository.findAll().stream()
                .filter(l -> "VENDIDO".equals(l.getStatus()))
                .collect(Collectors.toList());

        StringBuilder csv = new StringBuilder("ID,NOME,CPF,MARGEM,STATUS\n");
        for (Lead l : vendidos) {
            csv.append(String.format("%d,%s,%s,%.2f,%s\n", 
                l.getId(), l.getNome(), l.getCpf(), l.getMargem(), l.getStatus()));
        }

        byte[] out = csv.toString().getBytes();
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=relatorio_vendas.csv")
                .header(HttpHeaders.CONTENT_TYPE, "text/csv")
                .body(out);
    }
}
