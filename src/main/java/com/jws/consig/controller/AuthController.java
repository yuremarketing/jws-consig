package com.jws.consig.controller;

import com.jws.consig.security.JwtUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final JwtUtils jwtUtils;

    public AuthController(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credenciais) {
        String email = credenciais.get("email");
        String password = credenciais.get("password");

        // Validação Sniper: Por enquanto fixa, logo conectaremos ao banco
        if ("admin@consig.com".equals(email) && "admin".equals(password)) {
            String token = jwtUtils.generateToken(email);
            
            // Retorna o Token e o Perfil (CU-01)
            return ResponseEntity.ok(Map.of(
                "token", token,
                "role", "ROLE_ADMIN",
                "email", email
            ));
        }

        // Se errar, barra na entrada (401 Unauthorized)
        return ResponseEntity.status(401).body(Map.of("error", "E-mail ou senha inválidos"));
    }
}
