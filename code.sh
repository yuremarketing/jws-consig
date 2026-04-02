cat << 'EOF' > mapear_backend.sh
#!/bin/bash

# Caminho absoluto para evitar erros de pasta
BASE_DIR="$HOME/Dev/consig-sniper-project/consig/src/main/java/com/jws/consig"

echo "======================================================"
echo "          RAIO-X DO BACK-END E BANCO DE DADOS         "
echo "======================================================"

echo -e "\n\n>>>>>>>> 1. LeadController.java (A Porta de Entrada) <<<<<<<<"
cat "$BASE_DIR/controller/LeadController.java" 2>/dev/null || echo "Arquivo não encontrado."

echo -e "\n\n>>>>>>>> 2. LeadService.java (A Regra de Negócio) <<<<<<<<"
cat "$BASE_DIR/service/LeadService.java" 2>/dev/null || echo "Arquivo não encontrado."

echo -e "\n\n>>>>>>>> 3. LeadRepository.java (A Busca no Banco) <<<<<<<<"
cat "$BASE_DIR/repository/LeadRepository.java" 2>/dev/null || echo "Arquivo não encontrado."

echo -e "\n\n>>>>>>>> 4. Lead.java (A Tabela do Banco) <<<<<<<<"
cat "$BASE_DIR/model/Lead.java" 2>/dev/null || echo "Arquivo não encontrado."

echo -e "\n======================================================"
EOF

chmod +x mapear_backend.sh
./mapear_backend.sh
