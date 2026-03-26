package com.jws.consig.model;
import jakarta.persistence.*;

@Entity
@Table(name = "leads")
public class Lead {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String cpf;
    private String telefone;
    private String orgao;
    private Double margem;
    private String status;

    public Lead() {}
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    public String getOrgao() { return orgao; }
    public void setOrgao(String orgao) { this.orgao = orgao; }
    public Double getMargem() { return margem; }
    public void setMargem(Double margem) { this.margem = margem; }
}
