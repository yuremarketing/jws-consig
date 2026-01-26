package com.jws.consig_sniper.controller;

import com.jws.consig_sniper.model.User;
import com.jws.consig_sniper.repository.UserRepository;
import com.jws.consig_sniper.security.TokenService;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final TokenService tokenService;
    private final UserRepository userRepository;

    public AuthController(AuthenticationManager authenticationManager, TokenService tokenService, UserRepository userRepository) {
        this.authenticationManager = authenticationManager;
        this.tokenService = tokenService;
        this.userRepository = userRepository;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> data) {
        String cpf = data.get("cpf");
        String password = data.get("password");

        // Verifica se o usuário existe e se está ATIVO
        Optional<User> userCheck = userRepository.findByCpf(cpf);
        if (userCheck.isPresent()) {
            if (userCheck.get().getIsActive() != null && !userCheck.get().getIsActive()) {
                return ResponseEntity.status(403).body(Map.of("message", "Acesso negado: Usuário inativo."));
            }
        }

        var usernamePassword = new UsernamePasswordAuthenticationToken(cpf, password);
        var auth = authenticationManager.authenticate(usernamePassword);
        
        var userPrincipal = (User) auth.getPrincipal();
        var token = tokenService.generateToken(userPrincipal);
        
        Map<String, Object> userData = Map.of(
            "nome", userPrincipal.getNome(),
            "role", userPrincipal.getRole(),
            "cpf", userPrincipal.getCpf()
        );
        
        return ResponseEntity.ok(Map.of("token", token, "user", userData));
    }
}
