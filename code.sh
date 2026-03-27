#!/bin/bash

echo -e "\033[1;34m--- 🎯 TESTE DE FLUXO E2E: O CONSULTOR VÊ O LEAD? ---\033[0m"

# 1. Login e Tokens
ADMIN_TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d '{"email":"admin@consig.com", "password":"admin123"}' | grep -oP '(?<="token":")[^"]*')
CONSULTOR_TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d '{"email":"consultor@consig.com", "password":"senha123"}' | grep -oP '(?<="token":")[^"]*')

# 2. Admin Importa
echo "nome;cpf;margem;telefone;orgao
LEAD DO YURE;99988877766;4500.00;61912345678;INSS" > leads_final.csv
curl -s -X POST http://localhost:8080/api/admin/leads/import -H "Authorization: Bearer $ADMIN_TOKEN" -F "file=@leads_final.csv" > /dev/null

# 3. Admin Distribui para o Consultor (ID 2)
curl -s -X POST http://localhost:8080/api/admin/leads/assign -H "Authorization: Bearer $ADMIN_TOKEN" -H "Content-Type: application/json" -d '{"leadIds": [1], "consultorId": 2}' > /dev/null

echo -e "✅ Lead 'LEAD DO YURE' importado e entregue ao consultor."

# 4. A HORA DA VERDADE: O Consultor vê?
echo -e "\n\033[1;33m[CONSULTOR] Verificando meus leads:\033[0m"
curl -s -X GET http://localhost:8080/api/leads/meus-leads -H "Authorization: Bearer $CONSULTOR_TOKEN" | sed 's/}/}\n/g'

rm leads_final.csv
echo -e "\n\033[1;34m--- 🏁 FIM DO TESTE --- \033[0m"
