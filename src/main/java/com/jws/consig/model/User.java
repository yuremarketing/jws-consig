package com.jws.consig.model;
import jakarta.persistence.*;
import lombok.Data;

@Entity @Table(name = "users") @Data
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    private String password;
    private String role; // Ex: ROLE_ADMIN, ROLE_CONSULTOR
}
