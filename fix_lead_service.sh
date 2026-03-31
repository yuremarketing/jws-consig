#!/bin/bash
echo "=== 🔌 CONECTANDO O CANO: LEADSERVICE -> JAVA ==="

# Caminho do arquivo service que o find achou
SERVICE_FILE="../consig-sniper-web/src/services/leadService.ts"

cat << 'INNER_EOF' > "$SERVICE_FILE"
import api from './api';

export const leadService = {
  // Mudamos para listarTodos para bater com o Dashboard e corrigimos a URL para /api/...
  listarTodos: async (filtros: any = {}) => {
    const params = new URLSearchParams();
    Object.keys(filtros).forEach(key => {
      if (filtros[key]) params.append(key, filtros[key]);
    });
    // Adicionamos o /api no início
    const response = await api.get(`/api/admin/leads?${params.toString()}`);
    return response.data;
  },

  listarConsultores: async () => (await api.get('/api/admin/consultores')).data,

  atribuirLeads: async (leadIds: number[], consultorId: number) => 
    (await api.put('/api/admin/leads/atribuir', { leadIds, consultorId })).data,

  importarCSV: async (file: File) => {
    const formData = new FormData();
    formData.append('file', file);
    return (await api.post('/api/admin/leads/importar', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })).data;
  }
};
INNER_EOF

echo "✅ leadService.ts corrigido!"

# AGORA O DASHBOARD: Garantindo que ele pegue o .content do Page do Java
DASHBOARD_FILE="../consig-sniper-web/src/pages/Dashboard.tsx"
sed -i 's/setLeads(data);/setLeads(data.content || data);/g' "$DASHBOARD_FILE"

echo "✅ Dashboard.tsx ajustado para ler a paginação."
