package com.jws.consig.model;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.math.BigDecimal;

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
    private BigDecimal margem;

    @Column(nullable = false)
    private String status = "Disponível";

    @ManyToOne
    @JoinColumn(name = "consultor_id")
    private User consultor;

    // --- GETTERS E SETTERS EXPLÍCITOS ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    public String getOrgao() { return orgao; }
    public void setOrgao(String orgao) { this.orgao = orgao; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public BigDecimal getMargem() { return margem; }
    public void setMargem(BigDecimal margem) { this.margem = margem; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public User getConsultor() { return consultor; }
    public void setConsultor(User consultor) { this.consultor = consultor; }
}
