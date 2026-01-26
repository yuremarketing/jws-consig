import React from 'react';
import { useNavigate } from 'react-router-dom'; // <--- Importante para navegar
import { LogOut, User, LayoutDashboard, Users } from 'lucide-react';

export default function MainLayout({ children, user }) {
  const navigate = useNavigate(); // <--- Hook de navegação

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = '/';
  };

  return (
    <div style={{ display: 'flex', minHeight: '100vh', background: '#0f172a', color: 'white', fontFamily: 'Inter' }}>

      {/* --- SIDEBAR (Barra Lateral) --- */}
      <aside style={{ width: '250px', background: '#1e293b', padding: '2rem', borderRight: '1px solid #334155', display: 'flex', flexDirection: 'column' }}>
        <h1 style={{ fontSize: '1.5rem', fontWeight: 'bold', color: 'white', marginBottom: '3rem', letterSpacing: '1px' }}>
          SNIPER <span style={{ color: '#38bdf8' }}>CONSIG</span>
        </h1>

        <nav style={{ flex: 1 }}>
          <ul style={{ listStyle: 'none', padding: 0 }}>
            <li
              onClick={() => navigate('/dashboard')}
              style={{ marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '10px', color: '#38bdf8', cursor: 'pointer' }}
            >
              <LayoutDashboard size={20} /> Painel Principal
            </li>

            {/* Só mostra 'Equipe' se for Admin */}
            {user?.role === 'ADMIN' && (
              <li
                onClick={() => navigate('/team')} // <--- O PULO DO GATO (Link funcionando)
                style={{ marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '10px', color: '#94a3b8', cursor: 'pointer' }}
              >
                <Users size={20} /> Equipe
              </li>
            )}
          </ul>
        </nav>

        <button onClick={handleLogout} style={{ display: 'flex', alignItems: 'center', gap: '10px', background: '#ef4444', color: 'white', border: 'none', padding: '10px', borderRadius: '8px', cursor: 'pointer', marginTop: 'auto' }}>
          <LogOut size={16} /> Sair
        </button>
      </aside>

      {/* --- MIOLO DA PÁGINA --- */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>

        {/* HEADER (Cabeçalho) */}
        <header style={{ padding: '2rem', borderBottom: '1px solid #334155', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <h2 style={{ fontSize: '1.8rem' }}>Olá, {user ? user.nome : 'Usuário'}</h2>
            <p style={{ color: '#94a3b8' }}>
               {user?.role === 'ADMIN' ? 'Modo Gestor (Visão Total)' : 'Vamos trabalhar hoje?'}
            </p>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
             <div style={{ textAlign: 'right' }}>
               <span style={{ display: 'block', fontSize: '0.9rem', fontWeight: 'bold' }}>{user?.cpf}</span>
               <span style={{ display: 'block', fontSize: '0.8rem', color: '#38bdf8' }}>{user?.role}</span>
             </div>
             <div style={{ width: '40px', height: '40px', background: '#38bdf8', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#0f172a' }}>
               <User />
             </div>
          </div>
        </header>

        {/* AQUI ENTRA O CONTEÚDO VARIÁVEL */}
        <main style={{ padding: '2rem', flex: 1, overflowY: 'auto' }}>
            {children}
        </main>

      </div>
    </div>
  );
}