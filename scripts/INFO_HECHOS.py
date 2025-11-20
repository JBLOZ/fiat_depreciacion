import mysql.connector
import pandas as pd
import warnings

# Silenciamos el warning de Pandas/SQLAlchemy para que la salida sea limpia
warnings.filterwarnings('ignore')

def informe_carga_dw():
    connection = None
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='fiat_depreciacion_dw',
            user='root',
            password='root'
        )

        if connection.is_connected():
            print("\n" + "="*60)
            print(" 📊 INFORME DE ESTADO DEL DATA WAREHOUSE")
            print("="*60 + "\n")
            
            # 1. VISTA GENERAL (Últimos registros por fecha)
            print("--- 1. DATOS RECIENTES (Muestra por Fecha) ---")
            
            # CORRECCIÓN: Ordenamos por t.fecha DESC porque no existe h.hecho_id
            query_muestra = """
                SELECT 
                    t.fecha,
                    i.nombre as indicador,
                    g.nombre as pais,
                    h.valor,
                    u.simbolo as unidad
                FROM hechos_indicadores_temporales h
                JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
                JOIN dim_geografia g ON h.geo_key = g.geo_key
                JOIN dim_indicador i ON h.indicador_key = i.indicador_key
                JOIN dim_unidad u ON h.unit_key = u.unit_key
                ORDER BY t.fecha DESC
                LIMIT 10;
            """
            df_muestra = pd.read_sql(query_muestra, connection)
            
            if df_muestra.empty:
                print("⚠️  La tabla de hechos está vacía.\n")
            else:
                print(df_muestra.to_string(index=False))
            
            # 2. RESUMEN POR INDICADOR
            print("\n--- 2. RESUMEN POR INDICADOR (Cantidad y Fechas) ---")
            query_resumen = """
                SELECT 
                    i.nombre as INDICADOR,
                    COUNT(*) as 'TOTAL REGISTROS',
                    MIN(t.fecha) as 'FECHA INICIO',
                    MAX(t.fecha) as 'FECHA FIN',
                    FORMAT(AVG(h.valor), 2) as 'VALOR MEDIO'
                FROM hechos_indicadores_temporales h
                JOIN dim_indicador i ON h.indicador_key = i.indicador_key
                JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
                GROUP BY i.nombre
                ORDER BY i.nombre;
            """
            df_resumen = pd.read_sql(query_resumen, connection)
            
            if not df_resumen.empty:
                # Ajuste estético para columnas anchas
                pd.set_option('display.max_columns', None)
                pd.set_option('display.width', 1000)
                print(df_resumen.to_string(index=False))
            else:
                print("   (Sin datos para resumir)")

            # 3. TOTAL GLOBAL
            cursor = connection.cursor()
            cursor.execute("SELECT COUNT(*) FROM hechos_indicadores_temporales")
            total = cursor.fetchone()[0]
            print(f"\n📚 TOTAL GLOBAL DE FILAS EN EL DW: {total}")
            print("="*60 + "\n")

    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        if connection and connection.is_connected():
            connection.close()

if __name__ == "__main__":
    informe_carga_dw()
