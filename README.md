# Consig-Sniper

## Descritivo do Sistema
O Consig-Sniper é um ecossistema Full-Stack de alta performance desenvolvido para a gestão, filtragem e conversão de leads no setor de crédito consignado. O sistema resolve o problema de processamento de grandes volumes de dados (listas de leads) e a falta de visibilidade sobre o capital disponível em campo.

Diferente de planilhas estáticas, o Sniper oferece uma interface reativa onde o consultor pode filtrar alvos por margem e CPF, realizar abordagens diretas e atualizar o status de conversão em tempo real, fornecendo ao administrador uma auditoria completa de vendas e métricas de ticket médio.

---

## Arquitetura Tecnológica

### Backend (Core Engine)
* Linguagem: Java 21 (LTS)
* Framework: Spring Boot 3.2.4
* Segurança: Spring Security 6.2 (Stateless/Basic Auth com Route Guarding)
* Banco de Dados: PostgreSQL
* Persistência: Spring Data JPA / Hibernate
* Logs e Auditoria: Slf4j para rastreamento de operações críticas

### Frontend (Interface de Comando)
* Linguagem: JavaScript / React 18
* Build Tool: Vite (Performance de Hot Reload)
* Estilização: Tailwind CSS (Arquitetura Utilitária)
* Gerenciamento de Estado: React Context API (Auth e Persistência de Sessão)
* Comunicação API: Axios com Interceptores de Request

---

## Estrutura do Projeto (Monorepo)
O repositório está organizado de forma unificada para facilitar o deploy e a manutenção:

* /src: Código fonte do Backend Java.
* /consig-sniper-web: Diretório raiz do Frontend React.
* pom.xml: Gerenciamento de dependências Maven.
* init.sql: Script de inicialização do banco de dados PostgreSQL.
* lista_teste.csv: Modelo de dados para importação em massa.

---

## Funcionalidades Principais

1. Importação Inteligente: Processamento de arquivos CSV com validação de duplicidade baseada em CPF (Regra de Ouro).
2. Dashboard de KPIs: Cálculo em tempo real de Capital em Campo, Ticket Médio e Leads no Radar utilizando lógica de redução no Frontend.
3. Filtro de Precisão: Busca instantânea por CPF (sanitizado) e filtragem por faixa de margem financeira.
4. Gestão de Status: Transição de estados do Lead (Pendente, Vendido, Descartado) com persistência imutável no banco de dados.
5. Muralha de Acesso: Proteção de rotas e persistência de sessão para garantir que apenas usuários autorizados visualizem os dados.
6. Auditoria: Exportação de relatórios em CSV das vendas convertidas para conciliação financeira.

---

## Guia de Instalação e Execução

### Requisitos
* Java 21 ou superior.
* Node.js 18 ou superior.
* PostgreSQL rodando na porta 5432.

### Executando o Backend
1. Configure as credenciais do banco em src/main/resources/application.properties.
2. No terminal raiz, execute: ./mvnw spring-boot:run
3. O servidor estará ativo em: http://localhost:8080

### Executando o Frontend
1. Acesse a pasta do frontend: cd consig-sniper-web
2. Instale as dependências: npm install
3. Inicie a aplicação: npm run dev
4. Acesse em: http://localhost:5173

---

## Licença e Uso
Propriedade intelectual de Yure Silva. Sistema desenvolvido para operações de crédito consignado de alta escala.
