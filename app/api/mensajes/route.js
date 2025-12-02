import { supabaseServer } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export const dynamic = "force-dynamic";

export async function GET(request) {
  try {
    const supabase = supabaseServer();
    const { searchParams } = new URL(request.url);
    const usuario_id = searchParams.get("usuario_id");

    let query = supabase
      .from("mensajes")
      .select("*")
      .order("creado_en", { ascending: true });

    if (usuario_id) {
      query = query.or(`emisor.eq.${usuario_id},receptor.eq.${usuario_id}`);
    }

    const { data, error } = await query;

    if (error) throw error;

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Error al obtener mensajes:", error);
    return NextResponse.json(
      { error: "Error al obtener mensajes" },
      { status: 500 }
    );
  }
}

export async function POST(request) {
  try {
    const supabase = supabaseServer();
    const body = await request.json();
    const { emisor, receptor, contenido } = body;

    if (!emisor || !receptor || !contenido) {
      return NextResponse.json(
        { error: "emisor, receptor y contenido son requeridos" },
        { status: 400 }
      );
    }

    const { data, error } = await supabase
      .from("mensajes")
      .insert([{ emisor, receptor, contenido }])
      .select()
      .single();

    if (error) throw error;

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Error al enviar mensaje:", error);
    return NextResponse.json(
      { error: "Error al enviar mensaje" },
      { status: 500 }
    );
  }
}
