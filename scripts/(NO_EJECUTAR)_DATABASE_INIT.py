import mysql.connector
from mysql.connector import Error

def reset_y_cargar():
    connection = None
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='fiat_depreciacion_dw',
            user='root',
            password='root'
        )

        if connection.is_connected():
            cursor = connection.cursor()
            print("🔥 Conexión establecida. Iniciando limpieza de dimensiones...")

            # 1. LIMPIEZA
            cursor.execute("SET FOREIGN_KEY_CHECKS = 0;") 
            
            tablas_a_limpiar = ["dim_indicador", "dim_unidad", "dim_fuente", "dim_geografia"]
            for tabla in tablas_a_limpiar:
                print(f"   🗑️  Eliminando datos de {tabla}...")
                cursor.execute(f"DELETE FROM {tabla}")
                cursor.execute(f"ALTER TABLE {tabla} AUTO_INCREMENT = 1")

            cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
            print("✨ Tablas dimensionales limpias y reseteadas.")

            # 2. CARGA DE DATOS LIMPIOS
            print("\n🚀 Iniciando carga de datos maestros...")

            # --- A. GEOGRAFÍA ---
            # Ordenado para respetar jerarquía (Padres deben existir antes que hijos)
            sql_geo = """INSERT INTO dim_geografia 
                        (nombre, codigo_iso, codigo, tipo, geo_padre_key, nivel_jerarquia, poblacion) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s)"""
            datos_geo = [
                ("Global", "GL", "GLO", "Mundo", None, 1, 8000000000),
                ("Zona Euro", "EZ", "EUR_ZONE", "Región Económica", 1, 2, 343000000),
                ("España", "ES", "ESP", "País", 2, 3, 47400000),
                ("Estados Unidos", "US", "USA", "País", 1, 3, 331000000)
            ]
            cursor.executemany(sql_geo, datos_geo)
            print(f"   ✅ Geografía: {cursor.rowcount} filas insertadas.")

            # --- B. FUENTE ---
            sql_fuente = """INSERT INTO dim_fuente 
                           (institucion, codigo, url_base, licencia, pais_origen, confiabilidad) 
                           VALUES (%s, %s, %s, %s, %s, %s)"""
            datos_fuente = [
                ("INE", "INE_ES", "https://www.ine.es", "Publica", "ES", "Alta"),
                ("Yahoo Finance", "YHO_FIN", "https://finance.yahoo.com", "Privada", "US", "Media"),
                ("Banco de España", "BDE_ES", "https://www.bde.es", "Publica", "ES", "Alta"),
                ("Eurostat", "ESTAT", "https://ec.europa.eu/eurostat", "Publica", "EU", "Alta")
            ]
            cursor.executemany(sql_fuente, datos_fuente)
            print(f"   ✅ Fuentes: {cursor.rowcount} filas insertadas.")

            # --- C. UNIDAD ---
            sql_unidad = """INSERT INTO dim_unidad 
                           (simbolo, descripcion, tipo_medida, decimales, factor_conversion) 
                           VALUES (%s, %s, %s, %s, %s)"""
            datos_unidad = [
                ("EUR", "Euros", "Moneda", 2, 1.0),
                ("USD", "Dólares Americanos", "Moneda", 2, 1.0),
                ("Índice", "Valor Adimensional (Base 100)", "Índice", 4, 1.0),
                ("Personas", "Número de personas", "Conteo", 0, 1.0),
                ("%", "Porcentaje", "Ratio", 2, 0.01),
                ("EUR/oz", "Euros por Onza Troy", "Cotización", 2, 1.0)
            ]
            cursor.executemany(sql_unidad, datos_unidad)
            print(f"   ✅ Unidades: {cursor.rowcount} filas insertadas.")

            # --- D. INDICADOR (CORREGIDO: Añadida 'unidad_base') ---
            # Campos incluidos: nombre, descripcion, codigo, categoria, es_agregable, unidad_base, subcategoria, periodo_base, frecuencia_actualizacion
            sql_indicador = """
                INSERT INTO dim_indicador 
                (nombre, descripcion, codigo, categoria, es_agregable, unidad_base, subcategoria, periodo_base, frecuencia_actualizacion) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            datos_indicador = [
                # (Nombre, Descripcion, Codigo, Categoria, EsAgregable, UnidadBase, Subcategoria, PeriodoBase, Frecuencia)
                ("IPC General", "Índice de Precios de Consumo", "IPC_GEN", "Economía", 1, "Índice", "Precios", "2021", "Mensual"),
                ("Precio Oro EUR", "Cotización del Oro en Euros", "XAU_EUR", "Finanzas", 1, "EUR", "Materias Primas", None, "Diaria"),
                ("Asalariados Total", "Número total de asalariados", "EMPL_TOT", "Laboral", 1, "Personas", "Empleo", None, "Trimestral"),
                ("Salario medio bruto", "Salario medio anual bruto", "SAL_MED_B", "Laboral", 1, "EUR", "Salarios", None, "Anual"),
                ("Salario mediano", "Salario mediano anual", "SAL_MEDN", "Laboral", 1, "EUR", "Salarios", None, "Anual"),
                ("Salario mas frecuente", "Salario modal anual", "SAL_MOD", "Laboral", 1, "EUR", "Salarios", None, "Anual")
            ]
            cursor.executemany(sql_indicador, datos_indicador)
            print(f"   ✅ Indicadores: {cursor.rowcount} filas insertadas.")

            connection.commit()
            print("\n🎉 ¡Proceso completado con éxito!")

    except Error as e:
        print(f"❌ Error durante el proceso: {e}")
        if connection:
            connection.rollback()
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    reset_y_cargar()
