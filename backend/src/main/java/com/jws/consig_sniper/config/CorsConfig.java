package com.jws.consig_sniper.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        
        // 1. Permite credenciais (token, cookies)
        config.setAllowCredentials(true);
        
        // 2. Define EXATAMENTE quem pode acessar (Frontend)
        config.setAllowedOrigins(List.of("http://localhost:5173"));
        
        // 3. Libera todos os cabeçalhos (Authorization, Content-Type, etc)
        config.setAllowedHeaders(List.of("*"));
        
        // 4. Libera todos os verbos HTTP
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        
        // 5. Aplica a regra para TODAS as rotas
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}
