import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
});

// Toda vez que fizermos uma requisição, verifique se temos um token salvo
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
