package com.jws.consig.controller;

import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/users")
@CrossOrigin(origins = "*")
public class UserController {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserController(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping
    public ResponseEntity<List<User>> listarTodos() {
        return ResponseEntity.ok(userRepository.findAll());
    }

    @PostMapping
    public ResponseEntity<?> salvar(@RequestBody User newUser) {
        if (userRepository.findByEmail(newUser.getEmail()).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("message", "E-mail já cadastrado"));
        }
        newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
        newUser.setTrocaSenhaObrigatoria(true);
        newUser.setAtivo(true);
        userRepository.save(newUser);
        return ResponseEntity.ok(Map.of("message", "Usuário criado com sucesso!"));
    }

    // 🎯 O ALVO DO ERRO: Método PUT para atualização
    @PutMapping("/{id}")
    public ResponseEntity<?> atualizar(@PathVariable Long id, @RequestBody User dados) {
        return userRepository.findById(id).map(user -> {
            user.setNome(dados.getNome());
            user.setEmail(dados.getEmail());
            // Se o cargo vier no campo 'role', atualizamos também
            if (dados.getRole() != null) user.setRole(dados.getRole());
            userRepository.save(user);
            System.out.println("✅ Usuário ID " + id + " atualizado com sucesso no banco.");
            return ResponseEntity.ok(Map.of("message", "Usuário atualizado com sucesso!"));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> toggleStatus(@PathVariable Long id) {
        return userRepository.findById(id).map(user -> {
            user.setAtivo(!user.isAtivo());
            userRepository.save(user);
            return ResponseEntity.ok(Map.of("message", "Status alterado com sucesso"));
        }).orElse(ResponseEntity.notFound().build());
    }
}
