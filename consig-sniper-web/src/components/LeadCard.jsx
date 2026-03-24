import React from 'react';

const LeadCard = ({ lead, onAction }) => {
  const formatMoney = (val) => {
    return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(val);
  };

  const msg = `Olá ${lead.name}, vi que você tem margem de ${formatMoney(lead.margin)} no ${lead.organ}. Podemos falar?`;
  const waUrl = `https://wa.me/55${lead.phone1}?text=${encodeURIComponent(msg)}`;

  return (
    <div className="bg-slate-800 border-l-4 border-green-500 p-5 rounded-xl shadow-2xl hover:bg-slate-750 transition-all">
      <div className="flex justify-between items-start mb-3">
        <span className="text-[10px] bg-blue-600/20 text-blue-400 border border-blue-500/30 px-2 py-1 rounded-md font-black uppercase tracking-widest">
          {lead.organ}
        </span>
        <span className="text-slate-500 text-[10px] font-mono">CPF: {lead.cpf}</span>
      </div>
      
      <h3 className="text-slate-100 font-bold text-lg mb-1 truncate">{lead.name}</h3>
      <div className="text-3xl font-black text-green-400 tracking-tight mb-5">
        {formatMoney(lead.margin)}
      </div>

      <div className="flex flex-col gap-3">
        <a href={waUrl} target="_blank" rel="noreferrer"
           className="bg-green-600 hover:bg-green-500 text-white font-black py-3 rounded-lg text-center text-sm shadow-lg shadow-green-900/20 transition-all">
          DISPARAR WHATSAPP
        </a>
        <div className="flex gap-2">
          <button onClick={() => onAction(lead.id, 'VENDIDO')} 
            className="flex-1 bg-slate-700 hover:bg-blue-600 text-[10px] font-bold text-slate-300 hover:text-white py-2 rounded-md transition-colors">
            💰 VENDIDO
          </button>
          <button onClick={() => onAction(lead.id, 'DESCARTADO')} 
            className="flex-1 bg-slate-700 hover:bg-red-600 text-[10px] font-bold text-slate-300 hover:text-white py-2 rounded-md transition-colors">
            🗑️ DESCARTAR
          </button>
        </div>
      </div>
    </div>
  );
};

export default LeadCard;
