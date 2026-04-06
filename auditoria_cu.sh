#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  CONSIG-SNIPER · AUDITORIA DE CASOS DE USO v1.0                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

BACK="/home/mark/Dev/consig-sniper-project/consig"
FRONT="/home/mark/Dev/consig-sniper-project/consig-sniper-web/src"
REPORT="$HOME/auditoria_cu_$(date +%Y%m%d_%H%M%S).txt"

GREEN='\033[1;32m'; RED='\033[1;31m'; YELLOW='\033[1;33m'
CYAN='\033[1;36m'; MAGENTA='\033[1;35m'; BOLD='\033[1m'; RESET='\033[0m'

OK=0; PARCIAL=0; FALTANDO=0

log()     { echo -e "$1" | tee -a "$REPORT"; }
sep()     { log "${CYAN}$(printf '─%.0s' {1..78})${RESET}"; }
dsep()    { log "${CYAN}$(printf '═%.0s' {1..78})${RESET}"; }
title()   { dsep; log "${BOLD}${MAGENTA}  $1${RESET}"; dsep; }
ok()      { log "  ${GREEN}✔ IMPLEMENTADO${RESET}     · $1"; ((OK++)); }
parcial() { log "  ${YELLOW}⚡ PARCIAL${RESET}         · $1"; ((PARCIAL++)); }
falta()   { log "  ${RED}✘ NAO IMPLEMENTADO${RESET} · $1"; ((FALTANDO++)); }
detalhe() { log "    ${CYAN}->  $1${RESET}"; }

back_has()    { grep -rq "$1" "$BACK/src/main/java" --include="*.java" 2>/dev/null; }
front_has()   { grep -rq "$1" "$FRONT" --include="*.ts" --include="*.tsx" 2>/dev/null; }
file_exists() { [ -f "$1" ]; }

