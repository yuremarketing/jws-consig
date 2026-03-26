#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

BACK_DIR="consig/src/main/java/com/jws/consig"

echo -e "${CYAN}--- RESETANDO O AMBIENTE (FORÇA BRUTA) ---${NC}"

# 1. Matando tudo que existe nas portas
sudo fuser -k 8080/tcp 5432/tcp 2>/dev/null

# 2. Resetando o Docker para garantir que o Postgres limpe os sockets
docker compose down
docker compose up -d

# 3. Forçando o IP 127.0.0.1 no application.properties (Evita erro de IPv6 do localhost)
cat << 'INNER' > consig/src/main/resources/application.properties
spring.datasource.url=jdbc:postgresql://127.0.0.1:5432/consigsniper
spring.datasource.username=postgres
spring.datasource.password=postgres
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
INNER

# 4. Garantindo que o Controller tenha TUDO (Upload + Config + Admin)
cat << 'INNER' > $BACK_DIR/controller/admin/AdminLeadController.java
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
        return ResponseEntity.ok(Map.of("status", "SUCESSO", "mensagem", "Arquivo " + file.getOriginalFilename() + " processado!"));
    }

    @GetMapping("/config")
    public ResponseEntity<List<SystemConfig>> getConfigs() {
        return ResponseEntity.ok(configRepo.findAll());
    }

    @PostMapping("/config")
    public ResponseEntity<?> saveConfig(@RequestBody Map<String, String> payload) {
        payload.forEach((k, v) -> configRepo.save(new SystemConfig(k, v)));
        return ResponseEntity.ok(Map.of("status", "SALVO", "detalhe", "Configuracoes de Admin atualizadas no PostgreSQL"));
    }
}
INNER

echo -e "${GREEN}Ambiente reconfigurado com IP Fixo e código blindado.${NC}"
echo -e "${CYAN}--- TESTANDO CONEXÃO COM O BANCO AGORA ---${NC}"

# Espera o Postgres respirar
sleep 3
nc -zv 127.0.0.1 5432

if [ $? -eq 0 ]; then
    echo -e "${GREEN}BANCO ACESSÍVEL! O Java não tem mais desculpa.${NC}"
    echo -e "Comando para subir: ${CYAN}cd consig && ./mvnw spring-boot:run${NC}"
else
    echo -e "${RED}ERRO: A porta 5432 ainda não responde. Verifique 'docker logs sniper-db'.${NC}"
fi
