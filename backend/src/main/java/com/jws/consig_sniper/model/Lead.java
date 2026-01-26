package com.jws.consig_sniper.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "leads")
@Data // O Lombok cria os Getters e Setters aqui (resolve o erro)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Lead {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;
    
    // --- CAMPOS QUE FALTAVAM ---
    private String cpf;
    private String telefone;
    private Double margem;
    private String status; // Ex: "NOVO", "DISTRIBUIDO", "EM_ATENDIMENTO"

    // --- RELACIONAMENTO (Dono do Lead) ---
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
