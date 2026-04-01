package com.jws.consig.controller;

import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import com.jws.consig.security.JwtUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtils jwtUtils;

    public AuthController(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtils jwtUtils) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtils = jwtUtils;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String password = request.get("password");

        return userRepository.findByEmail(email)
            .map(user -> {
                if (passwordEncoder.matches(password, user.getPassword())) {
                    String token = jwtUtils.generateToken(user.getEmail());
                    // Enviamos campos extras para o Front não ter dúvida
                    return ResponseEntity.ok(Map.of(
                        "token", token,
                        "role", user.getRole(),
                        "isAdmin", user.getRole().equals("ROLE_ADMIN"),
                        "nome", user.getNome()
                    ));
                }
                return ResponseEntity.status(401).body(Map.of("message", "Senha incorreta"));
            })
            .orElse(ResponseEntity.status(401).body(Map.of("message", "Usuário não encontrado")));
    }
}
