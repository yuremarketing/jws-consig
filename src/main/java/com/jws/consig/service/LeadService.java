package com.jws.consig.service;

import com.jws.consig.model.Lead;
import com.jws.consig.repository.LeadRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

@Service
public class LeadService {

    private final LeadRepository repository;

    public LeadService(LeadRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public String importarLeads(String path) {
        int novos = 0;
        int ignorados = 0;
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            br.readLine(); // Pula cabeçalho

            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");
                if (values.length >= 2) {
                    String nome = values[0].trim();
                    String cpf = values[1].trim();
                    
                    // Se o CPF já existe, ignoramos para não dar erro de Unique Key
                    if (repository.findByCpf(cpf).isPresent()) {
                        ignorados++;
                        continue;
                    }

                    Lead lead = new Lead();
                    lead.setNome(nome);
                    lead.setCpf(cpf);
                    if (values.length >= 3) {
                        try { lead.setMargem(Double.parseDouble(values[2].trim())); } 
                        catch (Exception e) { lead.setMargem(0.0); }
                    }
                    
                    repository.save(lead);
                    novos++;
                }
            }
            return "Sucesso! Novos: " + novos + " | Ignorados (já existiam): " + ignorados;
        } catch (Exception e) {
            return "Erro crítico: " + e.getMessage();
        }
    }
}
