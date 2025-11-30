import mysql.connector

def añadir_nuevos_datos():
    connection = mysql.connector.connect(
        host='localhost', database='fiat_depreciacion_dw', user='root', password='root'
    )
    cursor = connection.cursor()

    print("🚀 Añadiendo nuevas dimensiones sin borrar las anteriores...")

    # 1. NUEVAS UNIDADES
    # Necesitamos: USD/oz, USD por EUR, Puntos (IBEX)
    sql_unidad = "INSERT IGNORE INTO dim_unidad (simbolo, descripcion, tipo_medida) VALUES (%s, %s, %s)"
    nuevas_unidades = [
        ("USD/oz", "Dólares por Onza Troy", "Cotización"),
        ("USD/EUR", "Dólares por Euro", "Tipo de Cambio"),
        ("Puntos", "Puntos de Índice Bursátil", "Índice")
    ]
    cursor.executemany(sql_unidad, nuevas_unidades)
    print(f"✅ Unidades añadidas.")

    # 2. NUEVOS INDICADORES
    # Necesitamos: Precio Oro USD, Tipo Cambio, IBEX 35
    # NOTA: Para Desempleo y Salarios por Decil, como son muchos (por edad/rango), 
    # es mejor dejar que Pentaho los cree (si tu BD lo permite) o añadirlos aquí si sabes los rangos exactos.
    # Vamos a añadir los principales fijos.
    sql_indicador = """
        INSERT IGNORE INTO dim_indicador 
        (nombre, descripcion, codigo, categoria, es_agregable, unidad_base) 
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    nuevos_indicadores = [
        ("Precio Oro USD", "Cotización del Oro en Dólares", "XAU_USD", "Finanzas", 1, "USD/oz"),
        ("Tipo Cambio EUR/USD", "Valor de 1 Euro en Dólares", "EURUSD", "Finanzas", 1, "USD/EUR"),
        ("IBEX 35", "Índice Bursátil Español", "IBEX35", "Bolsa", 1, "Puntos")
    ]
    cursor.executemany(sql_indicador, nuevos_indicadores)
    print(f"✅ Indicadores fijos añadidos.")

    # 3. PARA LOS DINÁMICOS (Desempleo y Salarios Deciles)
    # Si tu BD no permite NULLs en 'codigo', necesitamos insertar un genérico o relajar la restricción.
    # Opción rápida: Alterar la tabla para permitir NULLs en campos no críticos si vas a usar Pentaho para estos.
    try:
        cursor.execute("ALTER TABLE dim_indicador MODIFY codigo VARCHAR(50) NULL")
        cursor.execute("ALTER TABLE dim_indicador MODIFY categoria VARCHAR(50) DEFAULT 'General'")
        cursor.execute("ALTER TABLE dim_indicador MODIFY unidad_base VARCHAR(50) NULL")
        print("🔧 Tabla dim_indicador ajustada para permitir inserción automática de Pentaho (Desempleo/Deciles).")
    except Exception as e:
        print(f"ℹ️ Nota sobre estructura: {e}")

    connection.commit()
    connection.close()
    print("\n🎉 ¡Listo! Ahora ve a Pentaho.")

if __name__ == "__main__":
    añadir_nuevos_datos()
