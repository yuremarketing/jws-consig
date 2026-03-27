#!/bin/bash
echo "--- LOCALIZAÇÃO ATUAL: $(pwd) ---"
echo -e "\n📂 ESTRUTURA ENCONTRADA:"
find src/main/java -maxdepth 10

echo -e "\n📄 CONTEÚDO DO LOGIN REQUEST (O culpado do null):"
find src/main/java -name "*Request.java" -exec cat {} \;

echo -e "\n📄 CONTEÚDO DO AUTH CONTROLLER:"
find src/main/java -name "AuthController.java" -exec cat {} \;
