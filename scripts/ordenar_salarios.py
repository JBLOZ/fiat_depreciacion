import pandas as pd
import os

# Ruta del archivo CSV
file_path = r"c:\Users\jordi\Documents\UNI\fiat_depreciacion\datos\procesados\Salarios\Salario_anual_medio_mediano_frecuente_2010_2023.csv"

# Leer el CSV
df = pd.read_csv(file_path, sep=';')

# Reordenar las columnas: Periodo primero, luego Salario anual, luego Valor anual
df = df[['Periodo', 'Salario anual', 'Valor anual']]

# Ordenar por Periodo en orden descendente (2023 a 2010)
df = df.sort_values(by='Periodo', ascending=False)

# Escribir de vuelta al archivo
df.to_csv(file_path, sep=';', index=False)

print("Archivo ordenado y columnas reordenadas exitosamente.")