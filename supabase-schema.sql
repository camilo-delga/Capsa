-- =====================================================
-- SCHEMA SUPABASE - CAPSA
-- =====================================================
-- Este archivo contiene el schema completo de la base de datos
-- Ejecutar en: Supabase Dashboard → SQL Editor → New Query
-- =====================================================

-- Habilitar extensión UUID (si no está habilitada)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLA: users (usuarios)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255),
  rol VARCHAR(50) DEFAULT 'estudiante' CHECK (rol IN ('estudiante', 'profesor', 'admin')),
  avatar_url TEXT,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABLA: materias
-- =====================================================
CREATE TABLE IF NOT EXISTS materias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  profesor_id UUID REFERENCES users(id) ON DELETE SET NULL,
  codigo VARCHAR(50) UNIQUE,
  portada_url TEXT,
  color VARCHAR(7) DEFAULT '#3B82F6',
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABLA: tareas
-- =====================================================
CREATE TABLE IF NOT EXISTS tareas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  materia_id UUID REFERENCES materias(id) ON DELETE CASCADE NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  descripcion TEXT,
  fecha_limite TIMESTAMP WITH TIME ZONE,
  archivo_url TEXT,
  creado_por UUID REFERENCES users(id) ON DELETE SET NULL,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABLA: tareas_entregas
-- =====================================================
CREATE TABLE IF NOT EXISTS tareas_entregas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tarea_id UUID REFERENCES tareas(id) ON DELETE CASCADE NOT NULL,
  estudiante_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  archivo_url TEXT,
  comentario TEXT,
  calificacion DECIMAL(5,2),
  estado VARCHAR(50) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'entregada', 'calificada', 'tarde')),
  fecha_entrega TIMESTAMP WITH TIME ZONE,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(tarea_id, estudiante_id)
);

-- =====================================================
-- TABLA: mensajes
-- =====================================================
CREATE TABLE IF NOT EXISTS mensajes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  emisor UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  receptor UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  contenido TEXT NOT NULL,
  leido BOOLEAN DEFAULT FALSE,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABLA: noticias
-- =====================================================
CREATE TABLE IF NOT EXISTS noticias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo VARCHAR(255) NOT NULL,
  cuerpo TEXT NOT NULL,
  categoria VARCHAR(100) DEFAULT 'general',
  portada_url TEXT,
  autor_id UUID REFERENCES users(id) ON DELETE SET NULL,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- ÍNDICES para mejorar performance
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_tareas_materia ON tareas(materia_id);
CREATE INDEX IF NOT EXISTS idx_tareas_fecha_limite ON tareas(fecha_limite);
CREATE INDEX IF NOT EXISTS idx_entregas_tarea ON tareas_entregas(tarea_id);
CREATE INDEX IF NOT EXISTS idx_entregas_estudiante ON tareas_entregas(estudiante_id);
CREATE INDEX IF NOT EXISTS idx_mensajes_emisor ON mensajes(emisor);
CREATE INDEX IF NOT EXISTS idx_mensajes_receptor ON mensajes(receptor);
CREATE INDEX IF NOT EXISTS idx_noticias_categoria ON noticias(categoria);
CREATE INDEX IF NOT EXISTS idx_noticias_creado_en ON noticias(creado_en DESC);

-- =====================================================
-- TRIGGERS para actualizar "actualizado_en"
-- =====================================================
CREATE OR REPLACE FUNCTION update_actualizado_en()
RETURNS TRIGGER AS $$
BEGIN
  NEW.actualizado_en = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_actualizado_en
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_actualizado_en();

CREATE TRIGGER update_materias_actualizado_en
  BEFORE UPDATE ON materias
  FOR EACH ROW
  EXECUTE FUNCTION update_actualizado_en();

CREATE TRIGGER update_tareas_actualizado_en
  BEFORE UPDATE ON tareas
  FOR EACH ROW
  EXECUTE FUNCTION update_actualizado_en();

CREATE TRIGGER update_entregas_actualizado_en
  BEFORE UPDATE ON tareas_entregas
  FOR EACH ROW
  EXECUTE FUNCTION update_actualizado_en();

CREATE TRIGGER update_noticias_actualizado_en
  BEFORE UPDATE ON noticias
  FOR EACH ROW
  EXECUTE FUNCTION update_actualizado_en();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) - OPCIONAL
-- =====================================================
-- Descomentar si deseas habilitar RLS
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE materias ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE tareas ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE tareas_entregas ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE mensajes ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE noticias ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- DATOS DE EJEMPLO (OPCIONAL)
-- =====================================================
-- Descomentar para insertar datos de prueba
-- INSERT INTO users (nombre, email, rol) VALUES
--   ('Juan Pérez', 'juan@example.com', 'estudiante'),
--   ('María García', 'maria@example.com', 'profesor');

-- =====================================================
-- FIN DEL SCHEMA
-- =====================================================
