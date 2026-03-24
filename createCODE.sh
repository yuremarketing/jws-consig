#!/bin/bash

# Definição de Cores para o Relatório
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

BACK_DIR="/home/mark/Dev/consig"
FRONT_DIR="/home/mark/Dev/consig-sniper-web"

clear
echo -e "${CYAN}=============================================================="
echo -e "   AUDITORIA TÉCNICA CONSIG-SNIPER: PENTE FINO TOTAL v5.0    "
echo -e "==============================================================${NC}"

# --- 1. AUDITORIA DE BACKEND (JAVA/SPRING/JAKARTA) ---
echo -e "\n${YELLOW}[Fase 1] Auditoria de Estrutura Java & Spring Boot${NC}"

check_java_file() {
    local file=$1
    local name=$2
    echo -n "Analisando $name..."
    if [ -f "$file" ]; then
        # Teste 1: Posição do Package (Documentação Oficial Java)
        if head -n 5 "$file" | grep -q "package"; then
            echo -e " ${GREEN}[PACKAGE OK]${NC}"
        else
            echo -e " ${RED}[ERRO: PACKAGE FORA DE LUGAR]${NC}"
        fi

        # Teste 2: Conflito de Annotations (Spring MVC)
        local mapping_count=$(grep "@PatchMapping" "$file" | wc -l)
        local method_count=$(grep "public ResponseEntity" "$file" | wc -l)
        if [ "$mapping_count" -gt "$method_count" ]; then
            echo -e "   ${RED}>> ALERTA: Mais mappings do que métodos! (Ambiguidade detectada)${NC}"
        fi

        # Teste 3: Dependências Jakarta Persistence
        if grep -q "jakarta.persistence" "$file"; then
            echo -e "   ${GREEN}>> JPA: Padrão Jakarta 3.0 detectado.${NC}"
        fi
    else
        echo -e " ${RED}[NÃO ENCONTRADO]${NC}"
    fi
}

check_java_file "$BACK_DIR/src/main/java/com/jws/consig/model/Lead.java" "Model: Lead"
check_java_file "$BACK_DIR/src/main/java/com/jws/consig/controller/consultor/ConsultorLeadController.java" "Controller: Consultor"

# --- 2. AUDITORIA DE FRONTEND (REACT/VITE/JS) ---
echo -e "\n${YELLOW}[Fase 2] Auditoria de Ecossistema Frontend${NC}"

check_front_file() {
    local file=$1
    local name=$2
    echo -n "Analisando $name..."
    if [ -f "$file" ]; then
        # Teste 1: Hooks do React (Regras do React 18)
        if grep -q "useMemo\|useEffect\|useState" "$file"; then
            echo -e " ${GREEN}[HOOKS ATIVOS]${NC}"
        fi
        
        # Teste 2: Importação de API
        if grep -q "from '.*api'" "$file"; then
            echo -e "   ${GREEN}>> Axios: Instância centralizada detectada.${NC}"
        else
            echo -e "   ${YELLOW}>> AVISO: Uso de Axios direto (Risco de inconsistência de URL).${NC}"
        fi
    else
        echo -e " ${RED}[FALTANDO NO DISCO]${NC}"
    fi
}

check_front_file "$FRONT_DIR/src/App.jsx" "App Principal"
check_front_file "$FRONT_DIR/src/components/LeadCard.jsx" "Componente LeadCard"

# --- 3. AUDITORIA DE PERMISSÕES DE SISTEMA (LINUX UBUNTU) ---
echo -e "\n${YELLOW}[Fase 3] Auditoria de Permissões de Arquivo (Linux)${NC}"

check_perms() {
    local dir=$1
    if [ -d "$dir" ]; then
        local perms=$(stat -c "%a" "$dir")
        echo -n "Diretório $dir: Permissão $perms"
        if [ "$perms" -eq 755 ] || [ "$perms" -eq 775 ]; then
            echo -e " ${GREEN}[SEGURO]${NC}"
        else
            echo -e " ${YELLOW}[AVISO: REVISAR CHMOD]${NC}"
        fi
    else
        echo -e "${RED}[DIR NÃO EXISTE: $dir]${NC}"
    fi
}

check_perms "$BACK_DIR"
check_perms "$FRONT_DIR"

# --- 4. RELATÓRIO DE IMPACTO DA UNIFICAÇÃO ---
echo -e "\n${CYAN}=============================================================="
echo -e "   RELATÓRIO DE IMPACTO: UNIFICAÇÃO (MONOREPO)               "
echo -e "==============================================================${NC}"
echo "1. Git History: O histórico será preservado se usarmos mv."
echo "2. Build Paths: O Maven precisará ser avisado se o pom.xml mudar de profundidade."
echo "3. Node Modules: Recomendado deletar node_modules e dar 'npm install' após a unificação."
echo "4. Spring Boot: O root do projeto Java mudará, impactando IDEs (VS Code/IntelliJ)."

echo -e "\n${GREEN}PENTE FINO CONCLUÍDO. ANALISE OS ERROS ACIMA ANTES DE UNIFICAR.${NC}"
