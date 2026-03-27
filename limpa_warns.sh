#!/bin/bash
ARQUIVO="src/main/resources/application.properties"

if [ -f "$ARQUIVO" ]; then
    # 1. Apaga a linha do dialeto (Resolve o aviso do H2)
    sed -i '/hibernate.dialect/d' "$ARQUIVO"

    # 2. Garante que o open-in-view está desligado (Resolve o aviso do JPA)
    sed -i '/spring.jpa.open-in-view/d' "$ARQUIVO"
    echo "spring.jpa.open-in-view=false" >> "$ARQUIVO"

    echo "--- ✨ WARNS RESOLVIDOS NO application.properties! ---"
else
    echo "❌ Arquivo application.properties não encontrado."
fi
