package com.jws.consig.repository;

import com.jws.consig.model.Lead;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface LeadRepository extends JpaRepository<Lead, Long> {
    
    List<Lead> findByMargemGreaterThanEqualOrderByMargemDesc(BigDecimal margem);

    // Adicionado para satisfazer o LeadServiceTest.java:26
    Optional<Lead> findByCpf(String cpf);

    @Modifying
    @Transactional
    @Query("UPDATE Lead l SET l.consultorId = ?1, l.status = ?3 WHERE l.cpf = ?2 OR CAST(l.id AS string) = ?2")
    int distribuirLeads(Long consultorId, String leadIdentifier, String status, Double margem);
}
