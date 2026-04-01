#!/bin/bash

echo "====================================================="
echo "📦 VERSIONANDO: FILTROS DINÂMICOS E BANCO REAL"
echo "====================================================="

# Localiza onde está o Git e entra na pasta
if [ -d ".git" ]; then
    ROOT="."
elif [ -d "consig/.git" ]; then
    ROOT="consig"
else
    ROOT="consig-sniper-web"
fi

cd $ROOT

# Adiciona as mudanças
git add .

# Commit com a descrição técnica
git commit -m "feat: implementa busca dinâmica de órgãos via DISTINCT query" -m "- Back-end: Adiciona findDistinctOrgaos no LeadRepository para ler dados reais.
- Back-end: Remove lista de órgãos 'hardcoded' e limpa duplicidade de GetMapping.
- Front-end: Garante que o componente de filtro carregue os dados dinâmicos da API.
- Estabilidade: Fix de erro de compilação no LeadController."

# Sobe para o GitHub
git push origin main

echo -e "\n====================================================="
echo "🎯 RESUMO DO VERSIONAMENTO:"
echo -e "✅ VERSÃO ESTÁVEL: git reset --hard $(git log -1 --format='%h')"
echo "====================================================="
cd - > /dev/null
