#!/bin/bash

echo "====================================================="
echo "🔍 AUDITORIA: SCROLL INFINITO (V2)"
echo "====================================================="

# Tenta achar os arquivos não importa se você está na raiz ou dentro das pastas
LEAD_TABLE=$(find . -name "LeadTable.tsx" | head -n 1)
DASHBOARD=$(find . -name "Dashboard.tsx" | head -n 1)
CONTROLLER=$(find . -name "LeadController.java" | head -n 1)
SERVICE=$(find . -name "LeadService.java" | head -n 1)

echo -e "\n📂 [FRONT-END] - LeadTable.tsx:"
if [ -f "$LEAD_TABLE" ]; then
    echo "📍 Localizado em: $LEAD_TABLE"
    grep -E "new IntersectionObserver|ref={isLast \? lastElementRef : null}" "$LEAD_TABLE"
else
    echo "❌ LeadTable.tsx não encontrado."
fi

echo -e "\n📂 [FRONT-END] - Dashboard.tsx:"
if [ -f "$DASHBOARD" ]; then
    echo "📍 Localizado em: $DASHBOARD"
    grep -A 10 "carregarLeads = async" "$DASHBOARD" | grep -E "setLeads|\[\.\.\.prev"
else
    echo "❌ Dashboard.tsx não encontrado."
fi

echo -e "\n📂 [BACK-END] - Java (Controller/Service):"
if [ -f "$CONTROLLER" ]; then
    echo "📍 Controller: $CONTROLLER"
    grep -E "int page|int size" "$CONTROLLER"
fi
if [ -f "$SERVICE" ]; then
    echo "📍 Service: $SERVICE"
    grep "Page<Lead>" "$SERVICE"
else
    echo "❌ Arquivos Java não encontrados."
fi

echo -e "\n====================================================="
