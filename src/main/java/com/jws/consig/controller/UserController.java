package com.jws.consig.controller;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jws.consig.model.Empresa;
import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;

@RestController
@RequestMapping("/api/users")
public class UserController {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserController(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping
    @Transactional
    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN', 'ROLE_ADMIN_EMPRESA', 'ADMIN_EMPRESA')")
    public ResponseEntity<List<User>> listarTodos(
            @RequestParam(required = false) String nome, 
            @AuthenticationPrincipal User logado) {
        
        Long empresaId = (logado.getEmpresa() != null) ? logado.getEmpresa().getId() : null;

        if (empresaId != null) {
            if (nome != null && !nome.isBlank()) {
                return ResponseEntity.ok(userRepository.findByEmpresaIdAndNomeContainingIgnoreCase(empresaId, nome));
            }
            return ResponseEntity.ok(userRepository.findByEmpresaId(empresaId));
        }
        
        if (nome != null && !nome.isBlank()) {
            return ResponseEntity.ok(userRepository.findByNomeContainingIgnoreCase(nome));
        }
        return ResponseEntity.ok(userRepository.findAll());
    }

    @PostMapping
    @Transactional
    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN', 'ROLE_ADMIN_EMPRESA', 'ADMIN_EMPRESA')")
    public ResponseEntity<?> salvar(@RequestBody User newUser, @AuthenticationPrincipal User logado) {
        Long empresaId = (logado.getEmpresa() != null) ? logado.getEmpresa().getId() : null;

        if (userRepository.findByEmail(newUser.getEmail()).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("message", "E-mail já cadastrado"));
        }

        // 🛡️ RN-EMP-003: Uma empresa inativa não pode criar novos usuários
        if (empresaId != null && !logado.getEmpresa().isAtivo()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Empresa inativa não pode criar usuários"));
        }

        // 🛡️ BLINDAGEM: Se quem cria é um Gestor, o usuário novo fica PRESO na empresa dele
        if (empresaId != null) {
            Empresa empresa = new Empresa();
            empresa.setId(empresaId);
            newUser.setEmpresa(empresa);
            
            // 🛡️ RN-USR-005: Gestor só pode criar CONSULTOR. Não pode criar outro Admin!
            if (newUser.getRole() == null || newUser.getRole().toUpperCase().contains("ADMIN")) {
                newUser.setRole("CONSULTOR");
            }
        }

        newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
        newUser.setTrocaSenhaObrigatoria(true);
        newUser.setAtivo(true);
        userRepository.save(newUser);
        return ResponseEntity.ok(Map.of("message", "Usuário criado com sucesso!"));
    }

    @PutMapping("/{id}")
    @Transactional
    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN', 'ROLE_ADMIN_EMPRESA', 'ADMIN_EMPRESA')")
    public ResponseEntity<?> atualizar(@PathVariable long id, @RequestBody User dados, @AuthenticationPrincipal User logado) {
        Long empresaId = (logado.getEmpresa() != null) ? logado.getEmpresa().getId() : null;
        
        // 🛡️ BLINDAGEM: Tenta buscar o usuário. Se for Gestor, só acha se o ID e a Empresa baterem.
        var userOptional = (empresaId != null && empresaId > 0) 
            ? userRepository.findByIdAndEmpresaId(id, Objects.requireNonNull(empresaId)) 
            : userRepository.findById(id);

        return userOptional.map(user -> {
            // Verifica se o e-mail mudou e se o novo já existe em outro ID
            if (!user.getEmail().equals(dados.getEmail())) {
                if (userRepository.findByEmail(dados.getEmail()).isPresent()) {
                    return ResponseEntity.badRequest().body(Map.of("message", "E-mail já está em uso por outro usuário."));
                }
            }

            user.setNome(dados.getNome());
            user.setEmail(dados.getEmail());
            // Evita que o gestor mude o cargo de um consultor para admin
            if (dados.getRole() != null && empresaId == null) {
                user.setRole(dados.getRole());
            }
            userRepository.save(user);
            System.out.println("✅ Usuário ID " + id + " atualizado com sucesso no banco.");
            return ResponseEntity.ok(Map.of("message", "Usuário atualizado com sucesso!"));
        }).orElse(ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", "Acesso negado ou usuário de outra empresa.")));
    }

    @DeleteMapping("/{id}")
    @Transactional
    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN', 'ROLE_ADMIN_EMPRESA', 'ADMIN_EMPRESA')")
    public ResponseEntity<?> toggleStatus(@PathVariable long id, @AuthenticationPrincipal User logado) {
        Long empresaId = (logado.getEmpresa() != null) ? logado.getEmpresa().getId() : null;
        
        // 🛡️ BLINDAGEM: O Gestor não pode desativar alguém de outra empresa
        var userOptional = (empresaId != null && empresaId > 0) 
            ? userRepository.findByIdAndEmpresaId(id, Objects.requireNonNull(empresaId)) 
            : userRepository.findById(id);

        return userOptional.map(user -> {
            user.setAtivo(!user.isAtivo());
            userRepository.save(user);
            return ResponseEntity.ok(Map.of("message", "Status alterado com sucesso"));
        }).orElse(ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", "Acesso negado ou usuário de outra empresa.")));
    }

    // 🗑️ ATENDENDO ITEM 4: Exclusão real do usuário
    @DeleteMapping("/{id}/permanente")
    @Transactional
    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN', 'ROLE_ADMIN_EMPRESA', 'ADMIN_EMPRESA')")
    public ResponseEntity<?> excluirPermanente(@PathVariable long id, @AuthenticationPrincipal User logado) {
        Long empresaId = (logado.getEmpresa() != null) ? logado.getEmpresa().getId() : null;
        var userOptional = (empresaId != null && empresaId > 0) 
            ? userRepository.findByIdAndEmpresaId(id, Objects.requireNonNull(empresaId)) 
            : userRepository.findById(id);

        if (userOptional.isPresent()) {
            userRepository.deleteById(Objects.requireNonNull(id));
            return ResponseEntity.ok(Map.of("message", "Usuário removido permanentemente da base."));
        }
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", "Usuário não encontrado ou sem permissão."));
    }
}