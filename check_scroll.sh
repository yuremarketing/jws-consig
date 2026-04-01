#!/bin/bash

echo "====================================================="
echo "🔍 AUDITORIA: SCROLL INFINITO (CONSIG SNIPER)"
echo "====================================================="

# 1. Front-end: Verificando o Sensor (Intersection Observer)
echo -e "\n📂 [FRONT-END] - Sensor de Rolagem (LeadTable.tsx):"
if [ -f "consig-sniper-web/src/components/leads/LeadTable.tsx" ]; then
    grep -A 10 "new IntersectionObserver" consig-sniper-web/src/components/leads/LeadTable.tsx
    echo -e "\n--- Verificando anexo do sensor na última linha ---"
    grep "ref={isLast ? lastElementRef : null}" consig-sniper-web/src/components/leads/LeadTable.tsx
else
    echo "❌ Arquivo LeadTable.tsx não encontrado."
fi

# 2. Front-end: Verificando a Lógica de Acúmulo (Dashboard.tsx)
echo -e "\n📂 [FRONT-END] - Função de Carregar Mais (Dashboard.tsx):"
if [ -f "consig-sniper-web/src/pages/Dashboard.tsx" ]; then
    grep -A 15 "carregarLeads = async" consig-sniper-web/src/pages/Dashboard.tsx
else
    echo "❌ Arquivo Dashboard.tsx não encontrado."
fi

# 3. Back-end: Verificando se o Java aceita Pageable
echo -e "\n📂 [BACK-END] - Paging no Java (LeadController/Service):"
if [ -d "consig" ]; then
    echo "--- LeadController (Parametros de página) ---"
    grep -E "int page|int size" consig/src/main/java/com/jws/consig/controller/LeadController.java
    echo -e "\n--- LeadService (Retorno de Page<Lead>) ---"
    grep "Page<Lead>" consig/src/main/java/com/jws/consig/service/LeadService.java
else
    echo "❌ Pasta 'consig' não encontrada."
fi

echo -e "\n====================================================="
echo "✅ FIM DA AUDITORIA"
