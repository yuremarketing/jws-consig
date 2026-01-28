import React, { useState, useEffect, useMemo, createContext, useContext } from 'react';
import { 
  Users, Upload, BarChart3, Bell, Search, Filter, 
  Eye, EyeOff, Phone, Calendar, CheckCircle, 
  AlertTriangle, LogOut, ChevronRight, Save, 
  MoreVertical, RefreshCw, Shield, DollarSign,
  Briefcase, TrendingUp, Activity, MessageCircle,
  Trophy, Clock
} from 'lucide-react';

const formatMoney = (v) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v);
const maskCPF = (c) => c.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, "***.$2.$3-**");

const INITIAL_USERS = [
  { id: 1, name: 'Roberto Diretor', cpf: '00000000000', role: 'ADMIN', active: true, avatar: 'RD' },
  { id: 2, name: 'Ana Consultora', cpf: '11111111111', role: 'CONSULTOR', active: true, avatar: 'AC' },
];

const INITIAL_LEADS = Array.from({ length: 25 }).map((_, i) => ({
  id: `L${1000 + i}`,
  cpf: `${Math.floor(Math.random() * 999)}.${Math.floor(Math.random() * 999)}.${Math.floor(Math.random() * 999)}-${Math.floor(Math.random() * 99)}`,
  name: i % 2 === 0 ? `Servidor Público ${i + 1}` : `Pensionista INSS ${i + 1}`,
  org: i % 3 === 0 ? 'SIAPE' : i % 2 === 0 ? 'INSS' : 'GOV SP',
  margin: Math.random() * 3000 + 200,
  salary: Math.random() * 12000 + 3500,
  phone: `55119${Math.floor(Math.random() * 90000000 + 10000000)}`,
  status: i % 6 === 0 ? 'Fechado' : i % 4 === 0 ? 'Agendado' : 'Novo',
  ownerId: i < 8 ? 2 : i < 15 ? 3 : null,
  lastUpdate: new Date().toISOString(),
  history: i % 4 === 0 ? [{ date: new Date().toISOString(), note: 'Oportunidade de margem identificada.', author: 'Sistema Sniper' }] : []
}));

const AppContext = createContext();

export const AppProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [users] = useState(INITIAL_USERS);
  const [leads, setLeads] = useState(() => JSON.parse(localStorage.getItem('cs_leads_v6_elite')) || INITIAL_LEADS);
  const [privacyMode, setPrivacyMode] = useState(true);
  const [notifications, setNotifications] = useState([]);

  useEffect(() => { localStorage.setItem('cs_leads_v6_elite', JSON.stringify(leads)); }, [leads]);

  const login = (cpf, pass) => {
    const found = users.find(u => u.cpf === cpf.replace(/\D/g, ''));
    if (found) { setUser(found); return true; }
    return false;
  };

  const updateLead = (id, updates, note) => {
    setLeads(prev => prev.map(l => l.id === id ? { 
      ...l, ...updates, 
      history: note ? [{ date: new Date().toISOString(), note, author: user?.name || 'Sistema' }, ...l.history] : l.history,
      lastUpdate: new Date().toISOString()
    } : l));
  };

  const distributeLeads = (ids, targetId) => {
    setLeads(prev => prev.map(l => ids.includes(l.id) ? { ...l, ownerId: targetId, status: 'Novo' } : l));
  };

  return (
    <AppContext.Provider value={{ user, setUser, leads, users, privacyMode, setPrivacyMode, notifications, login, updateLead, distributeLeads }}>
      {children}
    </AppContext.Provider>
  );
};

const Card = ({ children, className = "" }) => <div className={`bg-slate-900/40 border border-slate-800 rounded-2xl shadow-2xl backdrop-blur-md ${className}`}>{children}</div>;

