import { supabaseServer } from "@/lib/supabase/server";

export async function GET() {
  const supabase = supabaseServer();
  const { data, error } = await supabase
    .from("mensajes")
    .select("*")
    .order("created_at", { ascending: false });
  if (error) return Response.json({ error }, { status: 500 });
  return Response.json(data);
}

export async function POST(req) {
  const supabase = supabaseServer();
  const { remitente_id, contenido } = await req.json();
  const { data, error } = await supabase
    .from("mensajes")
    .insert([{ remitente_id, contenido }])
    .select("*")
    .single();
  if (error) return Response.json({ error }, { status: 500 });
  return Response.json(data);
}
