## Recomendaciones para tu práctica de Adquisición y Preparación de Datos

Basándome en el enunciado de tu práctica y en tu temática sobre la devaluación de las monedas fiat, te proporciono una guía completa sobre qué datos utilizar y cómo estructurar el trabajo para cumplir todos los requisitos, especialmente para trabajar con Pentaho Data Integration.

### **Temática y Problema Definido**

**Temática**: Economía y finanzas - Análisis de la degradación del poder adquisitivo de las monedas fiat

**Problema**: Estudiar cómo las monedas fiat han perdido valor en los últimos 20 años comparándolas con activos refugio (oro, plata) y otros indicadores económicos, demostrando la erosión del poder adquisitivo debido a políticas monetarias expansivas e inflación.

### **1. Fuentes de Datos Recomendadas**

Para que Pentaho funcione correctamente, necesitas **múltiples fuentes de datos** con **diferentes formatos** y **columnas variadas**. Aquí están mis recomendaciones:

#### **Datos que YA tienes:**
- **Oro/USD (XAU/USD)**: 20 años de datos históricos en CSV con fecha y precio

#### **Datos adicionales ESENCIALES que debes descargar:**

**A. Metales Preciosos (para comparación con fiat):**
1. **Plata/USD**: Descarga desde Kaggle o Perth Mint (CSV con datos desde 1969)[1][2]
   - Columnas: Date, Silver_oz_usd_price, Silver_kg_usd_price

2. **Platino/USD**: Mismo origen que plata
   - Columnas: Date, Platinum_oz_usd_price

**B. Índices de Inflación (CPI - Consumer Price Index):**
3. **CPI Estados Unidos**: Descarga desde BLS (Bureau of Labor Statistics) o DataHub[3][4]
   - Columnas: Date, CPI_Index, Inflation_Rate
   - Formato: CSV mensual desde 1913

4. **CPI Eurozona**: Descarga desde Eurostat o ECB Data Portal[5]
   - Columnas: Date, HICP_Index, Country_Code
   - Formato: CSV/Excel

**C. Tipos de Cambio:**
5. **EUR/USD histórico**: Descarga desde OANDA o Banco de España[6][7]
   - Columnas: Date, Open, High, Low, Close, EUR_USD_Rate
   - Formato: CSV diario desde 1999

6. **Otras divisas importantes** (opcional): GBP/USD, JPY/USD desde la misma fuente

**D. Indicadores Monetarios:**
7. **M2 Money Supply USA**: Descarga desde FRED (Federal Reserve Economic Data)[8]
   - URL: https://fred.stlouisfed.org/series/M2SL
   - Columnas: Date, M2_Value_Billions
   - Formato: CSV mensual

8. **M2 Money Supply Eurozona**: Descarga desde ECB Data Portal[5]

**E. Activos Financieros (para contexto):**
9. **S&P 500**: Descarga desde DataHub o Yahoo Finance[9]
   - Columnas: Date, SP500_Close, Volume
   - Formato: CSV

10. **Bitcoin** (opcional pero interesante): Descarga desde CoinMarketCap o Kaggle[10]
    - Columnas: Date, BTC_Price_USD, Market_Cap, Volume

**F. Salarios e Ingresos:**
11. **Salarios ajustados por inflación USA**: Descarga desde FRED[11]
    - Serie: MEHOINUSA672N (Real Median Household Income)
    - Columnas: Date, Real_Income

**G. Precios de Commodities:**
12. **Petróleo WTI**: Descarga desde OpenDataBay o TradingEconomics[12]
    - Columnas: Date, WTI_Price_USD, PercentChange

### **2. Diseño del Almacén de Datos (Data Warehouse)**

#### **Diseño Conceptual (Modelo Dimensional):**

**Tabla de Hechos Principal: FACT_PURCHASING_POWER**
- fecha_id (FK)
- activo_id (FK)
- moneda_id (FK)
- precio_nominal
- precio_ajustado_inflacion
- variacion_porcentual
- poder_compra_relativo
- indice_valor (base 100 en año 2005)

