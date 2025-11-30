import pandas as pd
import os

# RUTAS (Ajusta si es necesario)
INPUT_FILE = "./datos/procesados/Salarios/Salario_mensual_deciles_ 2010_2023.csv"
OUTPUT_FILE = "./datos/procesados/Salarios/Salarios_CLEAN.csv"

def limpiar_csv_salarios():
    print(f"🧹 Leyendo archivo: {INPUT_FILE}")
    
    try:
        # Leer el CSV (asumiendo separador punto y coma)
        # na_values=['\\N', ''] le dice a pandas que trate \N y vacíos como NaN
        df = pd.read_csv(INPUT_FILE, sep=';', na_values=['\\N', ''], names=['Fecha', 'Decil', 'Valor'], header=0)
        
        total_filas = len(df)
        print(f"   Filas originales: {total_filas}")

        # 1. ELIMINAR FILAS SIN VALOR NUMÉRICO
        # Borramos donde 'Valor' sea NaN (esto elimina los \N y los vacíos del final)
        df_clean = df.dropna(subset=['Valor'])
        filas_sin_valor = total_filas - len(df_clean)
        print(f"   🗑️ Eliminadas {filas_sin_valor} filas sin importe (vacías o \\N).")

        # 2. ELIMINAR FILAS SIN RANGO (Decil vacío)
        # Si el campo del medio está vacío, no podemos crear el indicador "Salario Decil X"
        con_decil = df_clean.dropna(subset=['Decil'])
        filas_sin_decil = len(df_clean) - len(con_decil)
        if filas_sin_decil > 0:
            print(f"   🗑️ Eliminadas {filas_sin_decil} filas sin rango de decil asignado.")
        
        df_final = con_decil

        # 3. GUARDAR ARREGLADO
        # Usamos encoding utf-8 y sep ';' para mantener el formato estándar
        df_final.to_csv(OUTPUT_FILE, sep=';', index=False, date_format='%Y-%m-%d')
        
        print(f"\n✅ Archivo limpio guardado en: {OUTPUT_FILE}")
        print(f"   Filas finales válidas: {len(df_final)}")
        print("   Ahora usa ESTE archivo nuevo en tu Pentaho.")

    except FileNotFoundError:
        print("❌ Error: No encuentro el archivo. Revisa la ruta INPUT_FILE en el script.")

if __name__ == "__main__":
    limpiar_csv_salarios()
