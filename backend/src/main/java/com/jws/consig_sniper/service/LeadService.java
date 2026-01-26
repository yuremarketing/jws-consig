package com.jws.consig_sniper.service;

import com.jws.consig_sniper.model.Lead;
import com.jws.consig_sniper.model.User;
import com.jws.consig_sniper.repository.LeadRepository;
import com.jws.consig_sniper.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class LeadService {

    private final LeadRepository leadRepository;
    private final UserRepository userRepository;

    public LeadService(LeadRepository leadRepository, UserRepository userRepository) {
        this.leadRepository = leadRepository;
        this.userRepository = userRepository;
    }

    // Método para o vendedor ver os seus leads
    public List<Lead> getMyLeads(String userCpf) {
        return leadRepository.findByUserCpf(userCpf);
    }

    // Método para IMPORTAR CSV
    public int importLeads(MultipartFile file) {
        List<Lead> leads = new ArrayList<>();
        int count = 0;

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            boolean firstLine = true;

            while ((line = reader.readLine()) != null) {
                if (firstLine) { firstLine = false; continue; } // Pula cabeçalho

                String[] data = line.split(";");
                if (data.length >= 4) {
                    Lead lead = new Lead();
                    lead.setNome(data[0].trim());
                    lead.setCpf(data[1].trim()); // Usa setCpf (Corrigido)
                    lead.setTelefone(data[2].trim());

                    String margemStr = data[3].trim().replace(",", ".");
                    lead.setMargem(Double.parseDouble(margemStr));

                    lead.setStatus("NOVO");
                    leads.add(lead);
                    count++;
                }
            }
            leadRepository.saveAll(leads);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao processar CSV: " + e.getMessage());
        }
        return count;
    }

    // Método para DISTRIBUIR LEADS
    public int distributeLeads(UUID userId, int quantity) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Vendedor não encontrado"));

        // Chama o método que criamos no Passo 1
        List<Lead> leadsDisponiveis = leadRepository.findTopNByStatusAndUserIsNull("NOVO", quantity);

        if (leadsDisponiveis.isEmpty()) {
            throw new RuntimeException("Não há leads livres suficientes.");
        }

        for (Lead lead : leadsDisponiveis) {
            lead.setUser(user);
            lead.setStatus("DISTRIBUIDO");
        }

        leadRepository.saveAll(leadsDisponiveis);
        return leadsDisponiveis.size();
    }
}