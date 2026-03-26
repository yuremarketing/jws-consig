package com.jws.consig.config;

import com.jws.consig.model.Usuario;
import com.jws.consig.repository.UsuarioRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UsuarioRepository repository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UsuarioRepository repository, PasswordEncoder passwordEncoder) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        String email = "admin@consig.com";
        repository.findByEmail(email).ifPresentOrElse(user -> {
            user.setPassword(passwordEncoder.encode("admin123"));
            repository.save(user);
            System.out.println("\n✅ [REPARO] Senha do admin resetada com sucesso pelo Framework!");
        }, () -> {
            Usuario admin = new Usuario();
            admin.setName("Administrador");
            admin.setEmail(email);
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRole("ROLE_ADMIN");
            repository.save(admin);
            System.out.println("\n✅ [REPARO] Admin não existia. Criado agora do zero!");
        });
    }
}
