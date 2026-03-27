#!/bin/bash
echo "============================================================"
echo "🕵️ RASTREIO DE FLUXO: POR ONDE O DADO PASSA?"
echo "============================================================"

# 1. TESTE DE SAÍDA (FRONT-END)
echo -e "\n[CAMADA 1] Verificando nomes das chaves no Front-end:"
LOGIN_FILE=$(find consig-sniper-web/src -name "AuthContext.jsx" -o -name "Login.jsx" | head -n 1)
grep -E "email|password|credentials" "$LOGIN_FILE" | head -n 10

# 2. TESTE DE TRANSPORTE (CURL - O TESTE DEFINITIVO)
echo -e "\n[CAMADA 2] Testando se o Back-end aceita JSON via Terminal (Simulando Axios):"
echo "Enviando: {\"email\":\"admin@consig.com\", \"password\":\"admin123\"}"
curl -i -X POST http://localhost:8080/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"admin@consig.com", "password":"admin123"}'

# 3. TESTE DE ENTRADA (BACK-END)
echo -e "\n[CAMADA 3] Verificando anotação @RequestBody no Controller:"
find consig -name "AuthController.java" -exec grep -C 2 "@PostMapping" {} \;

echo -e "\n============================================================"