const Button = ({ children, onClick, variant = 'primary', className = "", disabled = false, icon: IconComponent }) => {
  const styles = {
    primary: "bg-amber-500 hover:bg-amber-600 text-slate-950 shadow-[0_0_20px_rgba(245,158,11,0.2)]",
    secondary: "bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700",
    neon: "bg-cyan-600 hover:bg-cyan-500 text-white shadow-[0_0_15px_#06b6d4]",
    whatsapp: "bg-emerald-600 hover:bg-emerald-500 text-white shadow-[0_0_15px_#10b981]"
  };
  return <button onClick={onClick} disabled={disabled} className={`flex items-center justify-center px-4 py-2 rounded-xl font-black transition-all active:scale-95 disabled:opacity-50 ${styles[variant]} ${className}`}>{IconComponent && <IconComponent size={18} className="mr-2" />}{children}</button>;
};

const Badge = ({ status }) => {
  const cfg = { 'Novo': 'text-blue-400 border-blue-400/30 bg-blue-400/5', 'Agendado': 'text-amber-400 border-amber-400/30 bg-amber-400/5', 'Fechado': 'text-emerald-400 border-emerald-400/30 bg-emerald-400/5' };
  return <span className={`px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-wider border ${cfg[status] || 'text-slate-400 border-slate-700 bg-slate-800'}`}>{status}</span>;
};

const LoginScreen = () => {
  const { login } = useContext(AppContext);
  const [cpf, setCpf] = useState('');
  const [pass, setPass] = useState('');
  const [error, setError] = useState('');
  const handleSubmit = (e) => { e.preventDefault(); if (!login(cpf, pass)) setError('Credenciais inválidas.'); };
  return (
    <div className="min-h-screen bg-[#020617] flex items-center justify-center p-4 relative">
      <Card className="w-full max-w-md p-10 border-t-4 border-t-amber-500">
        <div className="text-center mb-10"><div className="w-16 h-16 bg-amber-500 rounded-2xl flex items-center justify-center text-slate-950 font-black text-3xl mx-auto mb-4">CS</div><h1 className="text-3xl font-black text-white tracking-tighter uppercase">CONSIG<span className="text-amber-500">SNIPER</span></h1><p className="text-slate-500 text-xs mt-2 uppercase tracking-[0.3em] font-bold">Elite Terminal v6.1</p></div>
        <form onSubmit={handleSubmit} className="space-y-6">
          <div><label className="block text-slate-500 text-[10px] uppercase font-black mb-2 tracking-widest">CPF</label><input placeholder="000.000.000-00" className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-3 text-white focus:border-amber-500 outline-none" value={cpf} onChange={e=>setCpf(e.target.value)} /></div>
          <div><label className="block text-slate-500 text-[10px] uppercase font-black mb-2 tracking-widest">SENHA</label><input type="password" placeholder="••••••••" className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-3 text-white focus:border-amber-500 outline-none" value={pass} onChange={e=>setPass(e.target.value)} /></div>
          {error && <div className="text-red-400 text-xs bg-red-500/10 p-3 rounded-lg border border-red-500/20">{error}</div>}
          <Button type="submit" className="w-full py-4 text-lg">EFETUAR ACESSO</Button>
        </form>
      </Card>
    </div>
  );
};

