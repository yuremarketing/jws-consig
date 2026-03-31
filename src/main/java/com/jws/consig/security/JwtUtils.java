package com.jws.consig.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;
import java.security.Key;
import java.util.Date;

@Component
public class JwtUtils {
    // Chave secreta para assinar o token (mínimo 32 caracteres)
    private final String secret = "sua_chave_secreta_muito_longa_e_segura_consig_sniper_2026";
    private final Key key = Keys.hmacShaKeyFor(secret.getBytes());
    private final int jwtExpirationMs = 86400000; // O token vale por 24 horas

    // Cria o token a partir do e-mail do usuário
    public String generateToken(String email) {
        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date((new Date()).getTime() + jwtExpirationMs))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    // Lê o e-mail que está guardado dentro do token
    public String getEmailFromToken(String token) {
        return Jwts.parserBuilder().setSigningKey(key).build()
                .parseClaimsJws(token).getBody().getSubject();
    }

    // Verifica se o token não foi falsificado ou se não expirou
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
