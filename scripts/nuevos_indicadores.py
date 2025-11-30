import mysql.connector

def insertar_solo_desempleo_y_deciles():
    conn = mysql.connector.connect(
        host="localhost", database="fiat_depreciacion_dw", user="root", password="root"
    )
    cursor = conn.cursor()
    print("🔌 Conectado. Insertando SOLO Desempleo y Deciles...\n")

    # SQL base
    sql = """
        INSERT IGNORE INTO dim_indicador (nombre, descripcion, codigo, categoria, es_agregable, unidad_base)
        VALUES (%s, %s, %s, %s, %s, %s)
    """

    # 1. DESEMPLEO (Rangos extraídos de tu CSV)
    edades = ["16-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70 y mas"]
    datos_desempleo = []
    for e in edades:
        cod = e.replace("-", "_").replace(" y ", "_Y_").upper()
        datos_desempleo.append((
            f"Desempleo {e}",           # Nombre
            f"Tasa desempleo edad {e}", # Descripcion
            f"DES_{cod}",               # Codigo
            "Desempleo", 1, "%"
        ))
    cursor.executemany(sql, datos_desempleo)
    print(f"✅ {cursor.rowcount} indicadores de Desempleo insertados.")

    # 2. SALARIOS DECILES (Rangos extraídos de tu CSV)
    deciles = ["0-10", "10-20", "20-30", "30-40", "40-50", "50-60", "60-70", "70-80", "80-90", "90-100"]
    datos_deciles = []
    for d in deciles:
        cod = d.replace("-", "_")
        datos_deciles.append((
            f"Salario Decil {d}",       # Nombre
            f"Salario medio decil {d}", # Descripcion
            f"SAL_DEC_{cod}",           # Codigo
            "Salarios", 1, "EUR"
        ))
    cursor.executemany(sql, datos_deciles)
    print(f"✅ {cursor.rowcount} indicadores de Salarios (Deciles) insertados.")

    conn.commit()
    conn.close()
    print("\n🎉 Listo.")

if __name__ == "__main__":
    insertar_solo_desempleo_y_deciles()
