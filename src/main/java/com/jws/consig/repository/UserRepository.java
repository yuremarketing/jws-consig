package com.jws.consig.repository;

import com.jws.consig.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    // Essencial para o login e para a segurança JWT
    Optional<User> findByEmail(String email);
}
