import { useEffect, useState } from 'react';
import api from '../services/api';
import MainLayout from '../components/MainLayout';
import LeadList from '../components/LeadList';

export default function Dashboard() {
  const [user, setUser] = useState(null);
  const [leads, setLeads] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // 1. Carrega o Usuário do Navegador
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      setUser(JSON.parse(storedUser));
    }

    // 2. Busca os Leads no Backend
    fetchLeads();
  }, []);

  const fetchLeads = async () => {
    try {
      // Se tiver erro de login, ele vai jogar pro catch
      const response = await api.get('/leads/my'); 
      setLeads(response.data);
    } catch (error) {
      console.error("Erro ao buscar leads:", error);
      // Se der erro 403, pode ser token expirado
      if(error.response && error.response.status === 403) {
         alert("Sessão expirada. Faça login novamente.");
         window.location.href = '/';
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <MainLayout user={user}>
      
      {/* Título da Página Interna */}
      <div style={{ marginBottom: '2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h2 style={{ fontSize: '1.5rem', color: 'white' }}>
            {user?.role === 'ADMIN' ? 'Visão Geral da Carteira' : 'Meus Clientes'}
        </h2>
        
        <span style={{ background: '#334155', padding: '6px 16px', borderRadius: '20px', fontSize: '0.9rem', color: '#cbd5e1' }}>
          {loading ? 'Carregando...' : `${leads.length} Leads Disponíveis`}
        </span>
      </div>

      {/* A Lista de Clientes (O Componente que criamos) */}
      <LeadList leads={leads} />

    </MainLayout>
  );
}
