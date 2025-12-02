import { supabaseServer } from "@/lib/supabase/server";

export async function GET() {
  const supabase = supabaseServer();
  const { data, error } = await supabase.from("materias").select("*");
  if (error) return Response.json({ error }, { status: 500 });
  return Response.json(data);
}
