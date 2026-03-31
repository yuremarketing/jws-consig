#!/bin/bash

echo "=== 🛡️ INICIANDO DIAGNÓSTICO PROFISSIONAL (QA) ==="

# 1. Validar Banco de Dados
echo -e "\n[1/4] Verificando estrutura do Banco..."
docker exec consig-sniper-db-oficial psql -U postgres -d postgres -c "\d leads" | grep -E "cpf|nome|orgao|margem|estado"
if [ $? -eq 0 ]; then echo "✅ Banco: Colunas OK"; else echo "❌ Banco: Erro na estrutura"; fi

# 2. Criar CSV de Teste Ultra-Seguro (Padrão que o código espera agora)
echo -e "\n[2/4] Criando massa de dados de teste (qa_test.csv)..."
printf "cpf,nome,orgao,margem,estado\n11122233344,QA Test,INSS,500.00,SP" > qa_test.csv
echo "✅ Massa de dados criada."

# 3. Testar Endpoint via CURL (Isolando o Frontend)
# Pegue o token do log ou substitua aqui se necessário
TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbkBjb25zaWcuY29tIiwiaWF0IjoxNzc0OTE2NzI5LCJleHAiOjE3NzUwMDMxMjl9.zNXOcWZcDvIRviixFwAt5QIwgV-lo3yNAWcR-cgUQHg"

echo -e "\n[3/4] Testando comunicação direta com o Backend (Bypassing Frontend)..."
RESPONSE=$(curl -s -w "%{http_code}" -o response.txt -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@qa_test.csv" \
  http://localhost:8080/api/admin/leads/importar)

HTTP_STATUS=${RESPONSE: -3}

if [ "$HTTP_STATUS" == "200" ]; then
    echo "✅ SUCESSO: O Backend aceitou o arquivo direto via cURL!"
    echo "Dica: Se via cURL funciona e via Browser não, o problema é no Axios/Frontend."
else
    echo "❌ FALHA: Backend retornou HTTP $HTTP_STATUS"
    echo "Erro Real do Java:"
    cat response.txt
fi

# 4. Verificação de Logs Ativos
echo -e "\n[4/4] Últimas 5 linhas de erro do Java:"
tail -n 5 src/main/resources/application.log 2>/dev/null || echo "Log não encontrado em src/main/resources. Verifique o terminal do Spring."

echo -e "\n=== 🏁 DIAGNÓSTICO CONCLUÍDO ==="