const LeadModal = ({ lead, onClose }) => {
  const { updateLead, privacyMode, user } = useContext(AppContext);
  const [note, setNote] = useState('');
  const [status, setStatus] = useState(lead.status);
  const handleZap = () => {
    const msg = `Olá *${lead.name.split(' ')[0]}*, sou ${user?.name} da JwsConsig.`;
    window.open(`https://wa.me/${lead.phone}?text=${encodeURIComponent(msg)}`, '_blank');
    updateLead(lead.id, { status: 'Agendado' }, 'Iniciou WhatsApp Sniper.');
  };
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/95 backdrop-blur-md p-4 animate-in zoom-in duration-300">
      <Card className="w-full max-w-5xl max-h-[95vh] overflow-hidden border-cyan-500/20 text-slate-200">
        <div className="p-8 border-b border-slate-800 flex justify-between bg-slate-900/50">
          <div><h2 className="text-3xl font-black text-white tracking-tighter uppercase">{lead.name} <Badge status={status}/></h2><p className="text-slate-500 font-mono text-xs mt-2 uppercase tracking-widest">{maskCPF(lead.cpf)} • {lead.org}</p></div>
          <button onClick={onClose} className="text-slate-500 hover:text-white"><LogOut size={28} /></button>
        </div>
        <div className="p-8 grid grid-cols-1 lg:grid-cols-3 gap-10 overflow-y-auto max-h-[calc(95vh-150px)]">
          <div className="space-y-6">
            <div className="bg-slate-950 p-6 rounded-2xl border border-slate-800 shadow-inner group">
               <span className="text-amber-500 text-[10px] font-black uppercase tracking-widest block mb-2">Margem de Tiro</span>
               <div className="text-4xl font-black text-emerald-400 font-mono tracking-tighter mb-4">{privacyMode ? 'R$ *****' : formatMoney(lead.margin)}</div>
               <div className="text-[10px] text-slate-600 font-bold uppercase">Rendimento: {privacyMode ? '****' : formatMoney(lead.salary)}</div>
            </div>
            <Button onClick={handleZap} variant="whatsapp" className="w-full py-5 text-xl rounded-2xl" icon={MessageCircle}>ABRIR ZAP SNIPER</Button>
          </div>
          <div className="lg:col-span-2 space-y-6">
            <div className="bg-slate-950 p-6 rounded-2xl border border-slate-800 h-[300px] overflow-y-auto">
               <h4 className="text-slate-500 text-[10px] font-black uppercase mb-6 sticky top-0 bg-slate-950 pb-4 border-b border-slate-800/50 flex items-center gap-2"><Activity size={14}/> LOG OPERACIONAL</h4>
               {lead.history.map((h, i) => (
                 <div key={i} className="mb-6 flex gap-4 text-sm relative"><div className="w-1 bg-cyan-500/20 rounded-full"></div><div className="flex-1"><div className="flex justify-between items-center mb-1"><span className="text-slate-200 font-black uppercase text-[11px]">{h.author}</span><span className="text-slate-600 font-mono text-[10px]">{new Date(h.date).toLocaleString()}</span></div><p className="text-slate-500 leading-relaxed bg-slate-900/30 p-3 rounded-xl border border-slate-800/50">{h.note}</p></div></div>
               ))}
            </div>
            <textarea className="w-full bg-slate-950 border border-slate-800 rounded-2xl p-5 text-slate-200 text-sm focus:border-cyan-500 outline-none" placeholder="Notas da negociação..." value={note} onChange={e=>setNote(e.target.value)} />
            <div className="flex justify-end"><Button onClick={()=>{updateLead(lead.id, {status}, note); onClose();}} icon={Save}>CONFIRMAR</Button></div>
          </div>
        </div>
      </Card>
    </div>
  );
};

