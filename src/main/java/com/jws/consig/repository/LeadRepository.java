package com.jws.consig.repository;

import com.jws.consig.model.Lead;
import com.jws.consig.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface LeadRepository extends JpaRepository<Lead, Long> {
    Optional<Lead> findByCpf(String cpf);
    Page<Lead> findByConsultor(User consultor, Pageable pageable);
    List<Lead> findByConsultorId(Long consultorId);

    @Query("SELECT l FROM Lead l WHERE " +
           "(:orgaos IS NULL OR l.orgao IN :orgaos) AND " +
           "(:minMargem IS NULL OR l.margem >= :minMargem) AND " +
           "(:maxMargem IS NULL OR l.margem <= :maxMargem)")
    Page<Lead> findWithFilters(@Param("orgaos") List<String> orgaos, 
                               @Param("minMargem") BigDecimal minMargem, 
                               @Param("maxMargem") BigDecimal maxMargem, 
                               Pageable pageable);

    // Traz apenas os órgãos únicos que realmente existem no banco
    @Query("SELECT DISTINCT l.orgao FROM Lead l WHERE l.orgao IS NOT NULL AND TRIM(l.orgao) != ''")
    List<String> findDistinctOrgaos();
}
