#!/bin/bash
echo "=== 🔧 CORRIGINDO A URL DUPLICADA ==="

SERVICE_FILE="../consig-sniper-web/src/services/leadService.ts"

cat << 'INNER_EOF' > "$SERVICE_FILE"
import api from './api';

export const leadService = {
  listarTodos: async (filtros: any = {}) => {
    const params = new URLSearchParams();
    Object.keys(filtros).forEach(key => {
      if (filtros[key]) params.append(key, filtros[key]);
    });
    // Removido o /api daqui, pois o axios já coloca
    const response = await api.get(`/admin/leads?${params.toString()}`);
    return response.data;
  },

  listarConsultores: async () => (await api.get('/admin/consultores')).data,

  atribuirLeads: async (leadIds: number[], consultorId: number) => 
    (await api.put('/admin/leads/atribuir', { leadIds, consultorId })).data,

  importarCSV: async (file: File) => {
    const formData = new FormData();
    formData.append('file', file);
    return (await api.post('/admin/leads/importar', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })).data;
  }
};
INNER_EOF

echo "✅ leadService.ts corrigido!"
