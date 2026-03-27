#!/bin/bash
echo "============================================================"
echo "📡 BUSCA PROFUNDA: API, CONTROLLERS E MODELS"
echo "============================================================"

# Localiza os arquivos independente do nome exato (Auth ou Login)
AUTH_FILE=$(find . -name "*Controller.java" | xargs grep -l "@PostMapping" | xargs grep -l "login" | head -n 1)
USER_FILE=$(find . -name "Usuario.java" -o -name "User.java" | head -n 1)

if [ -z "$AUTH_FILE" ]; then
    echo "❌ NENHUM CONTROLLER DE LOGIN ENCONTRADO!"
    echo "Dica: O Spring Security está tentando logar, mas você tem um @RestController de Login?"
else
    echo -e "\n[1] AUTH CONTROLLER ENCONTRADO EM: $AUTH_FILE"
    echo "------------------------------------------------------------"
    cat "$AUTH_FILE"
fi

if [ -z "$USER_FILE" ]; then
    echo -e "\n❌ MODEL DE USUÁRIO NÃO ENCONTRADO!"
else
    echo -e "\n[2] MODEL USUÁRIO ENCONTRADO EM: $USER_FILE"
    echo "------------------------------------------------------------"
    cat "$USER_FILE"
fi

echo -e "\n============================================================"
echo "🔍 MAPEAMENTO DE ROTAS REAIS (RequestMappings):"
echo "============================================================"
grep -r "@RequestMapping" . | grep "src/main/java"
grep -r "@PostMapping" . | grep "src/main/java"
