#!/bin/bash
echo "--------------------------------------------------------"
echo "🛠️  LIMPANDO A ZONA E RODANDO CHECKUP..."
echo "--------------------------------------------------------"

# 1. Limpa tudo
mvn clean

# 2. Compila só o projeto (ignora testes pra não travar)
echo "📦 Compilando código principal..."
mvn install -DskipTests

# 3. Procura os métodos nos arquivos reais
echo "🔍 Buscando métodos no código..."
echo "--- No LeadRepository: ---"
grep "findByCpf" src/main/java/com/jws/consig/repository/LeadRepository.java || echo "❌ NÃO ACHOU findByCpf"

echo "--- No LeadService: ---"
grep "importarLeadsMassivo" src/main/java/com/jws/consig/service/LeadService.java || echo "❌ NÃO ACHOU importarLeadsMassivo"

# 4. Tenta compilar os testes e mostra o erro real se falhar
echo "🧪 Tentando compilar os testes..."
mvn test-compile
