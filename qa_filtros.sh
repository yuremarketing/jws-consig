#!/bin/bash

# ==========================================
# 🧪 SUÍTE DE TESTES QA SENIOR - FILTROS API
# ==========================================

TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbkBjb25zaWcuY29tIiwiaWF0IjoxNzc1MDkzNDk0LCJleHAiOjE3NzUxNzk4OTR9.H086l5qaiPAcE_sfiJ15tctcq2Kk5s7b7ZwFQLtJSS8"
BASE_URL="http://localhost:8080/admin/leads"

echo "================================================="
echo "🚀 INICIANDO BATERIA DE TESTES (FILTROS DE LEADS)"
echo "================================================="

run_test() {
    TEST_NAME=$1
    QUERY=$2
    
    echo -e "\n▶️ $TEST_NAME"
    echo "URL: $BASE_URL$QUERY"
    
    RESULT=$(curl -s -w "\nHTTP_CODE:%{http_code}" -H "Authorization: Bearer $TOKEN" "$BASE_URL$QUERY")
    
    HTTP_CODE=$(echo "$RESULT" | grep -o 'HTTP_CODE:[0-9]*' | cut -d':' -f2)
    JSON_BODY=$(echo "$RESULT" | sed 's/HTTP_CODE:.*//')
    
    if [ "$HTTP_CODE" == "401" ] || [ "$HTTP_CODE" == "403" ]; then
        echo "❌ FALHA: Acesso Negado (Token inválido ou expirado)."
    elif [ "$HTTP_CODE" == "200" ]; then
        TOTAL=$(echo "$JSON_BODY" | grep -o '"totalElements":[0-9]*' | awk -F':' '{print $2}')
        echo "✅ OK! Leads encontrados: $TOTAL"
    else
        echo "⚠️  ERRO $HTTP_CODE: Algo deu errado no back-end."
    fi
}

run_test "CENÁRIO 1: Buscar a base inteira (Sem filtros)" "?page=0&size=1"
run_test "CENÁRIO 2: Filtrar por órgão simples (INSS)" "?orgaos=INSS&page=0&size=1"
run_test "CENÁRIO 3: Filtrar por órgão composto (MINISTERIO DA CULTURA)" "?orgaos=MINISTERIO%20DA%20CULTURA&page=0&size=1"
run_test "CENÁRIO 4: Filtrar apenas por Margem (COM_MARGEM)" "?margem=COM_MARGEM&page=0&size=1"
run_test "CENÁRIO 5: Filtro Combinado (INSS + SEM_MARGEM)" "?orgaos=INSS&margem=SEM_MARGEM&page=0&size=1"
run_test "CENÁRIO 6: Teste de Stress (Órgão inexistente)" "?orgaos=NADA_A_VER_AQUI&page=0&size=1"

echo -e "\n================================================="
echo "🏁 TESTES FINALIZADOS"
echo "================================================="
