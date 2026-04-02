#!/bin/bash
UI_FILE="consig-sniper-web/src/components/admin/UserManagement.tsx"

# Ajusta o botão para alternar entre Desativar e Reativar
sed -i 's/{u.ativo ? "Desativar" : "Desativar"}/{u.ativo ? "Desativar" : "Reativar"}/g' $UI_FILE
# (Se o sed falhar por causa da formatação anterior, vamos usar uma substituição mais bruta)
sed -i 's/style={{ color: "#ff9800",/style={{ color: u.ativo ? "#ff9800" : "#4caf50",/g' $UI_FILE

echo "✅ UI: Botões de ação agora alternam entre Desativar e Reativar."
