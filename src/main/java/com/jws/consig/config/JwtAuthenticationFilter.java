package com.jws.consig.config;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;
import java.util.List;

public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final JwtService jwtService;
    public JwtAuthenticationFilter(JwtService jwtService) { this.jwtService = jwtService; }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String header = request.getHeader("Authorization");
        System.out.println("\n>>> [FILTER] Requisição disparada para: " + request.getRequestURI());

        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
            System.out.println(">>> [FILTER] Token detectado. Iniciando validação...");
            
            if (jwtService.isTokenValid(token)) {
                Claims claims = jwtService.extractAllClaims(token);
                String role = claims.get("role", String.class);
                System.out.println(">>> [FILTER] SUCESSO! Token válido. Role extraída: " + role);
                
                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                        claims.getSubject(), null, List.of(new SimpleGrantedAuthority(role))
                );
                SecurityContextHolder.getContext().setAuthentication(auth);
                System.out.println(">>> [FILTER] Crachá gerado e acesso liberado no SecurityContext.");
            } else {
                System.out.println(">>> [FILTER] ERRO: O Token foi rejeitado pelo JwtService.");
            }
        } else {
            System.out.println(">>> [FILTER] AVISO: Nenhum cabeçalho 'Bearer' válido encontrado.");
        }
        filterChain.doFilter(request, response);
    }
}
