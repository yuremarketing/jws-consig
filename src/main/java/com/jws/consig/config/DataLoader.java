package com.jws.consig.config;

import com.jws.consig.model.User;
import com.jws.consig.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataLoader implements CommandLineRunner {
    private final UserRepository repo;
    private final PasswordEncoder encoder;

    public DataLoader(UserRepository repo, PasswordEncoder encoder) {
        this.repo = repo;
        this.encoder = encoder;
    }

    @Override
    public void run(String... args) {
        repo.deleteAll(); // Limpamos para garantir que o novo padrão entre
        
        User admin = new User();
        admin.setName("Admin");
        admin.setEmail("admin@consig.com");
        admin.setPassword(encoder.encode("admin123"));
        admin.setRole("ROLE_ADMIN");
        repo.save(admin);

        User consultor = new User();
        consultor.setName("Consultor Sniper");
        consultor.setEmail("consultor@consig.com");
        consultor.setPassword(encoder.encode("senha123"));
        consultor.setRole("ROLE_CONSULTOR");
        repo.save(consultor);
        
        System.out.println("✅ ROLES ALINHADAS: ROLE_ADMIN e ROLE_CONSULTOR!");
    }
}
