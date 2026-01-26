package com.jws.consig_sniper.config;

import com.jws.consig_sniper.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class InitialDataLoader implements CommandLineRunner {

    @Autowired
    private UserService userService;

    @Override
    public void run(String... args) throws Exception {
        // Tenta criar o ADMIN padrão. Se já existir, o Service ignora.
        userService.createAdmin(
            "Yuri Admin", 
            "00000000000", 
            "admin123"
        );
        System.out.println("✅ Verificação de Inicialização: Usuário ADM verificado/criado.");
    }
}
