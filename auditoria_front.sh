#!/bin/bash
echo "============================================================"
echo "🎯 BUSCANDO CONFIGURAÇÕES DE API NO FRONT-END (VITE/REACT)"
echo "============================================================"

# 1. Procura por arquivos de configuração de API ou Contexto de Auth
FRONT_DIR=$(find . -maxdepth 2 -type d -name "frontend" -o -name "client" -o -name "consig-front" | head -n 1)

if [ -z "$FRONT_DIR" ]; then
    # Se não achar pastas óbvias, procura no src do React
    SEARCH_PATH="."
else
    SEARCH_PATH="$FRONT_DIR"
fi

echo "🔍 Vasculhando em: $SEARCH_PATH"

# 2. Busca pela URL de login no Axios ou Fetch
echo -e "\n[1] URLs de Login encontradas no Front:"
grep -rE "post\(|url:|fetch\(" "$SEARCH_PATH" | grep -i "login" --color=always

# 3. Busca pela BaseURL do Axios
echo -e "\n[2] BaseURLs configuradas (Vite/Axios):"
grep -rE "baseURL|VITE_API_URL" "$SEARCH_PATH" --color=always

echo -e "\n============================================================"
echo "✅ Fim da varredura no Front."
