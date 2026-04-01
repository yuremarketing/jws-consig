package com.jws.consig.config;

import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class AdminPasswordReset implements CommandLineRunner {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminPasswordReset(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        userRepository.findByEmail("admin@consig.com").ifPresent(user -> {
            user.setPassword(passwordEncoder.encode("admin123"));
            user.setRole("ADMIN");
            userRepository.save(user);
            System.out.println("✅ [SUCESSO] Senha do Admin sincronizada com BCrypt!");
        });
    }
}
