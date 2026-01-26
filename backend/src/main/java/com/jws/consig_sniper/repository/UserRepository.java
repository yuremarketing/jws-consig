package com.jws.consig_sniper.repository;

import com.jws.consig_sniper.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByCpf(String cpf);
}
