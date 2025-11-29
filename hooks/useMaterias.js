'use client';

import { useState, useEffect, useCallback } from 'react';

export function useMaterias() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchMaterias = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const response = await fetch('/api/materias');
      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al cargar materias');
      }

      setData(result.data || []);
    } catch (err) {
      setError(err.message);
      console.error('Error en useMaterias:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchMaterias();
  }, [fetchMaterias]);

  const createMateria = async (materiaData) => {
    try {
      const response = await fetch('/api/materias', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(materiaData),
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Error al crear materia');
      }

      await fetchMaterias(); // Refresh data
      return result.data;
    } catch (err) {
      console.error('Error al crear materia:', err);
      throw err;
    }
  };

  return {
    data,
    loading,
    error,
    refresh: fetchMaterias,
    createMateria,
  };
}