const AdminDashboard = () => {
  const { leads, users, distributeLeads, privacyMode } = useContext(AppContext);
  const [activeTab, setActiveTab] = useState('metrics');
  const [selectedLeads, setSelectedLeads] = useState([]);
  const [targetUser, setTargetUser] = useState('');

  const stats = useMemo(() => ({
    total: leads.length,
    pool: leads.filter(l => !l.ownerId).length,
    conv: Math.floor((leads.filter(l => l.status === 'Fechado').length / (leads.length || 1)) * 100),
    margin: leads.reduce((acc, l) => acc + l.margin, 0)
  }), [leads]);

  const ranking = useMemo(() => {
    return users.filter(u => u.role === 'CONSULTOR').map(u => ({
      ...u,
      sold: leads.filter(l => l.ownerId === u.id && l.status === 'Fechado').reduce((a, l) => a + l.margin, 0)
    })).sort((a, b) => b.sold - a.sold);
  }, [leads, users]);

  return (
    <div className="space-y-10 animate-in fade-in slide-in-from-top-4 duration-1000">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        {[
          {l: 'Base Total', v: stats.total, c: 'border-cyan-500', ic: Users},
          {l: 'Pool Sniper', v: stats.pool, c: 'border-amber-500', ic: Briefcase},
          {l: 'Conversão Real', v: `${stats.conv}%`, c: 'border-emerald-500', ic: TrendingUp},
          {l: 'Pipeline Bruto', v: privacyMode ? '*****' : formatMoney(stats.margin), c: 'border-purple-500', ic: DollarSign},
        ].map((s, i) => {
          const Icon = s.ic;
          return (
            <Card key={i} className={`p-6 border-l-4 ${s.c} group hover:translate-y-[-4px] transition-all`}>
              <div className="flex justify-between items-start mb-3"><span className="text-[10px] text-slate-500 font-black uppercase tracking-widest">{s.l}</span><Icon size={16} className="text-slate-700"/></div>
              <div className="text-3xl font-black text-white font-mono tracking-tighter">{s.v}</div>
            </Card>
          );
        })}
      </div>

      <div className="flex border-b border-slate-800 space-x-12">
        {['Métricas Elite', 'Distribuição'].map(t => <button key={t} onClick={()=>setActiveTab(t === 'Distribuição' ? 'dist' : 'metrics')} className={`pb-5 text-[11px] font-black uppercase tracking-widest relative ${activeTab === (t === 'Distribuição' ? 'dist' : 'metrics') ? 'text-amber-500' : 'text-slate-600 hover:text-slate-400'}`}>{t}{activeTab === (t === 'Distribuição' ? 'dist' : 'metrics') && <div className="absolute bottom-0 left-0 right-0 h-1 bg-amber-500 shadow-[0_0_10px_#f59e0b]"></div>}</button>)}
      </div>

      {activeTab === 'metrics' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
           <Card className="p-8"><h3 className="text-white font-black text-sm uppercase tracking-widest mb-10 flex items-center gap-3"><BarChart3 size={20} className="text-cyan-400"/> Saúde da Base</h3>
              <div className="space-y-8">{['Novo', 'Agendado', 'Fechado'].map(s => { const count = leads.filter(l => l.status === s).length; const per = (count / (leads.length || 1)) * 100; return (<div key={s} className="space-y-2"><div className="flex justify-between text-[10px] text-slate-400 font-black uppercase tracking-tighter"><span>{s}</span><span>{count} Unidades</span></div><div className="h-3 bg-slate-950 rounded-full overflow-hidden p-0.5 border border-slate-800"><div className="h-full bg-cyan-500 shadow-[0_0_12px_#06b6d4]" style={{ width: `${per}%` }}></div></div></div>); })}</div>
           </Card>
           <Card className="p-8"><h3 className="text-white font-black text-sm uppercase tracking-widest mb-10 flex items-center gap-3"><Trophy size={20} className="text-amber-400"/> Ranking de Vendas</h3>
              <div className="space-y-5">{ranking.map((u, i) => (<div key={u.id} className="flex justify-between items-center p-4 bg-slate-950/50 rounded-2xl border border-slate-800/50 group hover:border-amber-500/40 transition-all"><div className="flex items-center gap-4"><div className={`w-10 h-10 rounded-xl flex items-center justify-center font-black ${i===0 ? 'bg-amber-500 text-slate-950' : 'bg-slate-900 text-slate-600'}`}>{i+1}</div><span className="text-sm font-black text-slate-200 uppercase tracking-tighter">{u.name}</span></div><div className="text-right text-emerald-400 font-mono font-black text-sm">{privacyMode ? '*****' : formatMoney(u.sold)}</div></div>))}</div>
           </Card>
        </div>
      )}

      {activeTab === 'dist' && (
        <Card className="overflow-hidden border-cyan-500/10">
          <div className="p-6 bg-slate-900/80 border-b border-slate-800 flex justify-between items-center"><h3 className="text-white font-black text-sm uppercase tracking-widest">Leads em Aberto: {leads.filter(l=>!l.ownerId).length}</h3>
            <div className="flex gap-4"><select className="bg-slate-950 border border-slate-800 text-white text-xs rounded-xl px-4 py-2 outline-none focus:border-cyan-500" value={targetUser} onChange={e=>setTargetUser(e.target.value)}><option value="">DESTINATÁRIO...</option>{users.filter(u=>u.role==='CONSULTOR').map(u=><option key={u.id} value={u.id}>{u.name}</option>)}</select><Button variant="neon" className="uppercase tracking-widest text-[9px]" onClick={()=>{distributeLeads(selectedLeads, parseInt(targetUser)); setSelectedLeads([]);}} disabled={!selectedLeads.length || !targetUser}>EXECUTAR DISTRIBUIÇÃO</Button></div>
          </div>
          <div className="max-h-[400px] overflow-y-auto">
            <table className="w-full text-left text-xs border-collapse">
              <thead className="bg-slate-950 sticky top-0"><tr className="text-slate-600 uppercase font-black tracking-widest border-b border-slate-800"><th className="p-6 w-10"><input type="checkbox" className="accent-cyan-500 w-4 h-4" onChange={e=>setSelectedLeads(e.target.checked ? leads.filter(l=>!l.ownerId).map(l=>l.id) : [])}/></th><th className="p-6">Identificação</th><th className="p-6 text-right">Margem Sniper</th></tr></thead>
              <tbody className="divide-y divide-slate-800/40">{leads.filter(l=>!l.ownerId).map(l => (<tr key={l.id} className="hover:bg-cyan-500/5 transition-all group"><td className="p-6"><input type="checkbox" checked={selectedLeads.includes(l.id)} className="accent-cyan-500 w-4 h-4" onChange={e=>setSelectedLeads(e.target.checked ? [...selectedLeads, l.id] : selectedLeads.filter(id=>id!==l.id))}/></td><td className="p-6"><div className="text-slate-200 font-black uppercase text-sm tracking-tighter group-hover:text-cyan-400 transition-colors">{l.name}</div><div className="text-slate-600 font-mono text-[10px]">{maskCPF(l.cpf)}</div></td><td className="p-6 text-right text-emerald-400 font-mono font-black text-sm">{privacyMode ? 'R$ *****' : formatMoney(l.margin)}</td></tr>))}</tbody>
            </table>
          </div>
        </Card>
      )}
    </div>
  );
};

