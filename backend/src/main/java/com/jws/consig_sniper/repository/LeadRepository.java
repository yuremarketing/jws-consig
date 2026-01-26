package com.jws.consig_sniper.repository;

import com.jws.consig_sniper.model.Lead;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface LeadRepository extends JpaRepository<Lead, Long> {

    // Busca leads de um vendedor pelo CPF
    List<Lead> findByUserCpf(String cpf);

    // SQL Nativo para pegar X leads livres
    @Query(value = "SELECT * FROM leads WHERE status = :status AND user_id IS NULL LIMIT :quantity", nativeQuery = true)
    List<Lead> findTopNByStatusAndUserIsNull(@Param("status") String status, @Param("quantity") int quantity);
}