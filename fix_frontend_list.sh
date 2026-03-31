#!/bin/bash
echo "=== 🎨 CORRIGINDO RECEBIMENTO DE DADOS NO FRONTEND ==="

# O caminho do arquivo que o find localizou
FILE="../consig-sniper-web/src/pages/Dashboard.tsx"

# Usando o sed para trocar setLeads(data) por setLeads(data.content || data)
# Isso garante que se vier um Page (com .content) ele usa o conteúdo, 
# e se vier uma lista simples, ele usa a lista.
sed -i 's/setLeads(data);/setLeads(data.content || data);/g' "$FILE"

echo "✅ Dashboard.tsx atualizado com sucesso!"
echo "Dica: Verifique se o seu LeadTable.tsx espera uma array no prop 'leads'."
