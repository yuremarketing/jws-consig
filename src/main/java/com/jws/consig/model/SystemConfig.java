package com.jws.consig.model;
import jakarta.persistence.*;

@Entity
public class SystemConfig {
    @Id private String chave;
    private String valor;
    public SystemConfig() {}
    public SystemConfig(String chave, String valor) { this.chave = chave; this.valor = valor; }
    public String getChave() { return chave; }
    public String getValor() { return valor; }
    public void setValor(String valor) { this.valor = valor; }
}
