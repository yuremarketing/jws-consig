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
