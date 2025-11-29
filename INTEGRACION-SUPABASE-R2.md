# 🚀 INTEGRACIÓN COMPLETA: SUPABASE + CLOUDFLARE R2

## 📋 RESUMEN
Tu proyecto **Capsa Lycei** ahora tiene integración completa con:
- ✅ **Supabase** - Base de datos PostgreSQL + Auth
- ✅ **Cloudflare R2** - Almacenamiento de archivos (compatible con S3)
- ✅ **API Routes** - 5 endpoints REST listos
- ✅ **Custom Hooks** - 5 hooks React para consumir datos

**⚠️ TU DISEÑO UI NO FUE MODIFICADO**

---

## 📦 PASO 1: INSTALAR DEPENDENCIAS

```bash
npm install @supabase/supabase-js @aws-sdk/client-s3
```

---

## 🗄️ PASO 2: CONFIGURAR SUPABASE

### 2.1 Crear proyecto en Supabase
1. Ve a: https://supabase.com/dashboard
2. Click en **"New Project"**
3. Completa:
   - **Name:** Capsa Lycei
   - **Database Password:** (guarda esta contraseña)
   - **Region:** South America (elige el más cercano)
4. Click **"Create new project"**
5. Espera 2-3 minutos mientras se crea

### 2.2 Ejecutar SQL para crear tablas
1. En el dashboard de Supabase, ve a: **SQL Editor** (menú izquierdo)
2. Click en **"+ New query"**
3. Abre el archivo: `supabase-schema.sql` (está en la raíz de tu proyecto)
4. **COPIA TODO EL CONTENIDO** del archivo
5. **PEGA** en el editor SQL de Supabase
6. Click en **"Run"** (o presiona Ctrl+Enter)
7. Deberías ver: ✅ "Success. No rows returned"

### 2.3 Obtener credenciales
1. Ve a: **Settings → API** (menú izquierdo)
2. Copia estos valores:
   - **Project URL** → Esta es tu `NEXT_PUBLIC_SUPABASE_URL`
   - **anon public** (en "Project API keys") → Esta es tu `NEXT_PUBLIC_SUPABASE_ANON_KEY`

---

## ☁️ PASO 3: CONFIGURAR CLOUDFLARE R2

### 3.1 Crear cuenta en Cloudflare
1. Ve a: https://dash.cloudflare.com/sign-up
2. Crea tu cuenta (es gratis)
3. Confirma tu email

### 3.2 Crear bucket R2
1. En el dashboard, ve a: **R2** (menú izquierdo)
2. Click en **"Create bucket"**
3. Nombre del bucket: `capsa-lycei-files`
4. Click **"Create bucket"**

### 3.3 Configurar dominio público
1. Dentro del bucket que creaste, ve a: **Settings**
2. En "Public access", click **"Allow Access"**
3. Click **"Connect Domain"**
4. Usa el dominio auto-generado (terminará en `.r2.dev`)
5. Guarda ese dominio para más tarde

### 3.4 Generar API Token
1. Ve a: **R2 → Manage R2 API Tokens**
2. Click **"Create API token"**
3. Nombre: `capsa-lycei-token`
4. Permisos: **Object Read & Write**
5. Click **"Create API Token"**
6. **⚠️ IMPORTANTE:** Copia y guarda estos valores (solo se muestran UNA VEZ):
   - **Access Key ID**
   - **Secret Access Key**
7. También necesitarás tu **Account ID** (está en la esquina superior derecha)

---

## 🔐 PASO 4: CONFIGURAR VARIABLES DE ENTORNO

### 4.1 Crear archivo .env.local
1. En la raíz de tu proyecto, crea un archivo llamado: `.env.local`
2. Copia el contenido de `.env.example`
3. Reemplaza los valores con tus credenciales:

```env
# SUPABASE
NEXT_PUBLIC_SUPABASE_URL=https://tu-proyecto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# CLOUDFLARE R2
R2_ACCOUNT_ID=abc123def456
R2_ACCESS_KEY_ID=tu_access_key_aqui
R2_SECRET_ACCESS_KEY=tu_secret_access_key_aqui
R2_BUCKET_NAME=capsa-lycei-files
R2_PUBLIC_DOMAIN=pub-abc123.r2.dev
```

### 4.2 Verificar que .env.local esté en .gitignore
```bash
# Verificar:
cat .gitignore | grep .env.local

# Si no aparece, agregarlo:
echo ".env.local" >> .gitignore
```

---

## 🧪 PASO 5: PROBAR LA INTEGRACIÓN

### 5.1 Reiniciar servidor de desarrollo
```bash
# Detén el servidor actual (Ctrl+C)
# Inicia de nuevo para cargar las variables de entorno
npm run dev
```

### 5.2 Probar endpoints en consola del navegador
Abre tu app en: http://localhost:3000

