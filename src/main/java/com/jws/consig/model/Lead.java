package com.jws.consig.model;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;

@Entity
@Table(name = "leads")
@Data
public class Lead {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String nome;
    private String cpf;
    private String telefone;
    private BigDecimal margem;
    private String orgao;
    private String status; // Necessário para o ConsultorLeadController
    private Long consultorId; // Necessário para a distribuição
}