**Dimensiones:**

1. **DIM_FECHA**
   - fecha_id (PK)
   - fecha_completa
   - año
   - mes
   - trimestre
   - dia_semana
   - es_festivo

2. **DIM_ACTIVO**
   - activo_id (PK)
   - nombre_activo (Oro, Plata, Bitcoin, S&P500, etc.)
   - tipo_activo (Metal precioso, Criptomoneda, Índice bursátil, Commodity)
   - unidad_medida
   - descripcion

3. **DIM_MONEDA**
   - moneda_id (PK)
   - codigo_moneda (USD, EUR, GBP)
   - nombre_moneda
   - pais_emisor
   - banco_central

4. **DIM_INDICADOR_ECONOMICO**
   - indicador_id (PK)
   - nombre_indicador (CPI, M2, Salario Real)
   - tipo_indicador
   - frecuencia_actualizacion

5. **FACT_INFLACION**
   - fecha_id (FK)
   - moneda_id (FK)
   - cpi_valor
   - inflacion_anual
   - inflacion_mensual
   - masa_monetaria_m2

### **3. Transformaciones para Pentaho Data Integration**

Aquí tienes las **transformaciones obligatorias** que debes implementar:

#### **Transformación 1: Integración y Limpieza de Datos de Metales Preciosos**

**Entrada:**
- oro_usd.csv (que ya tienes)
- plata_usd.csv
- platino_usd.csv

**Pasos en Pentaho:**
1. **CSV File Input** × 3 (para cada metal)
2. **Select Values**: Renombrar columnas a formato estándar (date, price, metal_type)
3. **Filter Rows**: Eliminar registros con precios nulos o cero
4. **Add Constants**: Agregar columna "tipo_activo" = "Metal Precioso"
5. **Merge Join** o **Append Streams**: Unir los tres datasets
6. **Sort Rows**: Ordenar por fecha
7. **Modified Java Script Value**: Crear columna "precio_oz_onza" normalizada
8. **Replace in String**: Corregir formatos de fecha inconsistentes
9. **Calculator**: Calcular variación diaria porcentual
10. **Table Output**: Cargar a tabla staging

#### **Transformación 2: Enriquecimiento con Datos de Inflación**

**Entrada:**
- Datos de metales (desde tabla staging)
- cpi_usa.csv
- cpi_eurozona.csv

**Pasos:**
1. **Table Input**: Leer datos de metales
2. **CSV File Input** × 2: Leer CPI USA y EUR
3. **Merge Join**: Unir por fecha (LEFT JOIN)
4. **Java Script**: Calcular precio ajustado por inflación
   ```javascript
   var precio_real = precio_nominal * (cpi_base / cpi_actual);
   ```
5. **Calculator Step**: Crear índice base 100 (año 2005)
6. **Database Lookup**: Enriquecer con datos de Wikidata (opcional)
7. **Denormaliser**: Pivotar datos mensuales a estructura analítica

#### **Transformación 3: Feature Engineering - Creación de Nuevas Características**

**Técnicas obligatorias a implementar:**

**a) Binning (Discretización):**
```
Modified Java Script Value:
if (inflacion_anual < 2) {
  categoria_inflacion = "Baja";
} else if (inflacion_anual < 5) {
  categoria_inflacion = "Moderada";
} else {
  categoria_inflacion = "Alta";
}
```

**b) One-Hot Encoding:**
- Row Denormaliser para categorías de activos
- Crear columnas: is_metal_precioso, is_criptomoneda, is_indice_bursatil

**c) Splitting (División de Campos):**
- Split Fields: Dividir fecha en año, mes, día
- Split Fields: Extraer década de la fecha

**d) Rolling Averages (Medias móviles):**
- Analytic Query: Calcular media móvil 30 días, 90 días, 365 días

**e) Ratios y Derivadas:**
- Calculator: Ratio oro/plata
- Calculator: Ratio precio_activo/CPI
- Calculator: Poder adquisitivo relativo = (precio_2005 / precio_actual) × 100

