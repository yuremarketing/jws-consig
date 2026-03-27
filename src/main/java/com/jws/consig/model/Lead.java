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
    private BigDecimal margem;
    private String telefone;
    private String orgao;
    private String status = "DISPONIVEL";

    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private User consultor;
}
