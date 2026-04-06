#!/bin/bash

echo "🛑 Iniciando desligamento seguro do Ecossistema Sniper..."

# 1. Para e remove os containers, mas MANTÉM os volumes (dados do Postgres)
docker-compose down

echo "🧹 Limpando cache de rede do Docker..."
docker network prune -f

echo "✅ Docker desligado com sucesso. Seus dados estão salvos nos volumes."