#### **Transformación 4: Gestión de Valores Faltantes**

**Pasos:**
1. **Detect Null Values**: Identificar registros con nulls
2. **If Field Value is Null**: Aplicar estrategias:
   - Precios: Interpolación lineal (usando Calculator con LAG/LEAD)
   - CPI: Rellenar con valor anterior (Memory Group By)
   - Fechas faltantes: Eliminar registro
3. **Data Validator**: Validar rangos (precios > 0, inflación entre -5% y 20%)

#### **Transformación 5: Tratamiento de Outliers**

**Pasos:**
1. **Group By**: Calcular media y desviación estándar por activo
2. **Calculator**: Calcular Z-score = (valor - media) / desv_std
3. **Filter Rows**: Identificar outliers (|Z-score| > 3)
4. **Switch/Case**: Decidir estrategia:
   - Outliers económicos reales (crisis): Mantener pero etiquetar
   - Errores de datos: Reemplazar con mediana
5. **Add Sequence**: Agregar flag "is_outlier"

#### **Transformación 6: Normalización y Estandarización**

**Pasos:**
1. **Normalizer**: Normalizar precios entre 0-1
2. **Calculator**: Estandarizar (Z-score)
3. **Row Normaliser**: Transponer datos para análisis temporal

### **4. Job de Pentaho (Workflow)**

Diseña un **Job principal** que orqueste todo:

```
START
  ↓
[Set Variables] (fechas, rutas)
  ↓
[Check File Exists] (Validar CSVs)
  ↓
[Trans: Carga_Metales_Preciosos]
  ↓
[Trans: Carga_Inflacion]
  ↓
[Trans: Carga_Tipos_Cambio]
  ↓
[Trans: Carga_M2_Money_Supply]
  ↓
[Trans: Integracion_Feature_Engineering]
  ↓
[Trans: Validacion_Calidad_Datos]
  ↓
[Trans: Carga_Dimension_Fecha]
  ↓
[Trans: Carga_Dimension_Activo]
  ↓
[Trans: Carga_Fact_Table]
  ↓
[Verify Results] (Check de registros)
  ↓
[Send Email Success/Failure]
  ↓
END
```

### **5. Transformación a Tripletas RDF (Schema.org)**

Para el **Apartado 5**, utiliza las siguientes clases de Schema.org:

**Clases principales:**
- **MonetaryAmount**: Para precios y valores
- **StatisticalPopulation**: Para agregaciones económicas
- **Dataset**: Para describir tus conjuntos de datos
- **TimeSeries**: Para series temporales
- **PropertyValue**: Para propiedades económicas

**Ejemplo de mapeo en OpenRefine o Python:**

```turtle
@prefix schema: <https://schema.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://tupractica.ua.es/oro/2024-10-01> a schema:Observation ;
    schema:observationDate "2024-10-01"^^xsd:date ;
    schema:measurementTechnique "Market Close Price" ;
    schema:variableMeasured [
        a schema:PropertyValue ;
        schema:name "Gold Price USD" ;
        schema:value "2640.50"^^xsd:decimal ;
        schema:unitCode "USD" ;
        schema:unitText "US Dollars per Troy Ounce"
    ] ;
    schema:propertyID "XAU/USD" .
```

**Enriquecimiento con Wikidata:**
- Enlaza entidades como "Gold" → Wikidata Q897 (oro)
- "US Dollar" → Wikidata Q4917 (dólar estadounidense)
- "Federal Reserve" → Wikidata Q193556

### **6. Visualizaciones Recomendadas**

**Visualización 1: Línea Temporal Comparativa**
- Eje X: Años (2005-2025)
- Eje Y: Índice de valor (base 100 en 2005)
- Líneas: Oro, Plata, USD (poder adquisitivo), EUR, Bitcoin
- Herramienta: Tableau, Power BI o D3.js

