#!/bin/bash

echo "====================================================="
echo "🔍 DIAGNÓSTICO: O MISTÉRIO DO UPLOAD"
echo "====================================================="

echo -e "\n📂 1. O que o LeadUpload está tentando chamar (Linhas 10 a 25):"
sed -n '10,25p' consig-sniper-web/src/components/leads/LeadUpload.tsx

echo -e "\n📂 2. Como o serviço está importado:"
grep "import" consig-sniper-web/src/components/leads/LeadUpload.tsx | grep "service"

echo -e "\n📂 3. Procurando a função importarCSV nos serviços:"
grep -A 5 "importarCSV" consig-sniper-web/src/services/leadService.ts || echo "❌ Função importarCSV NÃO existe no leadService.ts!"

echo -e "\n====================================================="
