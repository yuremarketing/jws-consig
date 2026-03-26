#!/bin/bash

# Cores para o log
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}==============================================================${NC}"
echo -e "${YELLOW} RESOLUÇÃO DEFINITIVA: SINCRONIA DE DB E SPRING BOOT          ${NC}"
echo -e "${YELLOW}==============================================================${NC}"

# 1. Ajustando o application.properties
echo -e "\n${GREEN}[1/4] Verificando e reescrevendo application.properties...${NC}"
PROP_FILE="consig/src/main/resources/application.properties"

# Cria a pasta caso algum erro anterior tenha apagado
mkdir -p consig/src/main/resources

# Sobrescreve o arquivo com a configuração oficial e o Dialeto travado
cat << 'EOF' > $PROP_FILE
spring.application.name=consig

# Configuração Exata do Banco de Dados
spring.datasource.url=jdbc:postgresql://localhost:5432/consigsniper
spring.datasource.username=postgres
spring.datasource.password=admin123
spring.datasource.driver-class-name=org.postgresql.Driver

# Forçando o Dialeto do Hibernate para evitar o erro "JDBC metadata"
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
EOF
echo -e "✅ application.properties ajustado e blindado!"

# 2. Recriando o docker-compose.yml
echo -e "\n${GREEN}[2/4] Recriando docker-compose.yml com as MESMAS credenciais...${NC}"
cat << 'EOF' > docker-compose.yml
version: '3.8'
services:
  sniper-db:
    image: postgres:15-alpine
    container_name: sniper-db
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: admin123
      POSTGRES_DB: consigsniper
    ports:
      - "5432:5432"
    volumes:
      - ./consig/init.sql:/docker-entrypoint-initdb.d/init.sql
EOF
echo -e "✅ docker-compose.yml restaurado!"

# 3. Subindo o banco e limpando o cache antigo
echo -e "\n${GREEN}[3/4] Resetando o container do PostgreSQL...${NC}"
# Derruba qualquer banco zumbi que esteja com a senha velha
docker compose down -v 2>/dev/null || docker-compose down -v 2>/dev/null
docker compose up -d || docker-compose up -d

echo -e "${YELLOW}⏳ Aguardando 10 segundos para o PostgreSQL inicializar totalmente...${NC}"
sleep 10

# 4. Rodando o Spring Boot
echo -e "\n${GREEN}[4/4] Dando a ignição no motor do Spring Boot...${NC}"
cd consig
#!/bin/bash

# Cores para o log
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}==============================================================${NC}"
echo -e "${YELLOW} RESOLUÇÃO DEFINITIVA: SINCRONIA DE DB E SPRING BOOT          ${NC}"
echo -e "${YELLOW}==============================================================${NC}"

# 1. Ajustando o application.properties
echo -e "\n${GREEN}[1/4] Verificando e reescrevendo application.properties...${NC}"
PROP_FILE="consig/src/main/resources/application.properties"

# Cria a pasta caso algum erro anterior tenha apagado
mkdir -p consig/src/main/resources

# Sobrescreve o arquivo com a configuração oficial e o Dialeto travado
cat << 'EOF' > $PROP_FILE
spring.application.name=consig

# Configuração Exata do Banco de Dados
spring.datasource.url=jdbc:postgresql://localhost:5432/consigsniper
spring.datasource.username=postgres
spring.datasource.password=admin123
spring.datasource.driver-class-name=org.postgresql.Driver

# Forçando o Dialeto do Hibernate para evitar o erro "JDBC metadata"
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
EOF
echo -e "✅ application.properties ajustado e blindado!"

# 2. Recriando o docker-compose.yml
echo -e "\n${GREEN}[2/4] Recriando docker-compose.yml com as MESMAS credenciais...${NC}"
cat << 'EOF' > docker-compose.yml
version: '3.8'
services:
  sniper-db:
    image: postgres:15-alpine
    container_name: sniper-db
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: admin123
      POSTGRES_DB: consigsniper
    ports:
      - "5432:5432"
    volumes:
      - ./consig/init.sql:/docker-entrypoint-initdb.d/init.sql
EOF
echo -e "✅ docker-compose.yml restaurado!"

# 3. Subindo o banco e limpando o cache antigo
echo -e "\n${GREEN}[3/4] Resetando o container do PostgreSQL...${NC}"
# Derruba qualquer banco zumbi que esteja com a senha velha
docker compose down -v 2>/dev/null || docker-compose down -v 2>/dev/null
docker compose up -d || docker-compose up -d

echo -e "${YELLOW}⏳ Aguardando 10 segundos para o PostgreSQL inicializar totalmente...${NC}"
sleep 10

# 4. Rodando o Spring Boot
echo -e "\n${GREEN}[4/4] Dando a ignição no motor do Spring Boot...${NC}"
cd consig
./mvnw clean spring-boot:run