Abre la consola del navegador (F12) y pega estos comandos:

#### Probar GET de materias:
```javascript
fetch('/api/materias')
  .then(r => r.json())
  .then(d => console.log('Materias:', d));
```

#### Probar POST de una materia:
```javascript
fetch('/api/materias', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    nombre: 'Matemáticas Avanzadas',
    descripcion: 'Cálculo diferencial e integral'
  })
})
.then(r => r.json())
.then(d => console.log('Materia creada:', d));
```

#### Probar noticias:
```javascript
fetch('/api/noticias')
  .then(r => r.json())
  .then(d => console.log('Noticias:', d));
```

---

## 🎨 PASO 6: USAR LOS HOOKS EN TUS COMPONENTES

### Ejemplo 1: Mostrar materias en un componente

```jsx
'use client';

import { useMaterias } from '@/hooks/useMaterias';

export default function MiComponente() {
  const { data, loading, error, refresh } = useMaterias();

  if (loading) return <p>Cargando...</p>;
  if (error) return <p>Error: {error}</p>;

  return (
    <div>
      <h2>Mis Materias</h2>
      <button onClick={refresh}>Actualizar</button>
      <ul>
        {data.map(materia => (
          <li key={materia.id}>{materia.nombre}</li>
        ))}
      </ul>
    </div>
  );
}
```

### Ejemplo 2: Subir un archivo

```jsx
'use client';

import { useUpload } from '@/hooks/useUpload';
import { useState } from 'react';

export default function SubirArchivo() {
  const { uploadFile, uploading } = useUpload();
  const [fileUrl, setFileUrl] = useState(null);

  const handleUpload = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    try {
      const url = await uploadFile(file);
      setFileUrl(url);
      console.log('Archivo subido:', url);
    } catch (err) {
      console.error('Error:', err);
    }
  };

  return (
    <div>
      <input type="file" onChange={handleUpload} disabled={uploading} />
      {uploading && <p>Subiendo...</p>}
      {fileUrl && <img src={fileUrl} alt="Uploaded" />}
    </div>
  );
}
```

### Ejemplo 3: Crear una tarea

```jsx
'use client';

import { useTareas } from '@/hooks/useTareas';

export default function CrearTarea() {
  const { createTarea } = useTareas();

  const handleSubmit = async () => {
    try {
      await createTarea({
        materia_id: 'uuid-de-la-materia',
        titulo: 'Resolver ejercicios página 42',
        descripcion: 'Ejercicios 1 al 10',
        fecha_limite: '2025-12-31'
      });
      alert('Tarea creada!');
    } catch (err) {
      console.error(err);
    }
  };

  return <button onClick={handleSubmit}>Crear Tarea</button>;
}
```

---

## 📂 ARCHIVOS CREADOS

### Configuración
- ✅ `lib/supabase.js` - Cliente de Supabase
- ✅ `lib/r2.js` - Cliente de Cloudflare R2
- ✅ `.env.example` - Template de variables de entorno

### API Routes
- ✅ `app/api/upload/route.js` - Subir archivos a R2
- ✅ `app/api/materias/route.js` - GET/POST materias
- ✅ `app/api/tareas/route.js` - GET/POST tareas
- ✅ `app/api/noticias/route.js` - GET/POST noticias
- ✅ `app/api/mensajes/route.js` - GET/POST mensajes

### Custom Hooks
- ✅ `hooks/useMaterias.js` - Hook para materias
- ✅ `hooks/useTareas.js` - Hook para tareas
- ✅ `hooks/useNoticias.js` - Hook para noticias
- ✅ `hooks/useMensajes.js` - Hook para mensajes
- ✅ `hooks/useUpload.js` - Hook para subir archivos

### SQL
- ✅ `supabase-schema.sql` - Schema completo de la base de datos

---

## 📊 ESTRUCTURA DE LAS TABLAS

### usuarios
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | UUID | Primary Key |
| nombre | TEXT | Nombre completo |
| email | TEXT | Email (único) |
| rol | TEXT | alumno/docente/delegado/administrador |
| avatar_url | TEXT | URL del avatar |
| creado_en | TIMESTAMP | Fecha de creación |

### materias
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | UUID | Primary Key |
| nombre | TEXT | Nombre de la materia |
| descripcion | TEXT | Descripción |
| portada_url | TEXT | URL de imagen de portada |
| profesor_id | UUID | FK → usuarios |
| creado_en | TIMESTAMP | Fecha de creación |

### tareas
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | UUID | Primary Key |
| materia_id | UUID | FK → materias (CASCADE) |
| titulo | TEXT | Título de la tarea |
| descripcion | TEXT | Descripción |
| fecha_limite | TIMESTAMP | Fecha límite de entrega |
| archivo_url | TEXT | URL del archivo adjunto |
| creado_en | TIMESTAMP | Fecha de creación |

