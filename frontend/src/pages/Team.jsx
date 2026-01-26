import { useEffect, useState } from 'react';
import MainLayout from '../components/MainLayout';
import api from '../services/api';
import { UserPlus, Power, Shield, User, Send, X } from 'lucide-react';

export default function Team() {
  const [user, setUser] = useState(null);
  const [teamMembers, setTeamMembers] = useState([]);

  const [showForm, setShowForm] = useState(false);
  const [distributeModal, setDistributeModal] = useState({ open: false, userId: null, userName: '', quantity: 10 });
  const [newUser, setNewUser] = useState({ nome: '', cpf: '', password: '' });

  useEffect(() => {
    const storedUser = localStorage.getItem('user');
    if (storedUser) setUser(JSON.parse(storedUser));
    fetchTeam();
  }, []);

  const fetchTeam = async () => {
    try {
      // OBRIGATÓRIO: Tem que ser /users (não /auth/users)
      const response = await api.get('/users');
      setTeamMembers(response.data);
    } catch (error) {
      console.error("Erro ao buscar equipe", error);
      // Se der 403 aqui, é token expirado
      if (error.response && error.response.status === 403) {
         alert("Sessão expirada. Faça login novamente.");
      }
    }
  };

  const handleRegister = async (e) => {
    e.preventDefault();
    try {
      // OBRIGATÓRIO: Tem que ser /users (não /auth/register)
      await api.post('/users', { ...newUser, role: 'USER' });
      alert('Vendedor cadastrado com sucesso!');
      setShowForm(false);
      setNewUser({ nome: '', cpf: '', password: '' });
      fetchTeam();
    } catch (error) {
      console.error(error);
      alert('Erro ao cadastrar. Verifique se o CPF já existe ou se você é Admin.');
    }
  };

  const handleToggleStatus = async (id, nome, currentStatus) => {
    const confirmMessage = currentStatus
        ? `Deseja realmente BLOQUEAR ${nome}? Ele perderá o acesso imediatamente.`
        : `Deseja REATIVAR o acesso de ${nome}?`;

    if (window.confirm(confirmMessage)) {
        try {
            // OBRIGATÓRIO: Tem que ser /users (não /auth/users)
            await api.patch(`/users/${id}/status`);
            fetchTeam();
        } catch (error) {
            alert('Erro ao alterar status. Verifique se você é Admin.');
        }
    }
  };

  const handleDistribute = async () => {
    try {
      const payload = {
        userId: distributeModal.userId,
        quantity: parseInt(distributeModal.quantity)
      };

      const response = await api.post('/leads/distribute', payload);
      alert(`Sucesso! ${response.data.count} leads foram entregues para ${distributeModal.userName}.`);
      setDistributeModal({ open: false, userId: null, userName: '', quantity: 10 });
    } catch (error) {
      alert('Erro ao distribuir. Verifique se existem leads livres suficientes.');
    }
  };

  return (
    <MainLayout user={user}>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <h2 style={{ color: 'white' }}>Gestão de Equipe</h2>
        <button
          onClick={() => setShowForm(!showForm)}
          style={{ background: '#10b981', color: 'white', border: 'none', padding: '10px 20px', borderRadius: '8px', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px', fontWeight: 'bold' }}>
          <UserPlus size={18} /> Novo Membro
        </button>
      </div>

      {showForm && (
        <div style={{ background: '#1e293b', padding: '1.5rem', borderRadius: '12px', marginBottom: '2rem', border: '1px solid #334155' }}>
           <h3 style={{ color: '#38bdf8', marginBottom: '1rem' }}>Cadastrar Novo Vendedor</h3>
           <form onSubmit={handleRegister} style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr auto', gap: '1rem', alignItems: 'end' }}>
              <input type="text" placeholder="Nome Completo" required value={newUser.nome} onChange={e => setNewUser({...newUser, nome: e.target.value})} style={{ background: '#0f172a', border: '1px solid #334155', color: 'white', padding: '10px', borderRadius: '6px' }} />
              <input type="text" placeholder="CPF (Login)" required value={newUser.cpf} onChange={e => setNewUser({...newUser, cpf: e.target.value})} style={{ background: '#0f172a', border: '1px solid #334155', color: 'white', padding: '10px', borderRadius: '6px' }} />
              <input type="password" placeholder="Senha" required value={newUser.password} onChange={e => setNewUser({...newUser, password: e.target.value})} style={{ background: '#0f172a', border: '1px solid #334155', color: 'white', padding: '10px', borderRadius: '6px' }} />
              <button type="submit" style={{ background: '#38bdf8', color: '#0f172a', border: 'none', padding: '10px 20px', borderRadius: '6px', fontWeight: 'bold', cursor: 'pointer' }}>Salvar</button>
           </form>
        </div>
      )}

      {distributeModal.open && (
        <div style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, background: 'rgba(0,0,0,0.8)', display: 'flex', justifyContent: 'center', alignItems: 'center', zIndex: 999 }}>
            <div style={{ background: '#1e293b', padding: '2rem', borderRadius: '12px', width: '400px', border: '1px solid #38bdf8' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1rem' }}>
                    <h3 style={{ color: 'white', margin: 0 }}>Enviar Leads</h3>
                    <X style={{ cursor: 'pointer', color: '#94a3b8' }} onClick={() => setDistributeModal({ ...distributeModal, open: false })} />
                </div>
                <p style={{ color: '#cbd5e1' }}>Quantos leads você quer enviar para <strong>{distributeModal.userName}</strong>?</p>
                <input type="number" min="1" value={distributeModal.quantity} onChange={e => setDistributeModal({...distributeModal, quantity: e.target.value})} style={{ width: '100%', padding: '10px', marginTop: '10px', marginBottom: '20px', borderRadius: '6px', border: '1px solid #334155', background: '#0f172a', color: 'white', fontSize: '1.2rem' }} />
                <button onClick={handleDistribute} style={{ width: '100%', padding: '12px', background: '#38bdf8', border: 'none', borderRadius: '6px', fontWeight: 'bold', cursor: 'pointer' }}>CONFIRMAR ENVIO</button>
            </div>
        </div>
      )}

      <div style={{ display: 'grid', gap: '1rem' }}>
        {teamMembers.map(member => (
          <div key={member.id} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', background: '#1e293b', padding: '1.5rem', borderRadius: '12px', border: '1px solid #334155', opacity: member.isActive ? 1 : 0.6 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
              <div style={{ width: '45px', height: '45px', background: member.role === 'ADMIN' ? '#f59e0b' : '#334155', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'white' }}>
                {member.role === 'ADMIN' ? <Shield size={20}/> : <User size={20}/>}
              </div>
              <div>
                <h4 style={{ color: 'white', margin: 0 }}>
                    {member.nome}
                    {!member.isActive && <span style={{ color: '#ef4444', fontSize: '0.8rem', marginLeft: '10px', fontWeight: 'bold' }}>(BLOQUEADO)</span>}
                </h4>
                <span style={{ color: '#94a3b8', fontSize: '0.9rem' }}>CPF: {member.cpf}</span>
              </div>
            </div>

            <div style={{ display: 'flex', gap: '10px' }}>

               {member.role !== 'ADMIN' && member.isActive && (
                   <button
                     onClick={() => setDistributeModal({ open: true, userId: member.id, userName: member.nome, quantity: 10 })}
                     style={{ background: '#0f172a', border: '1px solid #38bdf8', color: '#38bdf8', padding: '8px 16px', borderRadius: '6px', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '5px' }}
                     title="Distribuir Leads"
                   >
                     <Send size={16} /> Distribuir
                   </button>
               )}

               {member.role !== 'ADMIN' && (
                   <button
                     onClick={() => handleToggleStatus(member.id, member.nome, member.isActive)}
                     style={{
                         background: member.isActive ? 'rgba(239, 68, 68, 0.2)' : 'rgba(34, 197, 94, 0.2)',
                         border: `1px solid ${member.isActive ? '#ef4444' : '#22c55e'}`,
                         color: member.isActive ? '#ef4444' : '#22c55e',
                         cursor: 'pointer', padding: '8px', borderRadius: '6px'
                     }}
                     title={member.isActive ? "Bloquear Acesso" : "Reativar Acesso"}
                   >
                     <Power size={18} />
                   </button>
               )}
            </div>
          </div>
        ))}
      </div>

    </MainLayout>
  );
}