**Visualización 2: Mapa de Calor de Correlaciones**
- Matriz de correlación entre: Oro, Plata, CPI, M2, Tipos de cambio
- Herramienta: Python (Seaborn) + Matplotlib

### **7. Estructura de Archivos GitHub**

```
/proyecto-degradacion-fiat/
├── README.md
├── LICENSE
├── /datos/
│   ├── /raw/
│   │   ├── oro_usd.csv
│   │   ├── plata_usd.csv
│   │   ├── cpi_usa.csv
│   │   ├── eur_usd.csv
│   │   └── m2_money_supply.csv
│   ├── /procesados/
│   │   ├── metales_integrados.csv
│   │   ├── indicadores_economicos.csv
│   │   └── dataset_final.csv
│   └── /rdf/
│       └── datos_economicos.ttl
├── /pentaho/
│   ├── /transformaciones/
│   │   ├── 01_carga_metales.ktr
│   │   ├── 02_integracion_inflacion.ktr
│   │   ├── 03_feature_engineering.ktr
│   │   └── 04_carga_datawarehouse.ktr
│   └── /jobs/
│       └── job_principal.kjb
├── /sql/
│   ├── 01_crear_esquema.sql
│   ├── 02_dimensiones.sql
│   └── 03_fact_tables.sql
├── /visualizaciones/
│   ├── dashboard_power_bi.pbix
│   └── graficos.html
├── /codigo/
│   ├── enriquecimiento_wikidata.py
│   └── conversion_rdf.py
├── /documentacion/
│   ├── memoria.pdf
│   └── presentacion.pptx
└── /imagenes/
    ├── modelo_conceptual.png
    ├── modelo_logico.png
    └── capturas_pentaho/
```

### **8. Preguntas de Investigación Sugeridas**

1. **¿Cuánto poder adquisitivo ha perdido el dólar estadounidense frente al oro en los últimos 20 años?**
   - Métrica: Onzas de oro que se pueden comprar con $1000 en 2005 vs 2025

2. **¿Existe correlación entre el aumento de M2 Money Supply y la devaluación de monedas fiat?**
   - Análisis de correlación Pearson entre M2 y CPI

3. **¿Qué activo ha sido el mejor refugio contra la inflación: oro, plata o Bitcoin?**
   - Comparación de rendimientos ajustados por inflación

4. **¿Cómo han variado los tipos de cambio EUR/USD en relación con la política monetaria?**
   - Análisis temporal con eventos económicos clave

### **Resumen Ejecutivo**

**Lo que DEBES hacer:**

1. **Descargar al menos 8-10 fuentes de datos** en diferentes formatos (CSV, Excel, API)
2. **Crear 15-20 transformaciones en Pentaho** que incluyan todas las técnicas obligatorias
3. **Diseñar un Data Warehouse dimensional** con al menos 4 dimensiones y 2 tablas de hechos
4. **Implementar un Job complejo** que orqueste todas las transformaciones
5. **Convertir al menos 1000 registros a RDF** usando Schema.org
6. **Enriquecer con Wikidata** al menos 10 entidades
7. **Crear 2 visualizaciones interactivas** que respondan tus preguntas de investigación
8. **Documentar TODO** en memoria de 8 páginas + README.md completo

**Ventajas de esta aproximación:**
- Múltiples fuentes y formatos (cumple requisitos Pentaho)
- Temática actual y relevante (devaluación fiat es muy discutida)
- Datos reales y verificables (no sintéticos)
- Permite aplicar TODAS las técnicas obligatorias
- Genera insights económicos interesantes
- Fácil de enriquecer con Wikidata
- Visualizaciones impactantes

Esta estructura te permitirá obtener una excelente calificación cumpliendo todos los apartados del 1 al 8 del enunciado.[4][13][14][15][16][17][18][19][1][3][8][9]

