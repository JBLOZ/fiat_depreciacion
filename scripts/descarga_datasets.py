"""
Script para descargar datasets disponibles mediante APIs para el proyecto de análisis
de depreciación del euro y erosión del poder adquisitivo en España (2010-2025)

Datasets descargables automáticamente:
1. Tipo de Cambio EUR/USD (Yahoo Finance)
2. Oro (Precio en USD/oz) (Yahoo Finance)
3. IBEX-35 (Yahoo Finance)

Nota: Los datasets de INE (IPC, Salarios, Empleo) se obtienen manualmente
y ya están disponibles en la estructura de datos del proyecto.

Fecha: 30 de octubre de 2025
"""

import os
import pandas as pd
import requests
from datetime import datetime, timedelta
import yfinance as yf
import json
from pathlib import Path

# Crear estructura de directorios si no existe
SCRIPT_DIR = Path(__file__).parent
PROJECT_DIR = SCRIPT_DIR.parent
DATA_DIR = PROJECT_DIR / "datos"
RAW_DIR = DATA_DIR / "raw"

# Crear subdirectorios por categoría
TIPO_CAMBIO_DIR = RAW_DIR / "Tipo de cambio"
ORO_DIR = RAW_DIR / "ORO (USD_oz)"
INDICES_DIR = RAW_DIR / "Indices Bursátiles"

# Crear directorios
TIPO_CAMBIO_DIR.mkdir(parents=True, exist_ok=True)
ORO_DIR.mkdir(parents=True, exist_ok=True)
INDICES_DIR.mkdir(parents=True, exist_ok=True)

# Configuración de fechas
START_DATE = "2010-01-01"
END_DATE = "2025-12-31"

print("="*80)
print("DESCARGA DE DATASETS - PROYECTO DEPRECIACIÓN EURO Y PODER ADQUISITIVO")
print("="*80)
print(f"Período: {START_DATE} a {END_DATE}")
print(f"Directorio de salida: {RAW_DIR.absolute()}")
print("\nDatasets a descargar:")
print("  1. Tipo de cambio EUR/USD → Tipo de cambio/")
print("  2. Precio del Oro (USD/oz) → ORO (USD_oz)/")
print("  3. IBEX-35 → Indices Bursátiles/")
print("="*80)


# ============================================================================
# DATASET 1: TIPO DE CAMBIO EUR/USD (BCE, Yahoo Finance)
# ============================================================================
def descargar_eur_usd():
    print("\n[1/6] Descargando Tipo de Cambio EUR/USD...")
    try:
        # Opción 1: Yahoo Finance
        ticker = yf.Ticker("EURUSD=X")
        df = ticker.history(start=START_DATE, end=END_DATE)
        
        if not df.empty:
            df = df.reset_index()
            df = df.rename(columns={'Date': 'date', 'Close': 'eur_usd_rate'})
            df = df[['date', 'eur_usd_rate', 'Open', 'High', 'Low', 'Volume']]
            df['source'] = 'Yahoo Finance'
            
            output_file = TIPO_CAMBIO_DIR / "eur_usd_exchange_rate.csv"
            df.to_csv(output_file, index=False)
            
            print(f"  ✓ Descargado: {len(df)} registros")
            print(f"  ✓ Guardado en: {output_file}")
            
            
            
            return True
        else:
            print("  ✗ No se obtuvieron datos de EUR/USD")
            return False
            
    except Exception as e:
        print(f"  ✗ Error al descargar EUR/USD: {str(e)}")
        return False

# ============================================================================
# DATASET 2: ORO (USD/oz) - Yahoo Finance
# ============================================================================
def descargar_oro():
    print("\n[2/6] Descargando Precio del Oro (USD/oz)...")
    try:
        # Ticker de oro en Yahoo Finance
        ticker = yf.Ticker("GC=F")
        df = ticker.history(start=START_DATE, end=END_DATE)
        
        if not df.empty:
            df = df.reset_index()
            df = df.rename(columns={'Date': 'date', 'Close': 'price_usd_per_oz'})
            df = df[['date', 'price_usd_per_oz', 'Open', 'High', 'Low', 'Volume']]
            df['source'] = 'Yahoo Finance (Gold Futures)'
            
            output_file = ORO_DIR / "gold_price_usd.csv"
            df.to_csv(output_file, index=False)
            
            print(f"  ✓ Descargado: {len(df)} registros")
            print(f"  ✓ Guardado en: {output_file}")
            
            
            
            return True
        else:
            print("  ✗ No se obtuvieron datos del oro")
            return False
            
    except Exception as e:
        print(f"  ✗ Error al descargar oro: {str(e)}")
        return False

# ============================================================================
# DATASET 3: IBEX-35 - Yahoo Finance
# ============================================================================
def descargar_ibex35():
    print("\n[3/6] Descargando IBEX-35...")
    try:
        # Ticker de IBEX-35 en Yahoo Finance
        ticker = yf.Ticker("^IBEX")
        df = ticker.history(start=START_DATE, end=END_DATE)
        
        if not df.empty:
            df = df.reset_index()
            df = df.rename(columns={'Date': 'date', 'Close': 'close'})
            df = df[['date', 'close', 'Open', 'High', 'Low', 'Volume']]
            df['source'] = 'Yahoo Finance'
            
            # Calcular retornos logarítmicos
            import numpy as np
            df['log_return'] = df['close'].pct_change().apply(lambda x: np.log(1 + x) if pd.notna(x) else None)
            
            output_file = INDICES_DIR / "ibex35_daily.csv"
            df.to_csv(output_file, index=False)
            
            print(f"  ✓ Descargado: {len(df)} registros")
            print(f"  ✓ Guardado en: {output_file}")
            
            
            
            return True
        else:
            print("  ✗ No se obtuvieron datos del IBEX-35")
            return False
            
    except Exception as e:
        print(f"  ✗ Error al descargar IBEX-35: {str(e)}")
        return False



# ============================================================================
# MAIN: Ejecutar todas las descargas
# ============================================================================
def main():
    print("\nIniciando descarga de datasets desde APIs...\n")
    
    resultados = {
        'EUR/USD (Tipo de cambio)': descargar_eur_usd(),
        'Oro (USD/oz)': descargar_oro(),
        'IBEX-35': descargar_ibex35()
    }
    
    print("\n" + "="*80)
    print("RESUMEN DE DESCARGAS")
    print("="*80)
    
    exitosos = 0
    for dataset, exito in resultados.items():
        estado = "✓ Completado" if exito else "✗ Error"
        print(f"{dataset:30} : {estado}")
        if exito:
            exitosos += 1
    
    print("\n" + "="*80)
    print(f"RESULTADO: {exitosos}/{len(resultados)} datasets descargados exitosamente")
    

if __name__ == "__main__":
    main()
