import { useState } from 'react';
import api from '../services/api';
import { Lock, User } from 'lucide-react';

export default function Login() {
  const [cpf, setCpf] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      // 1. Tenta fazer login
      const response = await api.post('/auth/login', { cpf, password });

      // 2. Salva o Token e o Usuário no navegador
      const { token, user } = response.data;
      localStorage.setItem('token', token);
      localStorage.setItem('user', JSON.stringify(user));

      // 3. A BOTINA: Força o redirecionamento recarregando a página
      // Isso garante que o App.jsx perceba que você está logado
      window.location.href = '/dashboard';

    } catch (err) {
      alert('Erro: CPF ou Senha inválidos!');
    }
  };

  return (
    <div style={{ height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#0f172a', color: '#f8fafc', fontFamily: 'Inter, sans-serif' }}>
      <div style={{ background: '#1e293b', padding: '2.5rem', borderRadius: '16px', width: '100%', maxWidth: '400px', border: '1px solid #334155', boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.5)' }}>

        <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
          <h2 style={{ color: '#94a3b8', fontSize: '0.9rem', textTransform: 'uppercase', letterSpacing: '1px' }}>JWS Logo</h2>
          <h1 style={{ fontSize: '1.5rem', fontWeight: 'bold', margin: '10px 0' }}>Acesso ao Sistema</h1>
        </div>

        <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>

          <div style={{ position: 'relative' }}>
            <User size={20} style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', color: '#64748b' }} />
            <input
              type="text"
              placeholder="00000000000"
              value={cpf}
              onChange={e => setCpf(e.target.value)}
              style={{ width: '100%', padding: '12px 12px 12px 40px', borderRadius: '8px', border: '1px solid #334155', background: '#0f172a', color: 'white', outline: 'none' }}
            />
          </div>

          <div style={{ position: 'relative' }}>
            <Lock size={20} style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', color: '#64748b' }} />
            <input
              type="password"
              placeholder="••••••••"
              value={password}
              onChange={e => setPassword(e.target.value)}
              style={{ width: '100%', padding: '12px 12px 12px 40px', borderRadius: '8px', border: '1px solid #334155', background: '#0f172a', color: 'white', outline: 'none' }}
            />
          </div>

          <button type="submit" style={{ background: '#0ea5e9', color: 'white', fontWeight: 'bold', padding: '14px', borderRadius: '8px', border: 'none', cursor: 'pointer', fontSize: '1rem', textTransform: 'uppercase', letterSpacing: '0.5px', transition: 'background 0.2s' }}>
            Entrar no Dashboard
          </button>
        </form>
      </div>
    </div>
  );
}