const ConsultantWorkspace = () => {
  const { user, leads, privacyMode, updateLead } = useContext(AppContext);
  const [filter, setFilter] = useState('');
  const [selected, setSelected] = useState(null);
  const myLeads = useMemo(() => leads.filter(l => l.ownerId === user?.id && (l.name.toLowerCase().includes(filter.toLowerCase()) || l.cpf.includes(filter))), [leads, user?.id, filter]);
  const handleQuickZap = (l, e) => { e.stopPropagation(); window.open(`https://wa.me/${l.phone}?text=Olá ${l.name.split(' ')[0]}, sou ${user?.name} da JwsConsig.`, '_blank'); updateLead(l.id, { status: 'Agendado' }, 'WhatsApp Rápido.'); };
  return (
    <div className="space-y-8 animate-in slide-in-from-bottom-8 duration-1000">
      <div className="flex flex-col lg:flex-row justify-between items-center gap-6 bg-slate-900/60 p-6 rounded-3xl border border-slate-800 shadow-2xl">
         <div className="relative flex-1 w-full max-w-xl"><Search className="absolute left-5 top-4 text-slate-700" size={20}/><input placeholder="PESQUISAR CLIENTE..." className="w-full bg-slate-950 border border-slate-800 rounded-2xl pl-14 pr-6 py-4 text-sm text-white focus:border-cyan-500 outline-none" value={filter} onChange={e=>setFilter(e.target.value)} /></div>
         <div className="px-8 py-4 bg-slate-950 border border-slate-800 rounded-2xl text-[10px] font-black uppercase tracking-widest text-slate-200">Carteira: <span className="text-amber-500 ml-2">{myLeads.length} Alvos</span></div>
      </div>
      <Card className="overflow-hidden min-h-[600px] text-slate-200">
        <table className="w-full text-left text-sm border-collapse"><thead className="bg-slate-950/90"><tr className="text-[9px] text-slate-600 uppercase font-black tracking-widest border-b border-slate-800/50"><th className="p-8">Alvo</th><th className="p-8 text-center">Status</th><th className="p-8 text-right">Margem</th><th className="p-8 text-center">Sniper</th></tr></thead>
          <tbody className="divide-y divide-slate-800/40">{myLeads.map(l => (<tr key={l.id} className="hover:bg-slate-800/40 cursor-pointer group" onClick={()=>setSelected(l)}><td className="p-8"><div className="font-black text-slate-200 uppercase tracking-tighter">{l.name}</div><div className="text-[10px] text-slate-600 font-mono uppercase tracking-widest">{maskCPF(l.cpf)} • {l.org}</div></td><td className="p-8 text-center"><Badge status={l.status}/></td><td className="p-8 text-right font-mono font-black text-emerald-400">{privacyMode ? '*****' : formatMoney(l.margin)}</td><td className="p-8"><div className="flex justify-center gap-3"><button onClick={e=>handleQuickZap(l,e)} className="p-3 text-emerald-500 bg-emerald-500/5 rounded-2xl hover:bg-emerald-500 hover:text-slate-950 transition-all shadow-xl active:scale-90"><MessageCircle size={22}/></button><button className="p-3 text-slate-700 border border-slate-800 rounded-2xl group-hover:text-cyan-400 transition-all"><ChevronRight size={22}/></button></div></td></tr>))}</tbody>
        </table>
      </Card>
      {selected && <LeadModal lead={selected} onClose={()=>setSelected(null)}/>}
    </div>
  );
};