{
log ""
log "${BOLD}╔══════════════════════════════════════════════════════════════════════════╗${RESET}"
log "${BOLD}║   CONSIG-SNIPER · AUDITORIA DE CASOS DE USO                           ║${RESET}"
log "${BOLD}║   Gerado em: $(date '+%d/%m/%Y as %H:%M:%S')                                     ║${RESET}"
log "${BOLD}╚══════════════════════════════════════════════════════════════════════════╝${RESET}"
log ""

# ════════════════════════════════════════════
title "COMODO 1 · A PORTARIA (Seguranca)"
# ════════════════════════════════════════════

log ""
log "  ${BOLD}CU-01 · Autenticacao e Autorizacao (Login + JWT)${RESET}"
JWT_FILTER=$(file_exists "$BACK/src/main/java/com/jws/consig/security/JwtFilter.java")
JWT_UTILS=$(file_exists  "$BACK/src/main/java/com/jws/consig/security/JwtUtils.java")
AUTH_CTRL=$(file_exists  "$BACK/src/main/java/com/jws/consig/controller/AuthController.java")
FRONT_AUTH=$(front_has "authService\|auth/login\|/auth")

if $JWT_FILTER && $JWT_UTILS && $AUTH_CTRL; then
  if $FRONT_AUTH; then
    ok "CU-01 · Login JWT — Back + Front implementados"
    detalhe "JwtFilter.java | JwtUtils.java | AuthController.java"
  else
    parcial "CU-01 · Backend JWT ok, authService.ts nao encontrado"
    detalhe "TODO: criar src/services/authService.ts com metodo login(email, senha)"
  fi
else
  falta "CU-01 · Autenticacao JWT incompleta"
  $JWT_FILTER || detalhe "JwtFilter.java nao encontrado"
  $JWT_UTILS  || detalhe "JwtUtils.java nao encontrado"
  $AUTH_CTRL  || detalhe "AuthController.java nao encontrado"
fi

log ""
log "  ${BOLD}CU-02 · Protecao de Fronteira (Interceptador Axios 401/403)${RESET}"
INT_REQ=$(front_has "interceptors.request")
INT_RES=$(front_has "interceptors.response")
LIMPA=$(front_has "localStorage.removeItem\|localStorage.clear")
REDIR=$(front_has "window.location\|navigate.*login")

if $INT_REQ && $INT_RES && $LIMPA; then
  ok "CU-02 · Interceptador Axios configurado"
  detalhe "interceptors.request | interceptors.response | limpa localStorage"
  $REDIR && detalhe "Redirecionamento ao login detectado" || detalhe "AVISO: verificar redirecionamento ao login"
else
  parcial "CU-02 · Interceptador parcial"
  $INT_REQ || detalhe "interceptors.request nao encontrado"
  $INT_RES || detalhe "interceptors.response nao encontrado"
  $LIMPA   || detalhe "localStorage.removeItem nao encontrado"
fi

log ""
log "  ${BOLD}CU-03 · Recuperacao de Senha${RESET}"
BACK_REC=$(back_has "recuperar\|resetPassword\|forgotPassword")
FRONT_REC=$(front_has "recuperar\|forgotPassword\|esqueci")

if $BACK_REC && $FRONT_REC; then
  ok "CU-03 · Recuperacao de senha implementada"
elif $BACK_REC || $FRONT_REC; then
  parcial "CU-03 · Recuperacao parcial"
  $BACK_REC  || detalhe "TODO Backend:  POST /api/auth/recuperar"
  $FRONT_REC || detalhe "TODO Frontend: link 'Esqueci minha senha' na tela de login"
else
  falta "CU-03 · Recuperacao de senha nao implementada"
  detalhe "TODO Backend:  POST /api/auth/recuperar"
  detalhe "TODO Frontend: link 'Esqueci minha senha' na tela de login"
fi

# ════════════════════════════════════════════
title "COMODO 2 · SALA DE OPERACOES (Kanban)"
# ════════════════════════════════════════════

log ""
log "  ${BOLD}CU-04 · Carregar Meus Leads${RESET}"
BACK_MEUS=$(back_has "meus-leads\|meusLeads\|listarMeusLeads")
FRONT_MEUS=$(front_has "listarMeusLeads\|meus-leads")
CONSUL_CTRL=$(file_exists "$BACK/src/main/java/com/jws/consig/controller/ConsultorController.java")

if $BACK_MEUS && $FRONT_MEUS && $CONSUL_CTRL; then
  ok "CU-04 · Meus Leads funcionando (GET /api/meus-leads filtrado por consultor)"
  detalhe "ConsultorController.java | listarMeusLeads() no frontend"
else
  parcial "CU-04 · Meus Leads parcial"
  $BACK_MEUS   || detalhe "Backend: rota /api/meus-leads nao encontrada"
  $FRONT_MEUS  || detalhe "Frontend: listarMeusLeads() nao encontrado"
fi

log ""
log "  ${BOLD}CU-05 · Movimentar Lead (Atualizar Status + Kanban)${RESET}"
BACK_STATUS=$(back_has "status\|atualizarStatus\|updateStatus")
FRONT_STATUS=$(front_has "atualizarStatus\|updateStatus")
KANBAN=$(front_has "kanban\|Kanban\|drag\|DragDrop")

if $BACK_STATUS && $FRONT_STATUS; then
  if $KANBAN; then
    ok "CU-05 · Status + Kanban/Drag implementados"
  else
    parcial "CU-05 · Atualizacao de status ok, Drag and Drop nao detectado"
    detalhe "TODO: implementar DnD (ex: @dnd-kit/core ou react-beautiful-dnd)"
  fi
else
  falta "CU-05 · Atualizacao de status nao implementada"
  $BACK_STATUS  || detalhe "Backend: falta PATCH /api/leads/{id}/status"
  $FRONT_STATUS || detalhe "Frontend: falta chamada de atualizacao de status"
fi

log ""
log "  ${BOLD}CU-06 · Detalhes e Anotacoes do Lead (Modal)${RESET}"
BACK_DET=$(back_has "detalhes\|anotacao\|notas\|nota")
FRONT_MODAL=$(front_has "Modal\|modal\|detalhe\|anotacao")

if $BACK_DET && $FRONT_MODAL; then
  ok "CU-06 · Modal de detalhes e anotacoes implementado"
elif $BACK_DET || $FRONT_MODAL; then
  parcial "CU-06 · Modal de detalhes parcial"
  $BACK_DET    || detalhe "TODO Backend:  GET /api/leads/{id}/detalhes"
  $FRONT_MODAL || detalhe "TODO Frontend: componente Modal ao duplo clique"
else
  falta "CU-06 · Modal de detalhes nao implementado"
  detalhe "TODO Backend:  GET /api/leads/{id}/detalhes"
  detalhe "TODO Frontend: componente Modal com historico + textarea de notas"
fi

log ""
log "  ${BOLD}CU-07 · Buscar e Filtrar Leads${RESET}"
FRONT_FILTER=$(front_has "filter\|filtro\|Filtro\|searchTerm")
FILTER_FILE=$(find "$FRONT" -name "*Filter*" 2>/dev/null | grep -v node_modules | head -1)

if [ -n "$FILTER_FILE" ] && $FRONT_FILTER; then
  ok "CU-07 · Filtro de leads implementado"
  detalhe "Componente: $(basename $FILTER_FILE)"
else
  parcial "CU-07 · Filtro parcial"
  [ -z "$FILTER_FILE" ] && detalhe "Componente de filtro nao encontrado"
  $FRONT_FILTER || detalhe "Logica de filter() nao detectada"
fi

# ════════════════════════════════════════════
title "COMODO 3 · SALA DE MAQUINAS (Admin)"
# ════════════════════════════════════════════

log ""
log "  ${BOLD}CU-08 · Gestao de Tropa (CRUD de Usuarios)${RESET}"
BACK_USR=$(file_exists "$BACK/src/main/java/com/jws/consig/controller/UserController.java")
FRONT_LIST=$(front_has "listarUsuarios\|UserManagement")
FRONT_CREATE=$(front_has "criarUsuario\|salvar.*user\|showForm\|Criar Usuario")
FRONT_EDIT=$(front_has "editarUsuario\|handleStartEdit\|handleSaveEdit")
FRONT_TOGGLE=$(front_has "toggleStatus\|handleToggleStatus")

if $BACK_USR && $FRONT_LIST && $FRONT_CREATE && $FRONT_EDIT; then
  ok "CU-08 · CRUD de usuarios completo"
  detalhe "UserController.java | UserManagement.tsx"
  detalhe "Listar | Criar | Editar | Ativar/Desativar"
else
  parcial "CU-08 · CRUD de usuarios parcial"
  $BACK_USR      || detalhe "UserController.java nao encontrado"
  $FRONT_LIST    || detalhe "Listagem de usuarios nao encontrada"
  $FRONT_CREATE  || detalhe "Criacao de usuario nao encontrada"
  $FRONT_EDIT    || detalhe "Edicao de usuario nao encontrada"
fi

log ""
log "  ${BOLD}CU-09 · Upload CSV (Importar Leads)${RESET}"
BACK_CSV=$(back_has "upload\|importCSV\|importar\|MultipartFile")
FRONT_CSV=$(front_has "importarCSV\|uploadCsv\|FormData\|multipart")
FRONT_CSV_UI=$(front_has "LeadUpload\|Importar\|upload.*csv")

if $BACK_CSV && $FRONT_CSV; then
  ok "CU-09 · Upload de CSV implementado"
  detalhe "Backend: MultipartFile | Frontend: FormData + Axios"
  $FRONT_CSV_UI && detalhe "Componente de upload na UI detectado"
else
  parcial "CU-09 · Upload de CSV parcial"
  $BACK_CSV     || detalhe "Backend: rota de upload nao encontrada"
  $FRONT_CSV    || detalhe "Frontend: FormData/multipart nao encontrado"
fi

log ""
log "  ${BOLD}CU-10 · Atribuicao de Leads${RESET}"
BACK_ATRIB=$(back_has "atribuir\|atribuirLeads")
FRONT_ATRIB=$(front_has "atribuirLeads\|consultorId\|Atribuir")
FRONT_BULK=$(front_has "selectedIds\|emMassa\|massa")

if $BACK_ATRIB && $FRONT_ATRIB; then
  ok "CU-10 · Atribuicao de leads implementada"
  detalhe "Backend: PUT /admin/leads/atribuir"
  $FRONT_BULK && detalhe "Selecao em massa detectada"
else
  falta "CU-10 · Atribuicao de leads nao implementada"
  $BACK_ATRIB  || detalhe "Backend: rota de atribuicao nao encontrada"
  $FRONT_ATRIB || detalhe "Frontend: atribuirLeads() nao encontrado"
fi

# ════════════════════════════════════════════
title "COMODO 4 · A DIRETORIA (Metricas + Perfil)"
# ════════════════════════════════════════════

log ""
log "  ${BOLD}CU-11 · Dashboard de Desempenho (Metricas/Graficos)${RESET}"
BACK_MET=$(back_has "metricas\|metrics\|desempenho\|performance")
FRONT_CHART=$(front_has "recharts\|Chart\|BarChart\|LineChart")
FRONT_MET=$(front_has "getMetricas\|metricas\|desempenho")

if $BACK_MET && $FRONT_CHART; then
  ok "CU-11 · Dashboard de metricas com graficos implementado"
elif $BACK_MET || $FRONT_CHART || $FRONT_MET; then
  parcial "CU-11 · Dashboard de metricas parcial"
  $BACK_MET    || detalhe "TODO Backend:  GET /api/admin/metricas"
  $FRONT_CHART || detalhe "TODO Frontend: instalar Recharts + componente de graficos"
  $FRONT_MET   || detalhe "TODO Frontend: componente de metricas nao encontrado"
else
  falta "CU-11 · Dashboard de metricas nao implementado"
  detalhe "TODO Backend:  GET /api/admin/metricas"
  detalhe "TODO Frontend: npm install recharts + pagina de desempenho"
fi

log ""
log "  ${BOLD}CU-12 · Perfil do Usuario (Alterar Senha)${RESET}"
BACK_SENHA=$(back_has "senha\|alterarSenha\|changePassword\|trocaSenha")
FRONT_PERFIL=$(front_has "perfil\|Perfil\|alterarSenha\|senha.*antiga")
TROCA_OBRIG=$(back_has "trocaSenhaObrigatoria")

if $BACK_SENHA && $FRONT_PERFIL; then
  ok "CU-12 · Perfil e alteracao de senha implementados"
elif $BACK_SENHA || $TROCA_OBRIG; then
  parcial "CU-12 · Alteracao de senha parcial"
  $FRONT_PERFIL || detalhe "TODO Frontend: pagina /perfil com formulario de senha"
  $TROCA_OBRIG  && detalhe "Campo trocaSenhaObrigatoria existe no banco mas tela nao implementada"
else
  falta "CU-12 · Perfil do usuario nao implementado"
  detalhe "TODO Backend:  PUT /api/usuarios/senha"
  detalhe "TODO Frontend: pagina /perfil com formulario de alteracao de senha"
fi

# ════════════════════════════════════════════
dsep
log ""
log "  ${BOLD}PLACAR FINAL DA AUDITORIA${RESET}"
log ""
log "  ${GREEN}${BOLD}IMPLEMENTADO  : $OK / 12${RESET}"
log "  ${YELLOW}${BOLD}PARCIAL       : $PARCIAL / 12${RESET}"
log "  ${RED}${BOLD}NAO IMPL.     : $FALTANDO / 12${RESET}"
log ""

SCORE=$(( (OK * 100 + PARCIAL * 50) / 12 ))
log "  ${BOLD}COMPLETUDE DO PRODUTO: $SCORE%${RESET}"
log ""

if [ "$SCORE" -ge 80 ]; then
  log "  ${GREEN}${BOLD}PRODUTO MADURO — pronto para testes com usuarios reais${RESET}"
elif [ "$SCORE" -ge 60 ]; then
  log "  ${YELLOW}${BOLD}PRODUTO EM CONSTRUCAO — core ok, faltam features${RESET}"
else
  log "  ${RED}${BOLD}MVP EM ANDAMENTO — priorize CU-01 a CU-05${RESET}"
fi

log ""
log "  PRIORIDADES:"
[ $FALTANDO -gt 0 ] && log "  ${RED}  1. Implementar os $FALTANDO CUs faltando${RESET}"
[ $PARCIAL -gt 0 ]  && log "  ${YELLOW}  2. Completar os $PARCIAL CUs parciais${RESET}"
log "  ${CYAN}  3. Rodar scan_consig.sh para status dos servicos${RESET}"
log ""
log "  Relatorio salvo em: ${BOLD}$REPORT${RESET}"
log ""
dsep

} 2>&1 | tee "$REPORT"

echo ""
echo -e "${GREEN}${BOLD}Auditoria concluida! Relatorio em: $REPORT${RESET}"
echo ""
echo -e "${CYAN}Para ver so os itens pendentes:${RESET}"
echo -e "   grep 'NAO IMPL\|PARCIAL' $REPORT"
echo ""
