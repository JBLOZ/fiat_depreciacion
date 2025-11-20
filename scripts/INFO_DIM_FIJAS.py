import mysql.connector

def ver_tablas():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='fiat_depreciacion_dw',
            user='root',
            password='root'
        )

        if connection.is_connected():
            cursor = connection.cursor()
            
            # Lista de tablas que queremos inspeccionar
            tablas = ["dim_geografia", "dim_fuente", "dim_unidad", "dim_indicador"]

            for tabla in tablas:
                print(f"\n{'='*40}")
                print(f"  TABLA: {tabla.upper()}")
                print(f"{'='*40}")
                
                # 1. Ver columnas (para saber qué falló antes)
                cursor.execute(f"DESCRIBE {tabla}")
                columnas = [col[0] for col in cursor.fetchall()]
                print(f"Columnas: {columnas}")
                print("-" * 40)

                # 2. Ver datos
                cursor.execute(f"SELECT * FROM {tabla}")
                filas = cursor.fetchall()
                
                if not filas:
                    print("  (Tabla vacía)")
                else:
                    for fila in filas:
                        print(f"  {fila}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if connection and connection.is_connected():
            connection.close()

if __name__ == "__main__":
    ver_tablas()
