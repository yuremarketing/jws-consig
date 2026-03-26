package com.jws.consig.controller.auth;

import com.jws.consig.config.JwtService;
import com.jws.consig.model.Usuario;
import com.jws.consig.repository.UsuarioRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UsuarioRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthController(UsuarioRepository repository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String email = credentials.get("username");
        String password = credentials.get("password");

        System.out.println("\n--- 🕵️ AUDITORIA DE LOGIN ---");
        System.out.println(">>> RECEBIDO NO JSON:");
        System.out.println("    Email: [" + email + "]");
        System.out.println("    Senha: [" + password + "]");

        return repository.findByEmail(email)
            .map(user -> {
                boolean matches = passwordEncoder.matches(password, user.getPassword());
                System.out.println(">>> ENCONTRADO NO BANCO:");
                System.out.println("    Email DB: [" + user.getEmail() + "]");
                System.out.println("    Hash DB:  [" + user.getPassword() + "]");
                System.out.println(">>> RESULTADO DA COMPARAÇÃO: " + (matches ? "✅ MATCH!" : "❌ FALHA"));

                if (matches) {
                    String token = jwtService.generateToken(user.getEmail(), user.getRole());
                    return ResponseEntity.ok(Map.of(
                        "token", token,
                        "role", user.getRole(),
                        "name", user.getName(),
                        "email", user.getEmail()
                    ));
                }
                return ResponseEntity.status(401).body(Map.of("error", "Senha não confere"));
            })
            .orElseGet(() -> {
                System.out.println(">>> ERRO: Usuário [" + email + "] não foi encontrado no banco.");
                return ResponseEntity.status(401).body(Map.of("error", "Usuário não encontrado"));
            });
    }
}
