# Instrucciones de Descarga de Datos

Este directorio contiene el script para descargar todos los datos necesarios del proyecto.

## 📋 Requisitos Previos

### 1. Instalar Python
Asegúrate de tener Python 3.8 o superior instalado.

### 2. Instalar dependencias
```bash
pip install -r requirements.txt
```

## 🚀 Ejecutar la Descarga

```bash
python descargar_datos.py
```

## 📊 Datos que se Descargarán

El script descarga automáticamente los siguientes datasets:

### Metales Preciosos (20 años)
- ✅ Oro/USD (XAU/USD)
- ✅ Plata/USD (XAG/USD)
- ✅ Platino/USD (XPT/USD)

### Índices de Inflación
- ✅ CPI Estados Unidos
- ✅ CPI Eurozona (HICP)

### Tipos de Cambio
- ✅ EUR/USD histórico
- ✅ GBP/USD histórico
- ✅ JPY/USD histórico

### Indicadores Monetarios
- ✅ M2 Money Supply USA
- ✅ M2 Money Supply Eurozona

### Activos Financieros
- ✅ S&P 500
- ✅ Bitcoin (BTC/USD)

### Salarios e Ingresos
- ✅ Salarios ajustados por inflación USA

### Commodities
- ✅ Petróleo WTI

## 📁 Estructura de Salida

Después de ejecutar el script, tendrás:

```
datos/
├── raw/
│   ├── oro_usd.csv
│   ├── plata_usd.csv
│   ├── platino_usd.csv
│   ├── cpi_usa.csv
│   ├── cpi_eurozona.csv
│   ├── eur_usd.csv
│   ├── gbp_usd.csv
│   ├── jpy_usd.csv
│   ├── m2_money_supply_usa.csv
│   ├── m2_money_supply_eurozona.csv
│   ├── sp500.csv
│   ├── bitcoin.csv
│   ├── salarios_usa.csv
│   └── petroleo_wti.csv
├── procesados/
└── rdf/
```

## ⚠️ Notas Importantes

### Datos Simulados vs. Datos Reales

Algunos datasets utilizan **datos simulados** en lugar de datos reales debido a limitaciones de API:

- **CPI USA y Eurozona**: Usa BLS API pública (limitada). Para producción, obtén una API key de FRED.
- **M2 Money Supply**: Datos simulados. Usa FRED API (serie M2SL) para datos reales.
- **Salarios**: Datos simulados. Usa FRED API (serie MEHOINUSA672N) para datos reales.

### Obtener API Keys (Recomendado para Producción)

#### FRED API (Federal Reserve Economic Data)
1. Regístrate en: https://fred.stlouisfed.org/
2. Obtén tu API key: https://fred.stlouisfed.org/docs/api/api_key.html
3. Configura la variable de entorno:
   ```bash
   # Windows
   set FRED_API_KEY=tu_clave_aqui
   
   # Linux/Mac
   export FRED_API_KEY=tu_clave_aqui
   ```

#### Modificar el Script para Usar FRED
Descomenta y modifica estas líneas en `descargar_datos.py`:

```python
from fredapi import Fred

# Configurar FRED
fred = Fred(api_key='TU_API_KEY_AQUI')

# Descargar CPI
cpi = fred.get_series('CPIAUCSL', observation_start='2005-01-01')
```

### Datos de Eurostat

Para datos reales de la Eurozona:
1. Visita: https://data.ecb.europa.eu
2. Descarga manualmente o usa su API REST
3. Series recomendadas:
   - HICP: Índice armonizado de precios al consumo
   - M2: Masa monetaria M2

## 🔧 Solución de Problemas

### Error: "ModuleNotFoundError"
```bash
pip install -r requirements.txt
```

### Error de Conexión
- Verifica tu conexión a Internet
- Algunos servicios pueden estar temporalmente no disponibles
- Los datos de Yahoo Finance pueden tardar un poco

### Datos Incompletos
- Algunos activos (como Bitcoin) solo tienen datos desde 2014
- Los fines de semana y festivos no tienen datos de mercado
- Es normal tener algunos gaps en los datos

## 📈 Próximos Pasos

Una vez descargados los datos:

1. **Revisar los CSVs**: Abre los archivos en `datos/raw/` y verifica su contenido
2. **Pentaho Data Integration**: Importa estos CSVs en Pentaho para las transformaciones
3. **Limpieza de Datos**: Aplica las transformaciones descritas en el README principal
4. **Data Warehouse**: Carga los datos procesados al DW

## 📚 Documentación de Fuentes

- **Yahoo Finance**: https://finance.yahoo.com/
- **FRED**: https://fred.stlouisfed.org/
- **BLS (Bureau of Labor Statistics)**: https://www.bls.gov/
- **Eurostat**: https://ec.europa.eu/eurostat
- **ECB Data Portal**: https://data.ecb.europa.eu

## 💡 Tips

- Ejecuta el script **semanalmente** para mantener los datos actualizados
- Los datos históricos no cambian, pero se añaden nuevos registros
- Haz backup de `datos/raw/` antes de re-ejecutar el script
- Usa `git` para versionar los cambios en los datos

## 🐛 Reportar Problemas

Si encuentras algún error, por favor:
1. Revisa los logs del script
2. Verifica tu conexión a Internet
3. Comprueba que las dependencias están instaladas
4. Abre un issue en GitHub con el error completo
