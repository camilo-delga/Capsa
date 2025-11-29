'use client';

import { useState, useEffect, useCallback } from 'react';

export function useMensajes(usuarioId = null) {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchMensajes = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const url = usuarioId
        ? `/api/mensajes?usuario_id=${usuarioId}`
        : '/api/mensajes';

      const response = await fetch(url);
      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al cargar mensajes');
      }

      setData(result.data || []);
    } catch (err) {
      setError(err.message);
      console.error('Error en useMensajes:', err);
    } finally {
      setLoading(false);
    }
  }, [usuarioId]);

  useEffect(() => {
    fetchMensajes();
  }, [fetchMensajes]);

  const sendMensaje = async (mensajeData) => {
    try {
      const response = await fetch('/api/mensajes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(mensajeData),
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al enviar mensaje');
      }

      await fetchMensajes(); // Refresh data
      return result.data;
    } catch (err) {
      console.error('Error al enviar mensaje:', err);
      throw err;
    }
  };

  return {
    data,
    loading,
    error,
    refresh: fetchMensajes,
    sendMensaje,
  };
}
