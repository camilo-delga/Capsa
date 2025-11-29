'use client';

import { useState, useEffect, useCallback } from 'react';

export function useTareas(materiaId = null) {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchTareas = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const url = materiaId
        ? `/api/tareas?materia_id=${materiaId}`
        : '/api/tareas';

      const response = await fetch(url);
      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al cargar tareas');
      }

      setData(result.data || []);
    } catch (err) {
      setError(err.message);
      console.error('Error en useTareas:', err);
    } finally {
      setLoading(false);
    }
  }, [materiaId]);

  useEffect(() => {
    fetchTareas();
  }, [fetchTareas]);

  const createTarea = async (tareaData) => {
    try {
      const response = await fetch('/api/tareas', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(tareaData),
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al crear tarea');
      }

      await fetchTareas(); // Refresh data
      return result.data;
    } catch (err) {
      console.error('Error al crear tarea:', err);
      throw err;
    }
  };

  return {
    data,
    loading,
    error,
    refresh: fetchTareas,
    createTarea,
  };
}
