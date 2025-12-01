import mysql.connector
import pandas as pd
import os

def exportar_hechos():
    """
    Conecta a la base de datos, extrae la tabla de hechos desnormalizada
    y la guarda en un CSV para su análisis.
    """
    config = {
        'host': 'localhost',
        'database': 'fiat_depreciacion_dw',
        'user': 'root',
        'password': 'root'
    }

    try:
        print("🔌 Conectando a la base de datos...")
        conn = mysql.connector.connect(**config)
        
        if conn.is_connected():
            print("✅ Conexión establecida.")
            
            # Query para extraer hechos con nombres legibles (JOINs)
            query = """
            SELECT 
                t.fecha,
                i.nombre as indicador,
                i.codigo as indicador_codigo,
                h.valor,
                u.simbolo as unidad,
                g.nombre as geografia,
                f.institucion as fuente
            FROM hechos_indicadores_temporales h
            JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
            JOIN dim_indicador i ON h.indicador_key = i.indicador_key
            JOIN dim_unidad u ON h.unit_key = u.unit_key
            JOIN dim_geografia g ON h.geo_key = g.geo_key
            JOIN dim_fuente f ON h.fuente_key = f.fuente_key
            ORDER BY t.fecha ASC;
            """
            
            print("⏳ Ejecutando consulta de extracción (puede tardar)...")
            df = pd.read_sql(query, conn)
            
            print(f"📊 Filas extraídas: {len(df)}")
            
            # Guardar a CSV
            output_path = os.path.join("datos", "procesados", "hechos_exportados_db.csv")
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
            
            df.to_csv(output_path, index=False, encoding='utf-8')
            print(f"💾 Archivo guardado en: {output_path}")
            
            return output_path

    except mysql.connector.Error as e:
        print(f"❌ Error de base de datos: {e}")
    except Exception as e:
        print(f"❌ Error general: {e}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            conn.close()
            print("🔌 Conexión cerrada.")

if __name__ == "__main__":
    exportar_hechos()
