package com.jws.consig.config;

import com.jws.consig.model.Usuario;
import com.jws.consig.repository.UsuarioRepository;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    private final UsuarioRepository repository;
    public CustomUserDetailsService(UsuarioRepository repository) { this.repository = repository; }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Usuario usuario = repository.findByEmail(email)
            .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado: " + email));
        return new User(usuario.getEmail(), usuario.getPassword(), List.of(new SimpleGrantedAuthority(usuario.getRole())));
    }
}
