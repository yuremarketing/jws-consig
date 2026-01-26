package com.jws.consig_sniper.config;

import com.jws.consig_sniper.model.Lead;
import com.jws.consig_sniper.repository.LeadRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Configuration
public class DataSeeder implements CommandLineRunner {

    private final LeadRepository leadRepository;

    public DataSeeder(LeadRepository leadRepository) {
        this.leadRepository = leadRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        // Só popula se o banco estiver vazio (para não duplicar toda vez que reinicia)
        if (leadRepository.count() == 0) {
            System.out.println("🌱 Banco de Leads vazio. Iniciando Seeder...");
            
            List<Lead> fakeLeads = new ArrayList<>();
            String[] nomes = {"Carlos", "Ana", "Marcos", "Julia", "Roberto", "Fernanda", "Lucas", "Beatriz", "Pedro", "Larissa"};
            String[] sobrenomes = {"Silva", "Santos", "Oliveira", "Souza", "Lima", "Pereira", "Ferreira", "Costa", "Rodrigues", "Almeida"};
            
            Random random = new Random();

            for (int i = 0; i < 50; i++) {
                String nomeCompleto = nomes[random.nextInt(nomes.length)] + " " + sobrenomes[random.nextInt(sobrenomes.length)];
                
                // Gera CPF fake (apenas números)
                String cpf = String.format("%011d", random.nextLong(99999999999L));
                
                // Gera Telefone fake
                String telefone = "119" + String.format("%08d", random.nextInt(99999999));
                
                // Margem entre 100 e 2000 reais
                double margem = 100 + (1900 * random.nextDouble());

                Lead lead = new Lead();
                lead.setNome(nomeCompleto);
                lead.setCpf(cpf);
                lead.setTelefone(telefone);
                lead.setMargem(Math.round(margem * 100.0) / 100.0); // Arredonda 2 casas
                lead.setStatus("NOVO"); // Importante: Nasce como NOVO e SEM DONO (null)
                
                fakeLeads.add(lead);
            }

            leadRepository.saveAll(fakeLeads);
            System.out.println("✅ 50 Leads Fakes criados com sucesso!");
        }
    }
}