const MainLayout = () => {
  const { user, setUser, privacyMode, setPrivacyMode, notifications } = useContext(AppContext);
  if (!user) return <LoginScreen />;
  return (
    <div className="min-h-screen bg-[#020617] text-slate-200 font-sans selection:bg-cyan-500/30">
      <header className="h-20 bg-slate-900/40 backdrop-blur-2xl border-b border-slate-800/50 flex items-center justify-between px-10 sticky top-0 z-40 shadow-2xl">
        <div className="flex items-center gap-5"><div className="w-12 h-12 bg-amber-500 rounded-2xl flex items-center justify-center text-slate-950 font-black text-xl shadow-[0_0_30px_#f59e0b44]">CS</div><div className="hidden lg:block border-l border-slate-800 pl-5"><span className="font-black text-2xl tracking-tighter text-white uppercase tracking-tight">CONSIG<span className="text-amber-500">SNIPER</span></span></div></div>
        <div className="flex items-center gap-10">
          <button onClick={()=>setPrivacyMode(!privacyMode)} className={`p-3 transition-all rounded-2xl border ${privacyMode ? 'text-slate-600 border-slate-800 hover:text-cyan-400' : 'text-cyan-400 bg-cyan-400/5 border-cyan-400/20 shadow-[0_0_15px_#06b6d433]'}`}>{privacyMode ? <EyeOff size={24}/> : <Eye size={24}/>}</button>
          <div className="relative cursor-pointer p-2"><Bell size={24} className="text-slate-600 group-hover:text-amber-500 transition-colors"/>{notifications.length > 0 && <span className="absolute top-1 right-1 w-3 h-3 bg-red-600 rounded-full border-2 border-slate-950 animate-bounce flex items-center justify-center text-[8px] font-black text-white">{notifications.length}</span>}</div>
          <div className="flex items-center gap-5 pl-8 border-l border-slate-800/80 text-right hidden sm:block">
            <div className="text-[10px] font-black text-white uppercase leading-none mb-1 uppercase tracking-widest">{user.name}</div>
            <div className="text-[9px] text-slate-600 font-black uppercase tracking-[0.25em]">{user.role} TERMINAL</div>
          </div>
          <button onClick={()=>setUser(null)} className="p-3 bg-slate-950 border border-slate-800 rounded-2xl text-red-500 hover:bg-red-500/10 transition-all active:scale-90 shadow-2xl"><LogOut size={20}/></button>
        </div>
      </header>
      <main className="p-6 md:p-12 max-w-[1600px] mx-auto pb-40">{user.role === 'ADMIN' ? <AdminDashboard /> : <ConsultantWorkspace />}</main>
      <footer className="fixed bottom-0 left-0 right-0 h-12 bg-slate-900/60 backdrop-blur-xl border-t border-slate-800/50 px-10 flex items-center justify-between z-40 text-[10px] font-black text-slate-600 uppercase tracking-widest"><div><span className="text-cyan-500 mr-2">●</span> OPERAÇÃO ONLINE</div><div>Consig-Sniper Elite v6.1</div></footer>
    </div>
  );
};

export default function App() {
  return (
    <AppProvider>
      <MainLayout />
    </AppProvider>
  );
}
