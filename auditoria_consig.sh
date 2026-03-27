#!/bin/bash
echo "===================================================="
echo "🔍 RELATÓRIO DE ESTRUTURA E LÓGICA - CONSIG SNIPER"
echo "===================================================="

echo -e "\n📂 1. ÁRVORE DE DIRETÓRIOS (src/main/java):"
find src/main/java -maxdepth 10 -not -path '*/.*'

echo -e "\n📄 2. CONTEÚDO DO AUTHCONTROLLER:"
find src/main/java -name "AuthController.java" -exec cat {} \;

echo -e "\n📄 3. CONTEÚDO DOS DTOS (REQUEST/RESPONSE):"
find src/main/java -name "*Request.java" -o -name "*DTO.java" -exec echo "--- Arquivo: {} ---" \; -exec cat {} \;

echo -e "\n📄 4. CONFIGURAÇÃO DE SEGURANÇA (SecurityConfig):"
find src/main/java -name "SecurityConfig.java" -exec cat {} \;

echo -e "\n📄 5. FILTRO JWT (JwtAuthenticationFilter):"
find src/main/java -name "JwtAuthenticationFilter.java" -exec cat {} \;

echo -e "\n===================================================="
echo "✅ FIM DA AUDITORIA"
