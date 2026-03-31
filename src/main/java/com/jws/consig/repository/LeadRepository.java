package com.jws.consig.repository;

import com.jws.consig.model.Lead;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface LeadRepository extends JpaRepository<Lead, Long>, JpaSpecificationExecutor<Lead> {
    Optional<Lead> findByCpf(String cpf);
    List<Lead> findByMargemGreaterThanEqualOrderByMargemDesc(BigDecimal margem);
    List<Lead> findByConsultorId(Long consultorId);
}
