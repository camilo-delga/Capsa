-- ============================================
-- SCHEMA COMPLETO PARA SUPABASE
-- Copiar y pegar en: Supabase → SQL Editor → Run
-- ============================================

-- 1. TABLA USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('alumno', 'docente', 'delegado', 'administrador')),
  avatar_url TEXT,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. TABLA MATERIAS
CREATE TABLE IF NOT EXISTS materias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  descripcion TEXT,
  portada_url TEXT,
  profesor_id UUID REFERENCES usuarios(id),
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. TABLA TAREAS
CREATE TABLE IF NOT EXISTS tareas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  materia_id UUID REFERENCES materias(id) ON DELETE CASCADE,
  titulo TEXT NOT NULL,
  descripcion TEXT,
  fecha_limite TIMESTAMP WITH TIME ZONE,
  archivo_url TEXT,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. TABLA MENSAJES
CREATE TABLE IF NOT EXISTS mensajes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  emisor UUID REFERENCES usuarios(id),
  receptor UUID REFERENCES usuarios(id),
  contenido TEXT NOT NULL,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. TABLA NOTICIAS
CREATE TABLE IF NOT EXISTS noticias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo TEXT NOT NULL,
  cuerpo TEXT NOT NULL,
  categoria TEXT DEFAULT 'general',
  portada_url TEXT,
  autor_id UUID REFERENCES usuarios(id),
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- ÍNDICES PARA MEJORAR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_tareas_materia ON tareas(materia_id);
CREATE INDEX IF NOT EXISTS idx_mensajes_emisor ON mensajes(emisor);
CREATE INDEX IF NOT EXISTS idx_mensajes_receptor ON mensajes(receptor);
CREATE INDEX IF NOT EXISTS idx_noticias_fecha ON noticias(creado_en DESC);

-- ============================================
-- ROW LEVEL SECURITY (RLS) - OPCIONAL
-- Descomentar si quieres seguridad a nivel de fila
-- ============================================

-- ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE materias ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE tareas ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE mensajes ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE noticias ENABLE ROW LEVEL SECURITY;

-- ============================================
-- FIN DEL SCHEMA
-- ============================================
