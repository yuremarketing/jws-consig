package com.jws.consig.repository;

import com.jws.consig.model.Lead;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface LeadRepository extends JpaRepository<Lead, Long> {

    List<Lead> findByMargemGreaterThanEqualOrderByMargemDesc(BigDecimal margem);
    
    // ESTE É O MÉTODO QUE O MAVEN PRECISA ENCONTRAR:
    List<Lead> findByConsultorId(Long consultorId);

    @Modifying
    @Transactional
    @Query("UPDATE Lead l SET l.consultor.id = ?1, l.status = ?3 WHERE l.cpf = ?2 OR CAST(l.id AS string) = ?2")
    int distribuirLeads(Long consultorId, String identificador, String status, Double valorDaAcao);
}
