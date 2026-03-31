#!/bin/bash

# CORES PARA O TERMINAL
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== 🕵️ TESTE DE API ESTILO POSTMAN - CONSIG SNIPER ===${NC}"

# 1. PEGAR O TOKEN (Você pode colar o seu aqui ou o script tenta pegar o último usado)
# Se você tiver o token na mão, substitua abaixo. Se não, tente logar primeiro.
read -p "Cole seu Token JWT (sem o 'Bearer '): " TOKEN

URL_BASE="http://localhost:8080/api/admin/leads"

echo -e "\n${BLUE}[1/2] Testando GET /api/admin/leads (Página 0, Tamanho 5)${NC}"
# Faz a chamada e usa o python para formatar o JSON (bonitinho igual no Postman)
response=$(curl -s -H "Authorization: Bearer $TOKEN" "$URL_BASE?page=0&size=5")

if [[ $response == *"content"* ]]; then
    echo -e "${GREEN}✅ SUCESSO! O Java retornou dados.${NC}"
    echo "$response" | python3 -m json.tool || echo "$response"
else
    echo -e "${RED}❌ ERRO OU LISTA VAZIA!${NC}"
    echo "Resposta bruta: $response"
fi

echo -e "\n${BLUE}[2/2] Testando integridade do formato JSON...${NC}"
if echo "$response" | python3 -m json.tool > /dev/null 2>&1; then
    echo -e "${GREEN}✅ JSON Válido detectado.${NC}"
else
    echo -e "${RED}⚠️ ATENÇÃO: O Java não retornou um JSON válido. É isso que está quebrando o React!${NC}"
fi

echo -e "\n${BLUE}=== FIM DO TESTE ===${NC}"
