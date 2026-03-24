#!/bin/bash

FRONT_DIR="/home/mark/Dev/consig-sniper-web"
cd "$FRONT_DIR"

echo -e "\033[0;36m=============================================================="
echo -e "   CONSIG-SNIPER: OPERAÇÃO MURALHA DE ACESSO v3.0            "
echo -e "==============================================================\033[0m"

# 1. ATUALIZANDO O AUTHCONTEXT (O MOTOR DE IDENTIDADE)
echo -e "\033[1;33m[1/3] Calibrando AuthContext para Persistência... \033[0m"
cat << 'EOF' > src/contexts/AuthContext.jsx
import React, { createContext, useState, useContext, useEffect } from 'react';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const savedToken = localStorage.getItem('token');
    if (savedToken) {
      setUser({ authenticated: true, token: savedToken });
    }
    setLoading(false);
  }, []);

  const login = (credentials) => {
    // Aqui simulamos a validação (que no futuro baterá no /auth do Java)
    if (credentials.username === 'admin' && credentials.password === 'admin') {
      localStorage.setItem('token', 'JWT_SNIPER_SECRET_2026');
      setUser({ authenticated: true });
      return true;
    }
    return false;
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
EOF

# 2. REESTRUTURANDO O APP.JSX (O GUARDIÃO DE ROTAS)
echo -e "\033[1;33m[2/3] Instalando a Muralha e o Identity Portal... \033[0m"
cat << 'EOF' > src/App.jsx
import React, { useState, useEffect, useMemo } from 'react';
import api from './api/api';
import LeadCard from './components/LeadCard';
import Stats from './components/Stats';
import { useAuth } from './contexts/AuthContext';
import { LayoutDashboard, LogOut, ShieldCheck, UploadCloud, DownloadCloud, Search, Filter, Loader2, Lock } from 'lucide-react';

export default function App() {
  const { user, login, logout, loading: authLoading } = useAuth();
  const [leads, setLeads] = useState([]);
  const [loading, setLoading] = useState(false);
  const [uploading, setUploading] = useState(false);
  
  // Estados de Login e Filtros
  const [credentials, setCredentials] = useState({ username: '', password: '' });
  const [searchTerm, setSearchTerm] = useState('');
  const [minMargin, setMinMargin] = useState(0);

  useEffect(() => {
    if (user?.authenticated) fetchLeads();
  }, [user]);

  const fetchLeads = async () => {
    setLoading(true);
    try {
      const res = await api.get('/consultor/leads');
      setLeads(res.data);
    } catch (e) { console.error("Falha na extração de dados."); }
    finally { setLoading(false); }
  };

  const filteredLeads = useMemo(() => {
    return leads.filter(lead => {
      const cleanSearch = searchTerm.replace(/\D/g, '');
      const cleanCpf = (lead.cpf || '').replace(/\D/g, '');
      return (lead.nome?.toLowerCase().includes(searchTerm.toLowerCase()) || cleanCpf.includes(cleanSearch)) 
             && (lead.margem || 0) >= minMargin;
    });
  }, [leads, searchTerm, minMargin]);

  const handleUpload = async (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const formData = new FormData();
    formData.append('file', file);
    setUploading(true);
    try {
      await api.post('/admin/leads/importar', formData);
      fetchLeads();
    } catch (err) { alert("ERRO NA MISSÃO."); }
    finally { setUploading(false); }
  };

  if (authLoading) return <div className="h-screen bg-slate-950 flex items-center justify-center text-green-500 font-black italic">SCANNING PERIMETER...</div>;

  // IDENTITY PORTAL (TELA DE LOGIN)
  if (!user?.authenticated) return (
    <div className="flex h-screen items-center justify-center bg-slate-950 font-sans p-4">
      <div className="bg-slate-900 w-full max-w-md p-10 rounded-[2.5rem] border border-slate-800 shadow-2xl relative overflow-hidden">
        <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-transparent via-green-500 to-transparent"></div>
        <div className="text-center mb-10">
          <div className="bg-green-500/10 w-20 h-20 rounded-3xl flex items-center justify-center mx-auto mb-6 border border-green-500/20 shadow-inner">
            <ShieldCheck className="text-green-500" size={40} />
          </div>
          <h1 className="text-white font-black text-4xl tracking-tighter italic">SNIPER FINAL</h1>
          <p className="text-slate-500 text-xs uppercase tracking-[0.3em] mt-2 font-bold">Acesso ao Quartel General</p>
        </div>
        
        <form onSubmit={(e) => { e.preventDefault(); if(!login(credentials)) alert("Acesso Negado!"); }} className="space-y-4">
          <div className="relative">
            <input type="text" placeholder="USUÁRIO" required className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-4 px-6 text-white font-bold focus:border-green-500 focus:outline-none transition-all"
              onChange={e => setCredentials({...credentials, username: e.target.value})} />
          </div>
          <div className="relative">
            <input type="password" placeholder="SENHA" required className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-4 px-6 text-white font-bold focus:border-green-500 focus:outline-none transition-all"
              onChange={e => setCredentials({...credentials, password: e.target.value})} />
          </div>
          <button type="submit" className="w-full bg-green-600 hover:bg-green-500 text-white font-black py-5 rounded-2xl shadow-lg shadow-green-900/20 transition-all uppercase tracking-widest text-sm flex items-center justify-center gap-3">
            <Lock size={18} /> Entrar no Quartel
          </button>
        </form>
      </div>
    </div>
  );

  // DASHBOARD PROTEGIDO (O PERÍMETRO INTERNO)
  return (
    <div className="min-h-screen bg-slate-950 text-slate-200 p-6 font-sans">
      <header className="flex justify-between items-center mb-8 bg-slate-900 p-6 rounded-2xl border border-slate-800 shadow-xl">
        <div className="flex items-center gap-4">
          <LayoutDashboard className="text-green-500" />
          <h2 className="text-xl font-bold uppercase tracking-tighter text-white">Quartel General</h2>
        </div>
        <div className="flex items-center gap-4">
          <label className={`flex items-center gap-2 px-5 py-2.5 rounded-xl font-bold text-xs cursor-pointer transition-all ${uploading ? 'bg-slate-800' : 'bg-green-600 hover:bg-green-500 text-white shadow-lg shadow-green-900/40'}`}>
            {uploading ? <Loader2 className="animate-spin" size={16} /> : <UploadCloud size={16} />}
            {uploading ? "CARREGANDO..." : "IMPORTAR"}
            <input type="file" className="hidden" onChange={handleUpload} accept=".csv" />
          </label>
          <button onClick={async () => {
              const res = await api.get("/admin/leads/exportar", { responseType: "blob" });
              const url = window.URL.createObjectURL(new Blob([res.data]));
              const link = document.createElement("a");
              link.href = url;
              link.setAttribute("download", "vendas_sniper.csv");
              document.body.appendChild(link);
              link.click();
          }} className="flex items-center gap-2 px-5 py-2.5 rounded-xl font-bold text-xs bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-900/40 transition-all">
            <DownloadCloud size={16} /> EXPORTAR
          </button>
          <div className="w-[1px] h-8 bg-slate-800 mx-2"></div>
          <button onClick={logout} className="text-red-500 font-black text-xs uppercase flex items-center gap-2 px-4 py-2 hover:bg-red-500/10 rounded-xl transition-all">
            <LogOut size={16} /> Sair
          </button>
        </div>
      </header>

      <main className="max-w-7xl mx-auto">
        <Stats leads={filteredLeads} />
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500" size={20} />
            <input type="text" placeholder="Buscar Alvo por Nome ou CPF..." className="w-full bg-slate-900 border border-slate-800 rounded-2xl py-4 pl-12 pr-4 text-white font-bold focus:border-green-500 focus:outline-none"
              value={searchTerm} onChange={e => setSearchTerm(e.target.value)} />
          </div>
          <select className="bg-slate-900 border border-slate-800 rounded-2xl py-4 px-6 text-white font-bold focus:border-blue-500 focus:outline-none appearance-none"
            value={minMargin} onChange={e => setMinMargin(Number(e.target.value))}>
            <option value="0">TODAS AS MARGENS</option>
            <option value="2000">ACIMA DE R$ 2.000,00</option>
            <option value="5000">ACIMA DE R$ 5.000,00</option>
          </select>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredLeads.map(lead => (
            <LeadCard key={lead.id} lead={{...lead, name: lead.nome, margin: lead.margem}} 
              onAction={async (id, status) => {
                try {
                  await api.patch(`/consultor/leads/${id}/status?status=${status}`);
                  setLeads(prev => prev.filter(l => l.id !== id));
                } catch (e) { alert("Falha na atualização."); }
              }} 
            />
          ))}
        </div>
      </main>
    </div>
  );
}
EOF

# 3. ENCAPSULANDO O APP COM O PROVIDER (MAIN.JSX)
echo -e "\033[1;33m[3/3] Energizando o AuthProvider no Main... \033[0m"
cat << 'EOF' > src/main.jsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import { AuthProvider } from './contexts/AuthContext'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <AuthProvider>
      <App />
    </AuthProvider>
  </React.StrictMode>,
)
EOF

echo -e "\033[0;32m=============================================================="
echo -e "   PERÍMETRO BLINDADO!                                       "
echo -e "   - Login Elegante: admin / admin (Simulado)                "
echo -e "   - Persistência: OK (LocalStorage gerenciado)              "
echo -e "   - Route Guard: Ativo (O Dashboard agora é restrito)       "
echo -e "==============================================================\033[0m"
