import { supabaseServer } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export const dynamic = "force-dynamic";

export async function GET(request) {
  try {
    const supabase = supabaseServer();
    const { searchParams } = new URL(request.url);
    const categoria = searchParams.get("categoria");

    let query = supabase
      .from("noticias")
      .select("*")
      .order("creado_en", { ascending: false });

    if (categoria && categoria !== "todas") {
      query = query.eq("categoria", categoria);
    }

    const { data, error } = await query;

    if (error) throw error;

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Error al obtener noticias:", error);
    return NextResponse.json(
      { error: "Error al obtener noticias" },
      { status: 500 }
    );
  }
}

export async function POST(request) {
  try {
    const supabase = supabaseServer();
    const body = await request.json();
    const { titulo, cuerpo, categoria, portada_url, autor_id } = body;

    if (!titulo || !cuerpo) {
      return NextResponse.json(
        { error: "titulo y cuerpo son requeridos" },
        { status: 400 }
      );
    }

    const { data, error } = await supabase
      .from("noticias")
      .insert([{ titulo, cuerpo, categoria, portada_url, autor_id }])
      .select()
      .single();

    if (error) throw error;

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Error al crear noticia:", error);
    return NextResponse.json(
      { error: "Error al crear noticia" },
      { status: 500 }
    );
  }
}
