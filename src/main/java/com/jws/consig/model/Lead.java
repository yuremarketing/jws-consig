package com.jws.consig.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "leads")
public class Lead {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(unique = true, nullable = false)
    private String cpf;

    @Column(name = "orgao", nullable = false)
    private String orgao;

    @Column(name = "estado", nullable = false, length = 2)
    private String estado;

    @Column(precision = 10, scale = 2)
    private BigDecimal margem; // Adicionando a margem que o LeadController pediu

    @Column(nullable = false)
    private String status = "Disponível";

    @ManyToOne
    @JoinColumn(name = "consultor_id")
    private User consultor;
}
