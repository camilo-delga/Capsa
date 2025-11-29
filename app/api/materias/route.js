import { supabase } from "@/lib/supabase";
import { NextResponse } from "next/server";

// GET - Obtener todas las materias
export async function GET() {
  try {
    const { data, error } = await supabase
      .from("materias")
      .select("*")
      .order("creado_en", { ascending: false });

    if (error) throw error;

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Error al obtener materias:", error);
    return NextResponse.json(
      { error: "Error al obtener materias" },
      { status: 500 }
    );
  }
}

// POST - Crear nueva materia
export async function POST(request) {
  try {
    const body = await request.json();
    const { nombre, descripcion, portada_url, profesor_id } = body;

    if (!nombre) {
      return NextResponse.json(
        { error: "El nombre es requerido" },
        { status: 400 }
      );
    }

    const { data, error } = await supabase
      .from("materias")
      .insert([{ nombre, descripcion, portada_url, profesor_id }])
      .select()
      .single();

    if (error) throw error;

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("Error al crear materia:", error);
    return NextResponse.json(
      { error: "Error al crear materia" },
      { status: 500 }
    );
  }
}
