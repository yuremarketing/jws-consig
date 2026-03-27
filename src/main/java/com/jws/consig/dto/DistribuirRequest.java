package com.jws.consig.dto;

import lombok.Data;

@Data
public class DistribuirRequest {
    private Long consultorId;
    private String uf;
    private String orgao;
    private Double margemMin;
}
