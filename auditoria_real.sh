#!/bin/bash
echo "============================================================"
echo "🔎 LOCALIZANDO ARQUIVOS DE CONFIGURAÇÃO..."
echo "============================================================"

# Busca dinâmica para não errar o caminho do pacote
SEC_FILE=$(find src -name "SecurityConfig.java" | head -n 1)
INIT_FILE=$(find src -name "DataInitializer.java" | head -n 1)

if [ -n "$SEC_FILE" ]; then
    echo -e "\n[1] CONFIGURAÇÃO DE SEGURANÇA ENCONTRADA EM: $SEC_FILE"
    echo "------------------------------------------------------------"
    cat "$SEC_FILE"
else
    echo -e "\n❌ ERRO: SecurityConfig.java não existe no disco!"
fi

if [ -n "$INIT_FILE" ]; then
    echo -e "\n[2] INICIALIZADOR DE DADOS ENCONTRADO EM: $INIT_FILE"
    echo "------------------------------------------------------------"
    cat "$INIT_FILE"
else
    echo -e "\n❌ ERRO: DataInitializer.java não existe no disco!"
fi

echo -e "\n============================================================"
echo "📊 DIAGNÓSTICO DE RIGOR (DOC OFICIAL SPRING 6.x)"
echo "============================================================"
if [ -n "$SEC_FILE" ]; then
    grep -q "HttpSecurity" "$SEC_FILE" && echo "✅ Usa HttpSecurity (Correto)"
    grep -q "filterChain" "$SEC_FILE" && echo "✅ Usa SecurityFilterChain (Padrão Bean - Correto)"
    grep -q "csrf" "$SEC_FILE" || echo "⚠️ AVISO: CSRF não mencionado (Pode dar erro no POST do React)"
    grep -q "cors" "$SEC_FILE" || echo "⚠️ AVISO: CORS não configurado (Vai dar erro no Axios)"
fi
