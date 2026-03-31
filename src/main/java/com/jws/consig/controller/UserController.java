package com.jws.consig.controller;

import com.jws.consig.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/admin")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/consultores")
    public ResponseEntity<?> listarConsultores() {
        // Usamos HashMap manual porque o Map.of explode se houver valor nulo
        List<Map<String, Object>> lista = userRepository.findAll().stream()
            .map(user -> {
                Map<String, Object> map = new HashMap<>();
                map.put("id", user.getId());
                map.put("nome", user.getNome() != null ? user.getNome() : user.getEmail());
                return map;
            })
            .collect(Collectors.toList());
        return ResponseEntity.ok(lista);
    }
}
