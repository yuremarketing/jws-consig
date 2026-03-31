package com.jws.consig.config;

import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Optional;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDatabase(UserRepository repository, PasswordEncoder passwordEncoder) {
        return args -> {
            String adminEmail = "admin@consig.com";
            Optional<User> existingAdmin = repository.findByEmail(adminEmail);

            if (existingAdmin.isEmpty()) {
                // CRIAÇÃO DO ZERO
                User admin = new User();
                admin.setNome("Administrador Sniper");
                admin.setEmail(adminEmail);
                admin.setPassword(passwordEncoder.encode("admin"));
                admin.setRole("ROLE_ADMIN");
                repository.save(admin);
                System.out.println("✨ Novo Usuário Admin criado com sucesso!");
            } else {
                // ATUALIZAÇÃO (Sincroniza o banco com as novas regras do Java)
                User admin = existingAdmin.get();
                boolean mudou = false;

                if (admin.getNome() == null || !admin.getNome().equals("Administrador Sniper")) {
                    admin.setNome("Administrador Sniper");
                    mudou = true;
                }
                
                if (!"ROLE_ADMIN".equals(admin.getRole())) {
                    admin.setRole("ROLE_ADMIN");
                    mudou = true;
                }

                if (mudou) {
                    repository.save(admin);
                    System.out.println("♻️ Dados do Admin sincronizados com sucesso!");
                }
            }
        };
    }
}
