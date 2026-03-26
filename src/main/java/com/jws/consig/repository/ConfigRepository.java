package com.jws.consig.repository;
import com.jws.consig.model.SystemConfig;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConfigRepository extends JpaRepository<SystemConfig, String> {
}
