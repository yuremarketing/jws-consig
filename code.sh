#!/bin/bash

echo "📂 Estrutura de Pastas e Arquivos (Consig-Sniper)"
echo "-----------------------------------------------"

# Tenta usar o comando 'tree', se não tiver, usa o 'find'
if command -v tree &> /dev/null
then
    tree -I 'node_modules|target|.git|.mvn|bin|obj' -L 4
else
    find . -maxdepth 4 -not -path '*/.*' -not -path './node_modules*' -not -path './target*' -not -path './.git*'
fi

echo -e "\n🔍 Verificando ramos (Branches) atuais:"
git branch -a

echo -e "\n📝 Último commit em cada pasta principal:"
for d in */; do
    if [ -d "$d/.git" ] || [ -d ".git" ]; then
        echo -e "📁 $d: $(git log -1 --format='%h - %s (%cr)' 2>/dev/null || echo 'Sem git nesta pasta')"
    fi
done
