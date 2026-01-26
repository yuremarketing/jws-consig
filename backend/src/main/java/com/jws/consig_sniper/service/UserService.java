package com.jws.consig_sniper.service;

import com.jws.consig_sniper.model.User;
import com.jws.consig_sniper.repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> listAll() {
        return userRepository.findAll();
    }

    public User createUser(User data) {
        if (userRepository.findByCpf(data.getCpf()).isPresent()) {
            throw new IllegalArgumentException("CPF já cadastrado");
        }

        String encryptedPassword = new BCryptPasswordEncoder().encode(data.getPassword());
        
        User newUser = User.builder()
                .nome(data.getNome())
                .cpf(data.getCpf())
                .password(encryptedPassword)
                .role(data.getRole() != null ? data.getRole() : "USER")
                .isActive(true)
                .isFirstLogin(true)
                .build();

        return userRepository.save(newUser);
    }

    public void toggleStatus(UUID id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        
        boolean statusAtual = user.getIsActive() != null ? user.getIsActive() : false;
        user.setIsActive(!statusAtual);
        userRepository.save(user);
    }

    public void softDelete(UUID id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        
        user.setIsActive(false);
        userRepository.save(user);
    }

    // --- O MÉTODO QUE FALTOU PARA O LOADER ---
    public void createAdmin(String nome, String cpf, String password) {
        if (userRepository.findByCpf(cpf).isEmpty()) {
            String encryptedPassword = new BCryptPasswordEncoder().encode(password);
            User admin = User.builder()
                    .nome(nome)
                    .cpf(cpf)
                    .password(encryptedPassword)
                    .role("ADMIN")
                    .isActive(true)
                    .isFirstLogin(false)
                    .build();
            userRepository.save(admin);
            System.out.println("✅ Admin criado/verificado pelo Service!");
        }
    }
}
