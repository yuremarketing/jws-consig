import React from 'react';
import { Target, CircleDollarSign, BarChart3 } from 'lucide-react';

const Stats = ({ leads }) => {
  const totalLeads = leads.length;
  const totalMargemPendente = leads.reduce((acc, curr) => acc + (curr.margem || 0), 0);
  
  // Formatador de Moeda Padrão Sniper
  const format = (val) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(val);

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div className="bg-slate-900 border border-slate-800 p-6 rounded-3xl shadow-xl">
        <div className="flex justify-between items-start mb-4">
          <p className="text-slate-500 text-xs font-black uppercase tracking-widest">Volume de Fogo</p>
          <Target className="text-slate-600" size={20} />
        </div>
        <h3 className="text-3xl font-black text-white">{totalLeads} <span className="text-sm text-slate-500 font-normal">Leads Ativos</span></h3>
      </div>

      <div className="bg-slate-900 border border-slate-800 p-6 rounded-3xl shadow-xl border-l-4 border-l-green-500">
        <div className="flex justify-between items-start mb-4">
          <p className="text-slate-500 text-xs font-black uppercase tracking-widest">Capital em Campo</p>
          <CircleDollarSign className="text-green-500" size={20} />
        </div>
        <h3 className="text-3xl font-black text-green-500">{format(totalMargemPendente)}</h3>
      </div>

      <div className="bg-slate-900 border border-slate-800 p-6 rounded-3xl shadow-xl">
        <div className="flex justify-between items-start mb-4">
          <p className="text-slate-500 text-xs font-black uppercase tracking-widest">Ticket Médio</p>
          <BarChart3 className="text-blue-500" size={20} />
        </div>
        <h3 className="text-3xl font-black text-blue-500">
          {format(totalLeads > 0 ? totalMargemPendente / totalLeads : 0)}
        </h3>
      </div>
    </div>
  );
};

export default Stats;
