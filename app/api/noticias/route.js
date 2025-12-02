import { supabaseServer } from "@/lib/supabase/server";

export async function GET() {
  const supabase = supabaseServer();
  const { data, error } = await supabase
    .from("noticias")
    .select("*")
    .order("created_at", { ascending: false });
  if (error) return Response.json({ error }, { status: 500 });
  return Response.json(data);
}
