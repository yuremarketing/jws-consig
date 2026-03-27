#!/bin/bash

echo "--- 🎯 INICIANDO REPARO TOTAL DO SNIPER ---"

# 1. MATAR A DUPLICIDADE (O SEU MAIOR PROBLEMA)
# O Spring estava tentando ler dois AuthControllers e dois Models (User e Usuario)
rm -rf src/main/java/com/jws/consig/controller/auth
rm -rf src/main/java/com/jws/consig/model/Usuario.java
rm -rf src/main/java/com/jws/consig/repository/UsuarioRepository.java

# 2. GARANTIR PASTAS
mkdir -p src/main/java/com/jws/consig/model
mkdir -p src/main/java/com/jws/consig/repository
mkdir -p src/main/java/com/jws/consig/controller
mkdir -p src/main/java/com/jws/consig/config

# 3. UNIFICAR MODEL (User)
cat << 'EOF' > src/main/java/com/jws/consig/model/User.java
package com.jws.consig.model;
import jakarta.persistence.*;
import lombok.Data;

@Entity @Table(name = "users") @Data
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    private String password;
    private String role; // Ex: ROLE_ADMIN, ROLE_CONSULTOR
}
EOF

# 4. UNIFICAR REPOSITORY
cat << 'EOF' > src/main/java/com/jws/consig/repository/UserRepository.java
package com.jws.consig.repository;
import com.jws.consig.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
}
EOF

# 5. AUTHCONTROLLER ÚNICO (ADMIN + CONSULTOR)
# Ele usa o seu JwtService real e o PasswordEncoder
cat << 'EOF' > src/main/java/com/jws/consig/controller/AuthController.java
package com.jws.consig.controller;

import com.jws.consig.config.JwtService;
import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AuthController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthController(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String password = request.get("password");

        System.out.println("\n--- 🕵️ AUDITORIA DE LOGIN ---");
        System.out.println(">>> TENTATIVA: [" + email + "]");

        return userRepository.findByEmail(email)
            .map(user -> {
                if (passwordEncoder.matches(password, user.getPassword())) {
                    String token = jwtService.generateToken(user.getEmail(), user.getRole());
                    System.out.println("✅ ACESSO CONCEDIDO: " + user.getRole());
                    return ResponseEntity.ok(Map.of(
                        "token", token,
                        "role", user.getRole(),
                        "name", user.getName(),
                        "email", user.getEmail()
                    ));
                }
                return ResponseEntity.status(401).body(Map.of("error", "Senha incorreta"));
            })
            .orElseGet(() -> ResponseEntity.status(401).body(Map.of("error", "Usuário não encontrado")));
    }
}
EOF

# 6. DATALOADER (CARGA AUTOMÁTICA DOS DOIS PERFIS)
cat << 'EOF' > src/main/java/com/jws/consig/config/DataLoader.java
package com.jws.consig.config;

import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataLoader implements CommandLineRunner {
    private final UserRepository repo;
    private final PasswordEncoder encoder;

    public DataLoader(UserRepository repo, PasswordEncoder encoder) {
        this.repo = repo;
        this.encoder = encoder;
    }

    @Override
    public void run(String... args) {
        // ADMIN
        if (repo.findByEmail("admin@consig.com").isEmpty()) {
            User admin = new User();
            admin.setName("Admin");
            admin.setEmail("admin@consig.com");
            admin.setPassword(encoder.encode("admin123"));
            admin.setRole("ROLE_ADMIN");
            repo.save(admin);
        }
        // CONSULTOR (Ajustado para bater com seu SecurityConfig)
        if (repo.findByEmail("consultor@consig.com").isEmpty()) {
            User c = new User();
            c.setName("Consultor Sniper");
            c.setEmail("consultor@consig.com");
            c.setPassword(encoder.encode("senha123"));
            c.setRole("ROLE_CONSULTOR");
            repo.save(c);
        }
        System.out.println("✅ SNIPER: Usuarios Admin e Consultor prontos!");
    }
}
EOF

echo "--- 🚀 REPARO CONCLUÍDO. AGORA É SÓ RODAR O MVNW! ---"
