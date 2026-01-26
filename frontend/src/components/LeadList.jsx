import React from 'react';
import { Phone, DollarSign } from 'lucide-react';

export default function LeadList({ leads }) {
  
  if (!leads || leads.length === 0) {
    return (
      <div style={{ padding: '3rem', textAlign: 'center', background: '#1e293b', borderRadius: '12px', border: '1px dashed #475569' }}>
        <p style={{ color: '#94a3b8', fontSize: '1.1rem' }}>Sua carteira está vazia no momento.</p>
        <p style={{ color: '#64748b', fontSize: '0.9rem' }}>Aguarde o gestor distribuir novos leads.</p>
      </div>
    );
  }

  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: '1.5rem' }}>
      {leads.map((lead) => (
        <div key={lead.id} style={{ background: '#1e293b', padding: '1.5rem', borderRadius: '12px', border: '1px solid #334155', position: 'relative', overflow: 'hidden', boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)' }}>
          
          {/* Faixa lateral colorida baseada no status */}
          <div style={{ position: 'absolute', top: 0, left: 0, width: '4px', height: '100%', background: '#38bdf8' }}></div>
          
          <h3 style={{ fontSize: '1.2rem', marginBottom: '0.5rem', color: 'white', fontWeight: '600' }}>{lead.nome}</h3>
          <p style={{ color: '#94a3b8', fontSize: '0.9rem', marginBottom: '1.5rem', fontFamily: 'monospace' }}>CPF: {lead.cpf}</p>
          
          <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
             <div style={{ display: 'flex', alignItems: 'center', gap: '10px', color: '#cbd5e1', background: '#0f172a', padding: '8px', borderRadius: '6px' }}>
                <Phone size={16} color="#38bdf8" /> 
                <span>{lead.telefone}</span>
             </div>
             <div style={{ display: 'flex', alignItems: 'center', gap: '10px', color: '#cbd5e1', background: '#0f172a', padding: '8px', borderRadius: '6px' }}>
                <DollarSign size={16} color="#10b981" /> 
                <span>Margem: <b style={{color: '#10b981'}}>R$ {lead.margem}</b></span>
             </div>
          </div>

          <button style={{ marginTop: '1.5rem', width: '100%', padding: '12px', background: '#38bdf8', color: '#0f172a', border: 'none', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer', transition: 'filter 0.2s' }}>
            ABRIR FICHA
          </button>
        </div>
      ))}
    </div>
  );
}
