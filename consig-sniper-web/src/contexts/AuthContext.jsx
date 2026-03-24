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
