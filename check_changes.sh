#!/bin/bash

echo "====================================================="
echo "🔍 RELATÓRIO DE ALTERAÇÕES - CONSIG SNIPER"
echo "====================================================="

# 1. Back-end
echo -e "\n📂 [BACK-END] Alterações no Java:"
if [ -d "consig" ]; then
    cd consig
    git diff src/main/java/com/jws/consig/controller/AuthController.java \
             src/main/java/com/jws/consig/security/SecurityConfig.java \
             src/main/java/com/jws/consig/controller/LeadController.java
    cd ..
else
    echo "❌ Pasta 'consig' não encontrada."
fi

echo -e "\n-----------------------------------------------------"

# 2. Front-end
echo -e "\n📂 [FRONT-END] Alterações no React:"
if [ -d "consig-sniper-web" ]; then
    cd consig-sniper-web
    git diff src/components/leads/LeadTable.tsx
    cd ..
else
    echo "❌ Pasta 'consig-sniper-web' não encontrada."
fi

echo -e "\n====================================================="
echo "✅ FIM DO RELATÓRIO"
