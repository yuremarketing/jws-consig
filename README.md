#!/bin/bash

# Configurações do Repositório
REPO_URL="https://github.com/yuremarketing/jws-consig.git"

echo "🚀 [GIT SYNC] - Iniciando upload da versão Elite v6.1..."

# 1. Garante que estamos em um repositório Git
if [ ! -d ".git" ]; then
    echo "📦 Inicializando novo repositório local..."
    git init
fi

# 2. Configura o endereço remoto (remove se já existir para evitar erro)
git remote remove origin 2>/dev/null
git remote add origin $REPO_URL

# 3. Prepara os arquivos
echo "📂 Adicionando arquivos (incluindo README e Docker)..."
git add .

# 4. Cria o Commit
echo "💾 Criando commit de upgrade..."
git commit -m "feat: upgrade total Consig-Sniper v6.1 Elite Edition"

# 5. Define a branch principal como main
git branch -M main

# 6. Push forçado para limpar o lixo antigo do repo
echo "📤 Enviando para o GitHub (Force Push)..."
git push -u origin main --force

echo "✅ [MISSÃO CUMPRIDA] - Seu GitHub foi atualizado com sucesso!"
echo "🔗 Confira em: $REPO_URL"
