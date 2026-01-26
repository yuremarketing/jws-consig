package com.jws.consig_sniper.config;

import com.jws.consig_sniper.model.User;
import com.jws.consig_sniper.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDatabase(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        return args -> {
            // Verifica se o Admin já existe
            if (userRepository.findByCpf("53910206115").isEmpty()) {
                
                User admin = User.builder()
                        .nome("Yuri Admin")
                        .cpf("53910206115")
                        .password(passwordEncoder.encode("123")) // AQUI ESTÁ A MÁGICA: CRIPTOGRAFA O 123
                        .role("ADMIN")
                        .isActive(true)
                        .isFirstLogin(false)
                        .build();
                
                userRepository.save(admin);
                System.out.println("✅ USUÁRIO ADMIN RECRIADO COM SUCESSO!");
                System.out.println("🔑 CPF: 53910206115");
                System.out.println("🔑 SENHA: 123");
            }
        };
    }
}
