import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Team from './pages/Team'; // <--- Importamos a página nova

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/team" element={<Team />} /> {/* <--- Nova Rota */}
      </Routes>
    </BrowserRouter>
  );
}

export default App;
