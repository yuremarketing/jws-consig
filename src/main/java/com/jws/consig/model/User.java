package com.jws.consig.model;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    private String role;

    // --- NOVOS CAMPOS DA FASE 2 ---
    @Column(nullable = false)
    private boolean ativo = true;

    @Column(name = "troca_senha_obrigatoria", nullable = false)
    private boolean trocaSenhaObrigatoria = false;

    // --- GETTERS E SETTERS ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
    public boolean isTrocaSenhaObrigatoria() { return trocaSenhaObrigatoria; }
    public void setTrocaSenhaObrigatoria(boolean trocaSenhaObrigatoria) { this.trocaSenhaObrigatoria = trocaSenhaObrigatoria; }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        String formattedRole = (role != null && role.startsWith("ROLE_")) ? role : "ROLE_" + role;
        return List.of(new SimpleGrantedAuthority(formattedRole));
    }

    @Override
    public String getUsername() { return email; }

    @Override public boolean isAccountNonExpired() { return true; }
    @Override public boolean isAccountNonLocked() { return true; }
    @Override public boolean isCredentialsNonExpired() { return true; }
    
    // 👇 AGORA O SPRING SECURITY SABE SE O USUÁRIO ESTÁ ATIVO
    @Override public boolean isEnabled() { return ativo; }
}
