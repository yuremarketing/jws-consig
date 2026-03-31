package com.jws.consig.repository.specification;

import com.jws.consig.model.Lead;
import org.springframework.data.jpa.domain.Specification;

public class LeadSpecifications {

    public static Specification<Lead> nomeContem(String nome) {
        return (root, query, cb) -> nome == null || nome.trim().isEmpty()
                ? cb.conjunction()
                : cb.like(cb.lower(root.get("nome")), "%" + nome.trim().toLowerCase() + "%");
    }

    public static Specification<Lead> cpfIgual(String cpf) {
        return (root, query, cb) -> cpf == null || cpf.trim().isEmpty()
                ? cb.conjunction()
                : cb.equal(root.get("cpf"), cpf.trim());
    }

    public static Specification<Lead> isOrgao(String orgao) {
        return (root, query, cb) -> orgao == null || orgao.trim().isEmpty() || orgao.equalsIgnoreCase("TODOS")
                ? cb.conjunction()
                : cb.equal(cb.upper(root.get("orgao")), orgao.trim().toUpperCase());
    }

    public static Specification<Lead> isEstado(String estado) {
        return (root, query, cb) -> estado == null || estado.trim().isEmpty() || estado.equalsIgnoreCase("TODOS")
                ? cb.conjunction()
                : cb.equal(cb.upper(root.get("estado")), estado.trim().toUpperCase());
    }
}