[1](https://www.kaggle.com/datasets/etiennekaiser/gold-silver-platinum-prices-1969-now-usd-gbp-eur/data)
[2](https://www.perthmint.com/invest/information-for-investors/metal-prices/historical-metal-prices/)
[3](https://datahub.io/core/cpi-us)
[4](https://www.bls.gov/cpi/data.htm)
[5](https://data.ecb.europa.eu)
[6](https://fxds-hcc.oanda.com/lang/es)
[7](https://www.bde.es/webbe/es/estadisticas/compartido/datos/xlsx/tc_1_1.xlsx)
[8](https://fred.stlouisfed.org/series/M2SL)
[9](https://datahub.io/core/s-and-p-500)
[10](https://coinmarketcap.com/currencies/bitcoin/historical-data/)
[11](https://fred.stlouisfed.org/series/MEHOINUSA672N)
[12](https://www.opendatabay.com/data/ai-ml/d24251d1-12d9-40a4-a466-145859a55ece)
[13](https://economex.blog/2024/03/19/el-bitcoin-no-tiene-techo-porque-el-dinero-fiat-no-tiene-fondo/)
[14](https://mises.org/es/mises-wire/cuando-la-moneda-fiat-deja-de-ser-dinero)
[15](https://www.criptonoticias.com/finanzas/3-claves-colapso-monedas-fiat-bitcoin/)
[16](https://murciaeconomia.com/art/92022/del-oro-al-dinero-fiat-las-raices-de-todas-las-crisis)
[17](https://www.worldbank.org/en/research/brief/inflation-database)
[18](https://www.ceicdata.com/en/indicator/united-states/money-supply-m2)
[19](https://ycharts.com/indicators/us_m2_money_supply)
[20](https://tradingeconomics.com/euro-area/inflation-cpi)
[21](https://www.in2013dollars.com/us/inflation/1995?amount=555555)
[22](https://www.in2013dollars.com/us/inflation/1995?amount=100800)
[23](https://wise.com/gb/currency-converter/usd-to-eur-rate/history)
[24](https://www.officialdata.org/canada/inflation/1995?amount=100&endYear=2025)
[25](https://ec.europa.eu/eurostat/web/purchasing-power-parities/information-data)
[26](https://www.iefweb.org/wp-content/uploads/2023/11/despues_del_dolar-2.pdf)
[27](https://wise.com/gb/currency-converter/eur-to-usd-rate/history)
[28](https://www.imf.org/external/datamapper/PPPEX@WEO/OEMDC)
[29](https://es.investing.com/analysis/humillacion-historica-de-las-monedas-fiat-200479270)
[30](https://www.investing.com/currencies/eur-usd-historical-data)
[31](https://www.oecd.org/en/data/insights/data-explainers/2024/06/purchasing-power-parities---frequently-asked-questions-faqs.html)
[32](https://es.investing.com/analysis/la-caida-del-imperio-fiat-200445799)
[33](https://ec.europa.eu/eurostat/web/hicp/database)
[34](https://www.coinlore.com/coin/bitcoin/historical-data)
[35](https://www.barchart.com/stocks/quotes/$SPX/historical-download)
[36](https://charts.bitbo.io/price/)
[37](https://silverprice.org/silver-price-history.html)
[38](https://stooq.com/db/h/)
[39](https://ycharts.com/indicators/bitcoin_price)
[40](https://tradingeconomics.com/commodity/silver)
[41](https://www.investing.com/indices/spain-35-historical-data)
[42](https://bitcoinmagazine.com/guides/bitcoin-price-history)
[43](https://www.economies.com/commodities/silver-analysis)
[44](https://finance.yahoo.com/quote/%5EIBEX/history/)
[45](https://silverprice.org)
[46](https://www.kaggle.com/datasets/henryhan117/sp-500-historical-data)
[47](https://www.bankrate.com/investing/bitcoin-price-history/)
[48](https://auronum.co.uk/gold-price-news/historic-gold-price-data/)
[49](https://es.investing.com/indices/us-spx-500-historical-data)
[50](https://www.youtube.com/watch?v=-yyQHRvTIy0)
[51](https://landofforex.com/sites/611.html)
[52](https://github.com/datasets/cpi)
[53](https://www.youtube.com/watch?v=J7bG_fKWQsw)
[54](https://oecdstatistics.blog/2024/04/10/new-purchasing-power-parities-reveal-large-relative-cost-of-living-difference-across-the-oecd-in-2022/)
[55](https://catalog.data.gov/dataset/consumer-price-index-cpi-ee18b)
[56](https://ec.europa.eu/eurostat/web/products-manuals-and-guidelines/w/ks-gq-24-011)
[57](https://tradingeconomics.com/united-states/consumer-price-index-cpi)
[58](https://tradingeconomics.com/world/inflation-consumer-prices-annual-percent-wb-data.html)
[59](https://db.nomics.world/OECD/DSD_PPP@DF_PPP)
[60](https://wmich.edu/economics/world-bank-databank)
[61](https://statsnz.contentdm.oclc.org/digital/api/collection/p20045coll4/id/462/download)
[62](https://www.bls.gov/cpi/tables/supplemental-files/)
[63](https://www.statssa.gov.za/?p=18421)
[64](https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceindices/current)
[65](https://fred.stlouisfed.org/tags/series?t=cpi%3Bworld+bank)
[66](https://wise.com/es/currency-converter/eur-to-usd-rate/history)
[67](https://www.philadelphiafed.org/surveys-and-data/data-sources)
[68](https://es.statista.com/estadisticas/606660/media-anual-de-la-tasa-de-cambio-de-euro-a-dolar-estadounidense/)
[69](https://tradingeconomics.com/united-states/housing-index)
[70](https://www.opendatabay.com/data/dataset/3867aa7b-51c4-4590-b453-a0f358283577)
[71](https://wise.com/es/currency-converter/usd-to-eur-rate/history)
[72](https://www.fhfa.gov/data/hpi)
[73](https://firstratedata.com/i/futures/CL)
[74](https://www.redfin.com/news/data-center/)
[75](https://portaracqg.com/futures/int/et)
[76](https://www.myfxbook.com/es/forex-market/currencies/EURUSD-historical-data)
[77](https://tradingeconomics.com/united-states/house-price-index-yoy)
[78](https://www.barchart.com/futures/quotes/CLJ695C/price-history/historical)
[79](https://www.nar.realtor/research-and-statistics/housing-statistics/existing-home-sales)
[80](https://www.bde.es/webbe/es/estadisticas/compartido/datos/csv/catalogo_tc.csv)
[81](https://fred.stlouisfed.org/series/EXHOSLUSM495S)
[82](https://www.statista.com/statistics/185369/median-hourly-earnings-of-wage-and-salary-workers/)
[83](https://es.wikipedia.org/wiki/Poblaci%C3%B3n_mundial)
[84](https://www.caixabankresearch.com/sites/default/files/content/file/2018/04/155art11-funcas-retos-alos-que-se-enfrentan-la-fed-y-el-bce-oriol-aspachs.pdf)
[85](https://www.worldometers.info/es/poblacion-mundial/)
[86](https://www.statista.com/statistics/187729/total-us-money-stock-for-m2-since-1990/)
[87](https://www.reddit.com/r/dataisbeautiful/comments/1b8pulg/inflationadjusted_minimum_wage_in_the_us_oc/)
[88](https://www.unfpa.org/es/data/world-population-dashboard)
[89](https://ycharts.com/indicators/us_m2_money_supply_yoy)
[90](https://ourworldindata.org/population-growth)
[91](https://www.tradingview.com/symbols/FRED-M2SL/)
[92](https://www.bls.gov/eci/)
[93](https://ourworldindata.org/grapher/population)
[94](https://fred.stlouisfed.org/series/CES0500000003)
[95](https://en.wikipedia.org/wiki/Demographics_of_the_world)
[96](https://tradingeconomics.com/united-states/money-supply-m2)
[97](https://www.atlantafed.org/chcs/wage-growth-tracker)