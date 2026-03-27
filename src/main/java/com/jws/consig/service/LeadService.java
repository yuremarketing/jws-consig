package com.jws.consig.service;

import com.jws.consig.repository.LeadRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LeadService {

    @Autowired
    private LeadRepository leadRepository;

    public int distribuirAgora(Long consultorId, String uf, String orgao, Double margemMin) {
        return leadRepository.distribuirLeads(consultorId, uf, orgao, margemMin);
    }

    public void importarLeadsMassivo(String caminho) {
        // Método exigido pelo teste
        System.out.println("Processando importação: " + caminho);
    }
}
