'use client';

import { useState, useEffect, useCallback } from 'react';

export function useNoticias(categoria = null) {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchNoticias = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const url = categoria
        ? `/api/noticias?categoria=${categoria}`
        : '/api/noticias';

      const response = await fetch(url);
      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al cargar noticias');
      }

      setData(result.data || []);
    } catch (err) {
      setError(err.message);
      console.error('Error en useNoticias:', err);
    } finally {
      setLoading(false);
    }
  }, [categoria]);

  useEffect(() => {
    fetchNoticias();
  }, [fetchNoticias]);

  const createNoticia = async (noticiaData) => {
    try {
      const response = await fetch('/api/noticias', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(noticiaData),
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al crear noticia');
      }

      await fetchNoticias(); // Refresh data
      return result.data;
    } catch (err) {
      console.error('Error al crear noticia:', err);
      throw err;
    }
  };

  return {
    data,
    loading,
    error,
    refresh: fetchNoticias,
    createNoticia,
  };
}