### mensajes
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | UUID | Primary Key |
| emisor | UUID | FK → usuarios |
| receptor | UUID | FK → usuarios |
| contenido | TEXT | Contenido del mensaje |
| creado_en | TIMESTAMP | Fecha de creación |

### noticias
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | UUID | Primary Key |
| titulo | TEXT | Título de la noticia |
| cuerpo | TEXT | Contenido completo |
| categoria | TEXT | Categoría (general, urgente, etc.) |
| portada_url | TEXT | URL de imagen de portada |
| autor_id | UUID | FK → usuarios |
| creado_en | TIMESTAMP | Fecha de creación |

---

## 🔌 ENDPOINTS DISPONIBLES

### 1. Upload
```
POST /api/upload
Content-Type: multipart/form-data
Body: { file: File }

Response: { success: true, url: "https://...", fileName: "..." }
```

### 2. Materias
```
GET  /api/materias
POST /api/materias
Body: { nombre, descripcion, portada_url, profesor_id }
```

### 3. Tareas
```
GET  /api/tareas?materia_id=<uuid>
POST /api/tareas
Body: { materia_id, titulo, descripcion, fecha_limite, archivo_url }
```

### 4. Noticias
```
GET  /api/noticias?categoria=<categoria>
POST /api/noticias
Body: { titulo, cuerpo, categoria, portada_url, autor_id }
```

### 5. Mensajes
```
GET  /api/mensajes?usuario_id=<uuid>
POST /api/mensajes
Body: { emisor, receptor, contenido }
```

---

## 🛡️ SEGURIDAD

### ✅ Implementado:
- Variables de entorno para credenciales sensibles
- Validación de campos requeridos en API routes
- Manejo de errores en todas las rutas
- CORS configurado automáticamente por Next.js

### ⚠️ Recomendaciones para producción:
1. **Habilitar RLS en Supabase** (Row Level Security)
2. **Configurar políticas de acceso** por rol de usuario
3. **Validar tipos de archivo** antes de subir a R2
4. **Limitar tamaño de archivos** en upload
5. **Implementar rate limiting** en API routes

---

## 🚀 DESPLEGAR EN VERCEL

### Variables de entorno en Vercel:
1. Ve a tu proyecto en Vercel
2. **Settings → Environment Variables**
3. Agrega TODAS las variables de tu `.env.local`:
   - NEXT_PUBLIC_SUPABASE_URL
   - NEXT_PUBLIC_SUPABASE_ANON_KEY
   - R2_ACCOUNT_ID
   - R2_ACCESS_KEY_ID
   - R2_SECRET_ACCESS_KEY
   - R2_BUCKET_NAME
   - R2_PUBLIC_DOMAIN

4. Redeploy: `git push origin main`

---

## 🐛 TROUBLESHOOTING

### Error: "fetch failed" en API routes
- Verifica que las variables de entorno estén configuradas
- Reinicia el servidor: `npm run dev`

### Error: "relation does not exist"
- El SQL no se ejecutó correctamente en Supabase
- Ve a SQL Editor y ejecuta `supabase-schema.sql` de nuevo

### Error: "Access Denied" en R2
- Verifica las credenciales R2 en `.env.local`
- Confirma que el token tenga permisos de Read & Write

### Error: "CORS" en navegador
- Los endpoints públicos de Next.js (`NEXT_PUBLIC_*`) son accesibles
- Las variables privadas solo funcionan en server-side

---

## ✅ CHECKLIST FINAL

- [ ] Instalé dependencias: `npm install @supabase/supabase-js @aws-sdk/client-s3`
- [ ] Creé proyecto en Supabase
- [ ] Ejecuté `supabase-schema.sql` en SQL Editor
- [ ] Obtuve credenciales de Supabase
- [ ] Creé bucket en Cloudflare R2
- [ ] Generé API token de R2
- [ ] Creé archivo `.env.local` con todas las credenciales
- [ ] Reinicié servidor de desarrollo
- [ ] Probé endpoints en consola del navegador
- [ ] Los hooks funcionan correctamente
- [ ] Configuré variables en Vercel para producción

---

## 🎉 ¡LISTO!

Tu proyecto **Capsa Lycei** ahora tiene:
- ✅ Backend completo con Supabase
- ✅ Almacenamiento de archivos con R2
- ✅ 5 API Routes funcionando
- ✅ 5 Custom Hooks listos para usar
- ✅ **TU DISEÑO UI INTACTO**

**Próximos pasos:**
1. Reemplaza los datos mock en tus componentes por los hooks reales
2. Implementa autenticación de usuarios
3. Agrega validaciones adicionales
4. Habilita RLS en Supabase para seguridad

---

**Documentación creada:** $(date)
**Proyecto:** Capsa Lycei - Plataforma Educativa
**Stack:** Next.js 14 + Supabase + Cloudflare R2
