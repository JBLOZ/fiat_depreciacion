# PRÁCTICA INTEGRADA: DEPRECIACIÓN DEL EURO Y EROSIÓN DEL PODER ADQUISITIVO EN ESPAÑA
## Plan detallado de ejecución para Adquisición y Preparación de Datos

**Asignatura:** Adquisición y Preparación de Datos  
**Grado:** Ingeniería en Inteligencia Artificial  
**Universidad de Alicante - Escuela Politécnica Superior  
**Fecha límite:** 22 de diciembre de 2025**

---

## PRESENTACIÓN EJECUTIVA

Esta práctica propone un análisis integrado del deterioro del poder adquisitivo de las familias españolas en los últimos 15 años (2010–2025), vinculándolo explícitamente con la dinámica de depreciación del euro, la evolución de precios (HICP/IPC), salarios nominales y reales, evolución de índices bursátiles (IBEX-35), tipos de cambio (EUR/USD) y precio del oro como activo de cobertura de valor. La práctica demostrará cómo diseñar, construir, validar y visualizar un almacén de datos macroeconomético bajo metodología Kimball, aplicando ETL con Pentaho Data Integration y Python, transformación a schema.org y análisis reproducible completo en GitHub.

---

## APARTADO 1: DEFINICIÓN DEL PROYECTO CENTRADO EN LOS DATOS (10%)

### 1.1 Temática y Dominio del Proyecto

**Temática:** Macroeconomía Aplicada - Erosión del Poder Adquisitivo en España  
**Geográfico:** España (enfoque nacional con posible desglose regional)  
**Temporal:** 2010–2025 (15 años, cubriendo pre-crisis post-2008 y crisis COVID)  
**Dominio funcional:** Análisis de indicadores macroeconométricos y activos financieros

### 1.2 Problema a Resolver (Método 4W)

- **Who (Quién):** Economistas, policy-makers, familias españolas, inversores, académicos
- **What (Qué):** ¿Cuánto ha perdido poder adquisitivo el salario medio de una familia española en los últimos 15 años y qué factores lo explican?
- **Where (Dónde):** Territorio español; comparativas con zona euro donde aplique
- **Why (Por qué):** La inflación acumulada, la depreciación del euro y la estancamiento salarial nominal son fenómenos entrelazados de gran relevancia política y social

### 1.3 Preguntas de Investigación Claras y Evaluables

**P1:** ¿Cómo ha evolucionado el índice de poder adquisitivo real en España entre 2010 y 2025, deflactado por IPC y reindexado a base 100 en 2010?

**P2:** ¿Qué relación existe entre la inflación interanual (HICP) y la variación de salarios reales? ¿Hay períodos de desacoplamiento severo?

**P3:** ¿En qué medida el precio del oro en EUR (convertido mediante USD/EUR diario) se correlaciona con la pérdida de poder adquisitivo, sugiriendo una demanda de activos refugio?

**P4:** ¿Cómo se correlacionan los rendimientos del IBEX-35 con la erosión del poder adquisitivo de los hogares? ¿Es la renta variable una cobertura efectiva contra la inflación?

**P5:** ¿Cuál ha sido el impacto acumulado de depreciación del euro (EUR/USD) sobre el poder adquisitivo en términos de importaciones y activos externos?

### 1.4 Objetivos del Proyecto

1. **Objetivo Principal (OP):** Construir un almacén de datos multidimensional reproducible que integre series macro españolas, validar la calidad de los datos, responder a P1–P5 mediante visualizaciones y análisis y documentar el proceso completo en un repositorio público GitHub.

2. **Objetivos Secundarios:**
   - OS1: Diseñar un esquema estrella Kimball con tabla de hechos de indicadores temporales y dimensiones de tiempo, indicador, geografía, fuente y unidad.
   - OS2: Implementar un pipeline ETL robusto con Pentaho Data Integration que incluya extracción, limpieza, normalización, enriquecimiento y validación de calidad.
   - OS3: Transformar una muestra representativa de datos a tripletas RDF/JSON-LD según schema.org (Dataset, Observation, PropertyValue, Organization, Place).
   - OS4: Producir dos visualizaciones interactivas que respondan directamente a P1 y P3, con anotaciones interpretativas y guías de lectura.
   - OS5: Generar una memoria ejecutiva integrada (≤8 páginas) con coherencia metodológica, trazabilidad y limitaciones explícitas.

### 1.5 Casos de Uso

| # | Caso de Uso | Descripción | Métrica de Éxito |
|---|---|---|---|
| **UC1** | Monitor de poder adquisitivo | Seguimiento mensual/trimestral de evolución del poder adquisitivo real por sector/región | Índice base 100 actualizado, desviación < 2% respecto a fuentes oficiales |
| **UC2** | Análisis de shocks inflacionarios | Identificar períodos de inflación anómala y su impacto en salarios reales | Correlación con eventos macroeconómicos (Brexit, COVID, subida tipos, etc.) |
| **UC3** | Comparación inflación vs. salarios | Cuantificar "gap" acumulado entre inflación y crecimiento salarial nominal | Retraso medio en meses, gap acumulado en % |
| **UC4** | Análisis de cobertura de activos | Evaluar si inversión en IBEX-35 y oro cubre pérdida de poder adquisitivo | Correlación, Sharpe ratio ajustado por inflación |
| **UC5** | Forecasting exploratorio | Base para modelos predictivos de poder adquisitivo y depreciación | Datos validados y transformados listos para modelos econométricos |

### 1.6 Métricas Clave para Evaluar Éxito

| Métrica | Fórmula/Definición | Umbral Aceptable |
|---|---|---|
| **Cobertura temporal** | % de meses/trimestres con datos válidos en 2010–2025 | ≥95% |
| **Consistencia entre fuentes** | RMSE normalizado (IPC vs HICP) | <1% |
| **Poder adquisitivo real** | \(PA_{real,t} = 100 \cdot \frac{w_{t,real}}{w_{2010,real}}\) | Índice base 100 en 2010 |
| **Deflactación de salarios** | \(w_{real} = \frac{w_{nominal}}{CPI_t/100}\) | Alineado con INE |
| **Correlación oro–inflación** | Correlación de Pearson(Oro EUR, Inflación YoY) | Esperado: 0.5–0.7 |
| **Rendimiento IBEX ajustado** | \(r_{IBEX,ajustado} = r_{IBEX} - inflación\) | Comparación con CPI |
| **Completitud ETL** | % de transformaciones ejecutadas sin error | 100% |
| **Calidad de validación** | Registros sin errores / registros totales × 100 | ≥98% |
| **Trazabilidad documentada** | Cada transformación mapeada a entrada, script y salida | 100% |

---

## APARTADO 2: ANÁLISIS Y EVALUACIÓN DE NECESIDADES DE DATOS (10%)

### 2.1 Requisitos Funcionales de Datos

| Pregunta | Datos Necesarios | Granularidad | Período | Justificación |
|---|---|---|---|---|
| **P1** | Salarios (nominal, real); IPC/HICP | Mensual o trimestral | 2010–2025 | Deflactación directa |
| **P2** | IPC/HICP mensual; Salarios trimestrales | Mensual (IPC), trimestral (salarios) | 2010–2025 | Análisis de rezago |
| **P3** | Oro (USD/oz); EUR/USD diario | Diario → mensual | 2010–2025 | Conversión de moneda |
| **P4** | IBEX-35 cierre diario; Rentabilidad total | Diario → mensual | 2010–2025 | Retornos logarítmicos |
| **P5** | EUR/USD diario; Índice de importaciones | Diario → mensual | 2010–2025 | Depreciación, elasticidades |

### 2.2 Inventario de Datasets Candidatos

#### **Dataset 1: IPC/HICP España (Inflación)**

| Atributo | Especificación |
|---|---|
| **Fuente primaria** | INE (Instituto Nacional de Estadística), Eurostat |
| **URL** | `https://www.ine.es/` (IPC); `https://ec.europa.eu/eurostat/` (HICP) |
| **Formato disponible** | CSV, JSON, API REST |
| **Granularidad temporal** | Mensual (desde 1985); diario interpolable |
| **Granularidad geográfica** | Nacional, regional (17 CCAA), por grandes grupos (energía, vivienda, alimentación, etc.) |
| **Período cubierto** | 2010–2025 (completo) |
| **Licencia** | CC-BY-4.0 (INE), CC-BY-4.0 (Eurostat) |
| **Campos clave** | date, region, category, ipc_index, ipc_yoy_pct, hicp_index, hicp_yoy_pct, base_year |
| **Criterios de selección** | IPC oficial (base 2021 más reciente); HICP para comparabilidad europea |
| **Incertidumbre/Limitaciones** | Cambios de base; revisiones retroactivas; agregación de índices debe ser ponderada |

#### **Dataset 2: Salarios Nominales y Reales España**

| Atributo | Especificación |
|---|---|
| **Fuente primaria** | INE (Encuesta de Estructura Salarial, Índice de Coste Laboral Armonizado) |
| **URL** | `https://www.ine.es/` |
| **Formato disponible** | CSV, descarga directa |
| **Granularidad temporal** | Trimestral (bienal para Encuesta de Estructura); mensual (Índice de Coste) |
| **Granularidad geográfica** | Nacional, por sector (CNAE), por tamaño de empresa |
| **Período cubierto** | 2010–2025 |
| **Licencia** | CC-BY-4.0 |
| **Campos clave** | date, sector, wage_nominal_index, wage_real_index (si disponible), employment_count |
| **Criterios de selección** | Usar índice de coste laboral armonizado (comparable); deflactar con CPI si es necesario |
| **Incertidumbre/Limitaciones** | Cobertura sector privado/público diferente; autocorrecciones; no incluye autónomos completamente |

#### **Dataset 3: Oro (Precio en USD y EUR)**

| Atributo | Especificación |
|---|---|
| **Fuente primaria** | World Gold Council, LBMA, KITCO |
| **URL** | `https://www.kitco.com/` (datos históricos); `https://www.lbma.org.uk/` |
| **Formato disponible** | CSV descargable, API (limitado) |
| **Granularidad temporal** | Diario (fixing LBMA a las 15:00 UK) |
| **Granularidad geográfica** | Global (precio único cotizado en USD, EUR) |
| **Período cubierto** | 2010–2025 |
| **Licencia** | Público con atribución |
| **Campos clave** | date, price_usd_per_oz, price_eur_per_oz (derivado) |
| **Criterios de selección** | PM fix (afternoon fixing) para consistencia; usar precio en EUR convertido diariamente |
| **Incertidumbre/Limitaciones** | Volatilidad diaria alta; fines de semana sin cotización; conversión depende de tipo EUR/USD |

#### **Dataset 4: Tipo de Cambio EUR/USD**

| Atributo | Especificación |
|---|---|
| **Fuente primaria** | BCE (Banco Central Europeo), OANDA, Yahoo Finance |
| **URL** | `https://www.ecb.europa.eu/` (histórico diario); `https://www.oanda.com/currency/historical-rates/` |
| **Formato disponible** | CSV, JSON, API REST |
| **Granularidad temporal** | Diario (cierre del mercado) |
| **Granularidad geográfica** | Global (par único EUR/USD) |
| **Período cubierto** | 2010–2025 |
| **Licencia** | Público (BCE, OANDA) |
| **Campos clave** | date, eur_usd_rate, source |
| **Criterios de selección** | Tipo de cambio de cierre o media diaria; preferir BCE para consistencia oficial |
| **Incertidumbre/Limitaciones** | Diferencias < 0.2% entre fuentes; fines de semana sin datos; saltos por noticias |

#### **Dataset 5: IBEX-35 y Rentabilidad Total**

| Atributo | Especificación |
|---|---|
| **Fuente primaria** | BME (Bolsas y Mercados Españoles), Yahoo Finance, Investing.com |
| **URL** | `https://www.bolsasymercados.es/` |
| **Formato disponible** | CSV descargable desde BME; JSON desde Yahoo Finance API |
| **Granularidad temporal** | Diario (sesión de mercado) |
| **Granularidad geográfica** | Índice agregado España |
| **Período cubierto** | 2010–2025 |
| **Licencia** | Uso académico/personal permitido |
| **Campos clave** | date, close, open, high, low, volume, total_return_index (si disponible) |
| **Criterios de selección** | Usar cierre de sesión; si disponible, total_return_index (incluye dividendos); sino, ajustar post-hoc |
| **Incertidumbre/Limitaciones** | Split de acciones/dividendos pueden afectar; fines de semana sin cotización; crisis COVID con cierres |

#### **Dataset 6: Datos Adicionales Contextuales (Opcionales pero Recomendados)**

- **Desempleo España (INE):** Tasa de paro trimestral, por región, para contexto social
- **Energía/Materias Primas (Indexmundi, Banco Mundial):** Índice de precios de energía, alimentos, para análisis de causas de inflación
- **Remesas/Flujos migratorios (INE):** Para contexto de vulnerabilidad familiar
- **Datos de empleo público vs. privado:** Para análisis sectorial de salarios

### 2.3 Plan de Reconfiguración de Preguntas (Si fuera necesario)

Si durante la recopilación se encuentra que:
- **Salarios trimestrales no disponibles desagregados por sector:** Se simplificaría P2 a nivel nacional agregado
- **Oro en EUR no histórico:** Se calcularía directamente mediante conversión diaria EUR/USD × Oro USD
- **IBEX Total Return Index no disponible:** Se usaría cierre diario y se adjustaría manualmente por dividendos conocidos o se usaría un índice alternativo (FTSE Ibex Total Return si existe)

**Redefinición documentada:** Toda redefinición será anotada en un archivo `CHANGES.md` en el repositorio con justificación y impacto en las P1–P5.

### 2.4 Justificación de Datos Ficticios (Si Aplica)

**Supuesto inicial:** Se asume disponibilidad de datos reales de todas las fuentes mencionadas. Si alguna fuente falla (ej: IBEX histórico completo), se completará la serie con:
- Interpolación lineal para huecos < 5 días consecutivos (fines de semana OK)
- Imputación múltiple (KNN) para series > 30 días faltantes
- Notación explícita en cada registro: campo `data_source_quality = {real, interpolated, imputed}` con probabilidad de imputación

No se usarán datos completamente sintéticos; se documentarán todas las técnicas de imputación.

### 2.5 Matriz de Selección de Datasets (Crítico vs. Importante)

| Dataset | Criticidad | Importancia | Selección Final | Fallback |
|---|---|---|---|---|
| IPC/HICP | CRÍTICO | A | ✓ Sí | Usar ambas en validación cruzada |
| Salarios | CRÍTICO | A | ✓ Sí | INE + Banco de España |
| EUR/USD | CRÍTICO | A | ✓ Sí | BCE oficial |
| Oro USD/EUR | IMPORTANTE | B | ✓ Sí | KITCO + conversión manual |
| IBEX-35 | IMPORTANTE | B | ✓ Sí | Yahoo Finance si BME falla |
| Desempleo | IMPORTANTE | C | ✓ Contexto | INE trimestral |

---

## APARTADO 3: DISEÑO CONCEPTUAL, LÓGICO Y FÍSICO DEL ALMACÉN DE DATOS (15%)

### 3.1 Diseño Conceptual: Identificación de Hechos y Dimensiones

#### **Proceso de Negocio Principal**
"Registro y análisis de indicadores macroeconómicos españoles para evaluación del poder adquisitivo"

#### **Hechos Identificados (Magnitudes Medibles)**
1. **Inflación (IPC/HICP):** Índice base 100, variación interanual
2. **Salarios:** Nominales e índice real (deflactado)
3. **Oro:** Precio en USD y EUR por onza troy
4. **Tipos de cambio:** EUR/USD
5. **IBEX-35:** Cierre, retorno logarítmico, total return
6. **Desempleo:** Tasa de paro

#### **Dimensiones Identificadas (Contexto Analítico)**
1. **Tiempo:** Fecha, mes, trimestre, año, período fiscal, festivos
2. **Indicador:** Tipo de variable (IPC, salario, oro, etc.), unidad, fórmula de cálculo
3. **Geografía:** País, región (CC.AA.), ciudad (opcional), zona euro
4. **Fuente:** Institución origen (INE, Eurostat, BCE, LBMA, BME, Yahoo), URL, licencia
5. **Unidad:** EUR, USD, índice base 100, %, oz, decimales

### 3.2 Matriz Dimensional Multidimensional

```
Observación Temporal = f(Tiempo, Indicador, Geografía, Fuente, Unidad)

Ejemplos:
- (2023-01, IPC_ES, España, INE, %) = 3.5
- (2023-01, Salario_Nominal, España, INE, EUR) = 1450.5
- (2023-01, Oro_EUR, Global, LBMA, EUR/oz) = 2145.3
- (2023-01, EUR_USD, Global, BCE, Rate) = 1.052
- (2023-01, IBEX35_Close, España, BME, Índice) = 9250.4
```

### 3.3 Modelo Conceptual ER (Entidad-Relación)

```
INDICADOR
├── indicador_id (PK)
├── nombre
├── descripción
├── fórmula_cálculo
├── tipo (agregable, no_agregable)
└── categoría (inflación, mercado_trabajo, activos_financieros)

FUENTE
├── fuente_id (PK)
├── institución
├── URL
├── licencia
└── frecuencia_actualización

GEOGRAFÍA
├── geo_id (PK)
├── nombre
├── código_iso
├── tipo (país, región, zona)
└── padre_geo_id (FK a GEOGRAFÍA)

TIEMPO (dimension estándar)
├── fecha_id (PK)
├── fecha
├── día, mes, trimestre, año
├── es_festivo
└── período_fiscal

UNIDAD
├── unidad_id (PK)
├── símbolo (EUR, USD, %, índice)
└── descripción

HECHOS_INDICADORES_TEMPORALES (Tabla de Hechos)
├── fecha_id (FK → TIEMPO)
├── indicador_id (FK → INDICADOR)
├── geo_id (FK → GEOGRAFÍA)
├── unidad_id (FK → UNIDAD)
├── fuente_id (FK → FUENTE)
├── valor (DECIMAL(15,4))
├── valor_anterior (para cálculo de variaciones)
├── calidad_dato (real, interpolado, imputado)
├── ts_actualizacion (TIMESTAMP)
└── PRIMARY KEY (fecha_id, indicador_id, geo_id, unidad_id, fuente_id)
```

### 3.4 Diseño Lógico: Esquema Estrella

```
┌─────────────────────────────────────────────────────────────┐
│                      DIM_TIEMPO                              │
├─────────────────────────────────────────────────────────────┤
│ tiempo_key (PK) INTEGER                                      │
│ fecha DATE                                                   │
│ año SMALLINT                                                 │
│ mes TINYINT                                                  │
│ trimestre TINYINT                                            │
│ semana TINYINT                                               │
│ día_semana TINYINT                                           │
│ es_festivo BOOLEAN                                           │
│ período_fiscal VARCHAR(10)                                   │
└─────────────────────────────────────────────────────────────┘
                          △
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│DIM_INDICADOR │  │DIM_GEOGRAFIA │  │DIM_UNIDAD    │
├──────────────┤  ├──────────────┤  ├──────────────┤
│ind_key (PK)  │  │geo_key (PK)  │  │unit_key (PK) │
│nombre        │  │nombre        │  │símbolo       │
│descripción   │  │código_iso    │  │descripción   │
│fórmula       │  │tipo          │  │tipo_medida   │
│categoría     │  │región_padre  │  │precisión     │
│agregable     │  │jerarquía     │  │               │
└──────────────┘  └──────────────┘  └──────────────┘
        △                 △                 △
        └─────────────────┼─────────────────┘
                          │
                          ▼
        ┌─────────────────────────────────┐
        │  HECHOS_INDICADORES_TEMPORALES  │
        ├─────────────────────────────────┤
        │ tiempo_key (FK) INTEGER         │
        │ indicador_key (FK) INTEGER      │
        │ geo_key (FK) INTEGER            │
        │ unit_key (FK) INTEGER           │
        │ fuente_key (FK) INTEGER         │
        │ valor DECIMAL(15,4)             │
        │ valor_anterior DECIMAL(15,4)    │
        │ variación_pct DECIMAL(6,3)      │
        │ calidad ENUM                    │
        │ ts_actualización TIMESTAMP      │
        │ PRIMARY KEY (tiempo_key,        │
        │   indicador_key, geo_key,       │
        │   unit_key, fuente_key)         │
        └─────────────────────────────────┘
                          △
                          │
                          ▼
        ┌─────────────────────────────────┐
        │     DIM_FUENTE                  │
        ├─────────────────────────────────┤
        │ fuente_key (PK) INTEGER         │
        │ institución VARCHAR(100)        │
        │ url_base VARCHAR(500)           │
        │ licencia VARCHAR(50)            │
        │ frecuencia_actualización INT    │
        │ contacto_responsable VARCHAR    │
        └─────────────────────────────────┘
```

#### **Justificación del Diseño Estrella**

- **Granularidad:** Un registro (hecho) por fecha, indicador, geografía y unidad. Permite consultas OLAP flexibles.
- **Desnormalización:** Las dimensiones incluyen todos los atributos descriptivos (ej: DIM_INDICADOR contiene fórmula, categoría), evitando joins posteriores.
- **Claves Sustitutas:** Todas las claves de dimensión son autogeneradas (integer), mejorando rendimiento.
- **Facilita:** Agregaciones rápidas (sum/avg/count), drill-down por período/región, análisis comparativo.

### 3.5 Diseño Físico: Schema SQL Completo

```sql
-- Secuencias para claves autogeneradas
CREATE SEQUENCE seq_tiempo_key START 1;
CREATE SEQUENCE seq_indicador_key START 1;
CREATE SEQUENCE seq_geografia_key START 1;
CREATE SEQUENCE seq_unidad_key START 1;
CREATE SEQUENCE seq_fuente_key START 1;

-- Tabla de Dimensión TIEMPO
CREATE TABLE dim_tiempo (
    tiempo_key INTEGER PRIMARY KEY DEFAULT nextval('seq_tiempo_key'),
    fecha DATE NOT NULL UNIQUE,
    año SMALLINT NOT NULL,
    mes TINYINT NOT NULL,
    trimestre TINYINT NOT NULL,
    semana TINYINT NOT NULL,
    día_semana TINYINT NOT NULL COMMENT '1=Lunes, 7=Domingo',
    es_festivo BOOLEAN DEFAULT FALSE,
    período_fiscal VARCHAR(10),
    INDEX idx_fecha (fecha),
    INDEX idx_año_mes (año, mes)
);

-- Tabla de Dimensión INDICADOR
CREATE TABLE dim_indicador (
    indicador_key INTEGER PRIMARY KEY DEFAULT nextval('seq_indicador_key'),
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripción TEXT,
    fórmula_cálculo VARCHAR(500),
    categoría VARCHAR(50) NOT NULL COMMENT 'inflación, salarios, activos_financieros, etc.',
    subcategoría VARCHAR(100),
    es_agregable BOOLEAN DEFAULT TRUE,
    unidad_base VARCHAR(20) NOT NULL,
    INDEX idx_categoría (categoría)
);

-- Tabla de Dimensión GEOGRAFÍA
CREATE TABLE dim_geografia (
    geo_key INTEGER PRIMARY KEY DEFAULT nextval('seq_geografia_key'),
    nombre VARCHAR(100) NOT NULL UNIQUE,
    código_iso VARCHAR(5),
    tipo ENUM('país', 'región', 'ciudad', 'zona_económica') NOT NULL,
    geo_padre_key INTEGER REFERENCES dim_geografia(geo_key),
    nivel_jerarquía TINYINT,
    INDEX idx_nombre (nombre),
    INDEX idx_tipo (tipo)
);

-- Tabla de Dimensión UNIDAD
CREATE TABLE dim_unidad (
    unit_key INTEGER PRIMARY KEY DEFAULT nextval('seq_unidad_key'),
    símbolo VARCHAR(20) NOT NULL UNIQUE,
    descripción VARCHAR(100),
    tipo_medida ENUM('moneda', 'índice', 'porcentaje', 'cantidad') NOT NULL,
    decimales TINYINT DEFAULT 2,
    INDEX idx_tipo_medida (tipo_medida)
);

-- Tabla de Dimensión FUENTE
CREATE TABLE dim_fuente (
    fuente_key INTEGER PRIMARY KEY DEFAULT nextval('seq_fuente_key'),
    institución VARCHAR(150) NOT NULL,
    url_base VARCHAR(500),
    licencia VARCHAR(50),
    país_origen VARCHAR(3),
    frecuencia_actualización INT COMMENT 'días entre actualizaciones',
    contacto_responsable VARCHAR(100),
    INDEX idx_institución (institución)
);

-- Tabla de HECHOS: INDICADORES TEMPORALES
CREATE TABLE hechos_indicadores_temporales (
    tiempo_key INTEGER NOT NULL,
    indicador_key INTEGER NOT NULL,
    geo_key INTEGER NOT NULL,
    unit_key INTEGER NOT NULL,
    fuente_key INTEGER NOT NULL,
    
    valor DECIMAL(15,4) NOT NULL,
    valor_anterior DECIMAL(15,4),
    variación_pct DECIMAL(6,3),
    
    calidad_dato ENUM('real', 'interpolado', 'imputado', 'estimado') DEFAULT 'real',
    probabilidad_imputación DECIMAL(3,2),
    
    ts_actualización TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ts_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (tiempo_key, indicador_key, geo_key, unit_key, fuente_key),
    FOREIGN KEY (tiempo_key) REFERENCES dim_tiempo(tiempo_key),
    FOREIGN KEY (indicador_key) REFERENCES dim_indicador(indicador_key),
    FOREIGN KEY (geo_key) REFERENCES dim_geografia(geo_key),
    FOREIGN KEY (unit_key) REFERENCES dim_unidad(unit_key),
    FOREIGN KEY (fuente_key) REFERENCES dim_fuente(fuente_key),
    
    INDEX idx_tiempo (tiempo_key),
    INDEX idx_indicador (indicador_key),
    INDEX idx_geo (geo_key),
    INDEX idx_fuente (fuente_key),
    INDEX idx_tiempo_indicador (tiempo_key, indicador_key),
    INDEX idx_valor_rango (valor)
);

-- Tablas auxiliares para AUDITORÍA y VALIDACIÓN

CREATE TABLE etl_logs (
    log_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_job VARCHAR(100) NOT NULL,
    timestamp_inicio TIMESTAMP NOT NULL,
    timestamp_fin TIMESTAMP,
    estado ENUM('iniciado', 'completado', 'error', 'advertencia') DEFAULT 'iniciado',
    registros_procesados INTEGER,
    registros_errores INTEGER,
    descripción_error TEXT,
    usuario VARCHAR(50),
    INDEX idx_fecha (timestamp_inicio)
);

CREATE TABLE validación_calidad (
    validación_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    fecha_validación TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    indicador_key INTEGER,
    geo_key INTEGER,
    tipo_validación VARCHAR(100) COMMENT 'rango, monotonicidad, unicidad, etc.',
    resultado BOOLEAN,
    descripción TEXT,
    acciones_tomadas TEXT,
    FOREIGN KEY (indicador_key) REFERENCES dim_indicador(indicador_key),
    FOREIGN KEY (geo_key) REFERENCES dim_geografia(geo_key)
);

CREATE TABLE trazabilidad_transformación (
    transformación_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_transformación VARCHAR(100) NOT NULL,
    descripción TEXT,
    entrada_dataset VARCHAR(100),
    salida_dataset VARCHAR(100),
    fórmula_aplicada TEXT,
    parámetros JSON,
    resultado_validación BOOLEAN,
    timestamp_ejecución TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 3.6 Índices para Rendimiento OLAP

```sql
-- Índices de rango temporal (consultas "desde X hasta Y")
CREATE INDEX idx_hh_tiempo_indicador_valor ON hechos_indicadores_temporales
    (tiempo_key DESC, indicador_key, valor);

-- Índices para drill-down por geografía
CREATE INDEX idx_hh_geo_tiempo_indicador ON hechos_indicadores_temporales
    (geo_key, tiempo_key DESC, indicador_key);

-- Índices para búsquedas de calidad de datos
CREATE INDEX idx_hh_calidad_dato ON hechos_indicadores_temporales
    (calidad_dato, tiempo_key DESC);

-- Índices en dimensiones para joins rápidos
CREATE INDEX idx_dim_tiempo_año_mes ON dim_tiempo (año, mes);
CREATE INDEX idx_dim_geografía_tipo ON dim_geografia (tipo, geo_key);

-- Índice de cobertura para evitar lecturas de tabla completa
CREATE INDEX idx_hh_cobertura ON hechos_indicadores_temporales
    (tiempo_key, indicador_key, geo_key, valor) INCLUDE (calidad_dato);
```

### 3.7 Diagrama Entidad-Relación (ERD) de Diseño Lógico

[Ver imagen adjunta: `DW_Macroeconomia_ES_Diagrama_Estrella.png`]

*(En un proyecto real, se generaría con Lucidchart, MySQL Workbench o Draw.io)*

### 3.8 Vistas Analíticas Estándar (Cubos OLAP)

```sql
-- Vista 1: Poder Adquisitivo Agregado Mensual (España, Índice base 100)
CREATE VIEW v_poder_adquisitivo_mensual AS
SELECT
    t.fecha,
    t.año,
    t.mes,
    CASE
        WHEN h.indicador_key = (SELECT indicador_key FROM dim_indicador WHERE nombre = 'Salario_Real')
        THEN h.valor
    END AS salario_real_idx,
    CASE
        WHEN h.indicador_key = (SELECT indicador_key FROM dim_indicador WHERE nombre = 'IPC_ES_100')
        THEN 10000 / h.valor  -- Inversa del IPC como proxy de poder de compra
    END AS poder_compra_inverso,
    h.variación_pct,
    f.institución
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_geografia g ON h.geo_key = g.geo_key AND g.nombre = 'España'
JOIN dim_fuente f ON h.fuente_key = f.fuente_key
WHERE h.indicador_key IN (
    SELECT indicador_key FROM dim_indicador 
    WHERE nombre IN ('Salario_Real', 'IPC_ES_100')
)
ORDER BY t.fecha DESC;

-- Vista 2: Correlación Inflación vs. Rendimiento IBEX
CREATE VIEW v_inflación_ibex_correlación AS
SELECT
    t.año,
    t.trimestre,
    AVG(CASE WHEN i.nombre = 'IPC_ES_YoY' THEN h.valor END) AS inflación_media,
    AVG(CASE WHEN i.nombre = 'IBEX35_Retorno_Log' THEN h.valor END) AS retorno_ibex_medio,
    COUNT(*) AS observaciones
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
WHERE i.nombre IN ('IPC_ES_YoY', 'IBEX35_Retorno_Log')
GROUP BY t.año, t.trimestre
ORDER BY t.año DESC, t.trimestre DESC;
```

### 3.9 Script de Creación Completo (PostgreSQL)

[Ver archivo adjunto: `crear_DW_macroeconomia.sql`]

Este script:
1. Crea todas las secuencias, tablas, índices y restricciones
2. Carga dimensiones maestras iniciales (dim_tiempo para 2010–2025, dim_indicador con 10+ indicadores, dim_geografía con España + 17 CCAA, dim_unidad con monedas/índices estándar)
3. Define vistas analíticas y procedimientos almacenados para validación

---

## APARTADO 4: LIMPIEZA, TRANSFORMACIÓN Y NORMALIZACIÓN DE DATOS CON PENTAHO ETL (20%)

### 4.1 Descripción General del Pipeline ETL

El pipeline ETL se estructurará como un **Job maestro en Pentaho** que orquesta 6 transformaciones (transformations) especializadas:

```
Job Maestro: ETL_MACROECONOMIA_PIPELINE
├─ Transformación 1: Extracción e Ingesta de Datos Brutos
├─ Transformación 2: Limpieza y Validación Inicial
├─ Transformación 3: Transformación y Enriquecimiento
├─ Transformación 4: Deflactación y Cálculo de Indicadores Derivados
├─ Transformación 5: Validación de Calidad y Auditoría
└─ Transformación 6: Carga a Data Warehouse

Cada transformación genera logs, reportes de calidad y artefactos de auditoría.
```

### 4.2 Transformación 1: Extracción e Ingesta de Datos Brutos

**Objetivo:** Conectar a fuentes de datos (archivos CSV, APIs, BD) y extraer datasets brutos.

**Componentes Pentaho a usar:**
1. **Text file input** - Para archivos CSV descarados de INE, Eurostat
2. **JSON input** - Para datos de Yahoo Finance, OANDA (si disponible en JSON)
3. **HTTP client** - Para llamadas a APIs REST (BCE, LBMA)
4. **Microsoft Excel input** - Si datos en .xlsx
5. **CSV file output** - Salida intermedia con datos raw

**Pseudocódigo de Transformación 1:**

```
INICIO
  PARA cada_fuente EN [INE_IPC, INE_Salarios, Eurostat_HICP, KITCO_Oro, BCE_EUR_USD, BME_IBEX]
    SI fuente.tipo == "CSV"
      READ CSV file_path=fuente.ruta
      APLICAR field_metadata: tipos, formatos, codificación=UTF-8
    SINO SI fuente.tipo == "API"
      LLAMAR HTTP GET url=fuente.url
      PARSEAR respuesta JSON
      MAPEAR campos a schema estándar
    SINO SI fuente.tipo == "BD"
      CONECTAR a BD con credenciales
      EJECUTAR query SELECT * FROM tabla
    FIN SI
    
    AGREGAR columnas metadatos:
      - source_dataset = fuente.nombre
      - extraction_date = TODAY()
      - row_hash = MD5(row) -- para deduplicación
    
    SALIDA: raw_<nombre_fuente>.csv
    LOG: completadas X filas, Y campos, Z errores
  FIN PARA
FIN
```

**Archivos de Entrada Esperados:**

| Fuente | Nombre Archivo | Columnas Esperadas | Formato |
|---|---|---|---|
| INE IPC | ipc_es_monthly_2010_2025.csv | date, index_100, yoy_pct, region | CSV UTF-8 |
| INE Salarios | salarios_índice_coste_laboral.csv | date, nominal_idx, sector, employees | CSV UTF-8 |
| Eurostat HICP | hicp_euro_zona_2010_2025.csv | date, index_100, yoy_pct, country | CSV UTF-8 |
| KITCO Oro | gold_prices_usd_2010_2025.csv | date, price_oz_usd | CSV |
| BCE EUR/USD | eurusd_rates_2010_2025.csv | date, rate | CSV |
| BME IBEX | ibex35_daily_2010_2025.csv | date, open, close, high, low, volume | CSV |

**Validaciones Iniciales:**
- Fechas en formato ISO 8601 (YYYY-MM-DD)
- Codificación UTF-8
- Valores numéricos con decimales usando "." como separador
- Filas duplicadas (por row_hash)

### 4.3 Transformación 2: Limpieza y Validación Inicial

**Objetivo:** Detectar y corregir anomalías, valores faltantes y errores de formato.

**Tareas obligatorias implementadas:**

#### **2.1 Corrección de Errores y Tipificación**

```pentaho_pseudocode
PASO 1: Filter rows - Excluir encabezados/metadatos no deseados
PASO 2: Trim fields - Eliminar espacios en blanco en todos los STRING
PASO 3: Replace in string - Convertir separadores decimales:
  - Si campo=="decimal" Y valor contiene "," → reemplazar "," con "."
PASO 4: Calculator - Conversión de tipos:
  - date_field = CAST(date_string AS DATE, "YYYY-MM-DD")
  - value_field = CAST(value_string AS DECIMAL, "#.##")
  - Si casting falla → marcar quality_flag = "error_tipo"
PASO 5: Error handler - Capturar filas con errores, enviar a tabla staging_errores
PASO 6: Select values - Proyectar solo columnas necesarias
```

**Reglas de Corrección Específicas:**

| Tipo de Error | Regla de Corrección | Acción si Falla |
|---|---|---|
| Separador decimal "," | Reemplazar por "." | Marcar como imputado |
| Fechas en formato MM/DD/YYYY | Convertir a YYYY-MM-DD | Marcar como error, rechazar fila |
| Campos vacíos ("", "NULL", "N/A") | Reemplazar con NULL (SQL) | Marcar para imputación posterior |
| Valores negativos inesperados (ej: índices) | Validar contra histórico; si anómalo, marcar | Registrar en auditoría |

#### **2.2 Gestión de Valores Faltantes**

```pentaho_pseudocode
PASO 1: Analizar densidad de NULLs por columna
PASO 2: SI % de NULLs < 5%
  → Forward-fill (last observation carried forward) para series temporales
  → Usar anterior valor válido del mismo indicador/geo
PASO 3: SI 5% ≤ % de NULLs < 20%
  → Imputación por media móvil (ventana 3 meses)
  → Marcar quality_flag = "imputado_media_móvil"
PASO 4: SI % de NULLs ≥ 20%
  → Rechazar serie o indicador para ese período
  → Documentar en log de calidad
PASO 5: Output: dataset_limpio_paso2.csv
```

**Fórmulas de Imputación Implementadas en Calculator:**

```
-- Media móvil de 3 meses
IF ISNULL(valor) THEN
  valor_imputado = (PREVIOUS_VALUE(1 mes) + PREVIOUS_VALUE(2 meses) + NEXT_VALUE(1 mes)) / 3
ELSE
  valor_imputado = valor
END

-- Forward-fill para huecos cortos
IF ISNULL(valor) AND fecha - fecha_anterior < 30 THEN
  valor_imputado = LAST_VALID_VALUE()
ELSE IF ISNULL(valor) THEN
  valor_imputado = NULL -- Rechazar fila
END
```

#### **2.3 Reducción de Redundancia y Deduplicación**

```pentaho_pseudocode
PASO 1: Sort rows - Ordenar por (date, indicador, geografía, fuente, valor)
PASO 2: Unique rows - Eliminar filas completamente duplicadas
  - Clave de deduplicación: (date, indicador_código, geo_código)
  - Si duplicados: mantener registro con source_priority = 1 (ej: INE > Eurostat)
PASO 3: Group by - Agregar duplicados con distinto valor:
  - Si |valor_1 - valor_2| / valor_1 < 1% → considerar igual, promediar
  - Si diferencia > 1% → registrar en tabla auditoría "duplicados_conflictivos"
PASO 4: Output: dataset_deduplicado_paso2.csv
LOG: X duplicados exactos eliminados, Y conflictos registrados
```

#### **2.4 Feature Engineering y Codificación de Nuevas Características**

```pentaho_pseudocode
-- Cálculo de variación interanual (YoY)
PASO 1: Join rows - Unir consigo mismo con offset de 12 meses
  LEFT JOIN dataset d1 ON d2.fecha = d1.fecha + 12 meses
  
PASO 2: Calculator - Calcular variaciones
  variación_yoy_pct = ((d1.valor - d2.valor) / d2.valor) * 100
  variación_mom_pct = ((d1.valor - d1.valor_anterior) / d1.valor_anterior) * 100
  
-- Binning/categorización
PASO 3: IF-ELSE Chain
  IF variación_yoy_pct < -2 THEN categoría = "deflación"
  ELSE IF -2 ≤ variación_yoy_pct < 2 THEN categoría = "estable"
  ELSE IF 2 ≤ variación_yoy_pct < 5 THEN categoría = "inflación_moderada"
  ELSE IF variación_yoy_pct ≥ 5 THEN categoría = "inflación_alta"
  
-- One-hot encoding para indicadores
PASO 4: Mapping
  SI indicador == "IPC_ES" THEN is_IPC = 1, is_Salario = 0, is_IBEX = 0, ...
  SI indicador == "Salario_Nominal" THEN is_IPC = 0, is_Salario = 1, is_IBEX = 0, ...
```

#### **2.5 Tratamiento de Outliers**

```pentaho_pseudocode
-- Detección por rango estadístico (IQR = Interquartile Range)
PASO 1: Statistics - Calcular Q1, Q3, IQR por indicador y período
  Q1 = PERCENTILE(valor, 0.25)
  Q3 = PERCENTILE(valor, 0.75)
  IQR = Q3 - Q1
  Límite_bajo = Q1 - 1.5 * IQR
  Límite_alto = Q3 + 1.5 * IQR

PASO 2: Filter rows - Marcar outliers
  SI valor < Límite_bajo OR valor > Límite_alto THEN
    outlier_flag = TRUE
    motivo_outlier = "IQR_1.5"
  
PASO 3: Decisión sobre outliers
  SI outlier_flag == TRUE THEN
    -- Opción A: Mantener pero marcar quality_flag = "outlier_verificado"
    -- Opción B: Reemplazar con media/mediana del período
    valor_corregido = MEDIAN(valor) [últimos 6 meses del mismo indicador]
    quality_flag = "outlier_corregido"
  
PASO 4: Output: dataset_limpio_outliers.csv
LOG: X outliers detectados, Y corregidos, Z mantenidos con flag
```

**Ejemplo de Detección:**
- Índice IBEX sube 10% en un día → outlier por volatilidad, mantener con flag
- IPC sube 50% en un mes (imposible) → corregir a valor esperado por tendencia

### 4.4 Transformación 3: Transformación y Enriquecimiento

**Objetivo:** Normalizar datos a esquemas estándar, convertir monedas, calcular índices base 100.

#### **3.1 Normalización a Esquema Estándar**

```pentaho_pseudocode
-- Esquema estándar de salida
fecha DATE
indicador_código STRING (ej: "IPC_ES_100", "SALARIO_NOM_ES", "ORO_USD_OZ")
indicador_nombre STRING
geografía_código STRING (ej: "ES", "ES-MD", "ES-BA")
geografía_nombre STRING
valor DECIMAL(15,4)
valor_anterior DECIMAL(15,4)
unidad STRING (ej: "EUR", "%", "Índice", "USD/oz")
fuente_código STRING (ej: "INE", "EUROSTAT", "LBMA")
fuente_nombre STRING
frecuencia STRING ("Mensual", "Diario", "Trimestral")
quality_flag STRING ("real", "imputado", "interpolado", "outlier")

TRANSFORMACIÓN:
1. Input: raw datasets
2. Mapping de campos:
   raw.date → fecha
   raw.index_100 → valor
   raw.category → CASE indicador_código
   raw.region → geografía_código (lookup a tabla maestra)
   raw.source → fuente_código (lookup a tabla maestra)
3. Output: normalized_dataset_paso3.csv
```

#### **3.2 Conversión de Monedas (Oro USD → EUR)**

```pentaho_pseudocode
-- Convertir precio del oro de USD a EUR usando tipo de cambio diario

PASO 1: Join - Unir tabla de ORO con tabla EUR/USD por fecha
  LEFT JOIN oro o ON eurusd e
  WHERE DATE_TRUNC(o.fecha, DAY) = DATE_TRUNC(e.fecha, DAY)

PASO 2: Calculator - Conversión
  precio_oro_eur = precio_oro_usd * eurusd_rate
  EJEMPLO: 2100 USD/oz * 0.92 EUR/USD = 1932 EUR/oz

PASO 3: Validación
  SI eurusd_rate IS NULL THEN
    -- Usar último rate conocido (forward-fill)
    eurusd_rate = LAST_NON_NULL_VALUE(eurusd_rate) [últimos 5 días]
    quality_flag = "interpolado_tipo_cambio"
  
PASO 4: Output: oro_convertido_eur.csv
  Columnas: fecha, precio_usd_oz, precio_eur_oz, eurusd_rate, quality_flag
```

#### **3.3 Reindexación a Base 100**

```pentaho_pseudocode
-- Reindexación estándar: Xnorm,t = 100 * Xt / Xt0

PASO 1: Identificar período base (t0 = 2010-01-01)
  valor_base = SELECT valor WHERE fecha = "2010-01-01" AND indicador = "IPC_ES"

PASO 2: Sort - Ordenar por fecha
PASO 3: Calculator - Aplicar fórmula
  índice_base_100 = 100 * (valor_actual / valor_base)
  
EJEMPLO:
  IPC enero 2010 = 95.5 (base 2021) → Convertir a base 100 en 2010-01
  IPC enero 2024 = 118.3 (base 2021) → índice_base_100 = 100 * (118.3 / 95.5) = 123.9

PASO 4: Output: índices_base_100.csv
```

#### **3.4 Deflactación de Salarios**

```pentaho_pseudocode
-- Convertir salarios nominales a reales usando IPC
-- Fórmula: W_real = W_nominal / (CPI_t / 100)

PASO 1: Join - Unir tabla SALARIOS con tabla IPC por fecha y geografía
  LEFT JOIN salarios s ON ipc i
  WHERE DATE_TRUNC(s.fecha, MONTH) = DATE_TRUNC(i.fecha, MONTH)
    AND s.geo = i.geo

PASO 2: Calculator - Deflactación
  salario_real = salario_nominal / (ipc_índice_base100 / 100)
  
EJEMPLO:
  Salario nominal 2010-01 = 1500 EUR
  IPC 2010-01 (base 100) = 100
  Salario real 2010-01 = 1500 / (100/100) = 1500 EUR
  
  Salario nominal 2024-01 = 1850 EUR
  IPC 2024-01 (base 100) = 135.5
  Salario real 2024-01 = 1850 / (135.5/100) = 1366 EUR
  → Pérdida real de ~9% en poder adquisitivo

PASO 3: Output: salarios_deflactados.csv
  Columnas: fecha, salario_nominal, ipc_índice, salario_real, pérdida_real_pct
```

#### **3.5 Cálculo de Rendimientos Logarítmicos (IBEX, Oro)**

```pentaho_pseudocode
-- Rendimiento logarítmico: rt = ln(Xt) - ln(Xt-1)

PASO 1: Sort - Ordenar por fecha descendente
PASO 2: Previous row - Acceder a valor anterior
  valor_anterior = PREVIOUS_ROW(valor)
  
PASO 3: Calculator - Rendimiento log
  retorno_log = LOG(valor_actual) - LOG(valor_anterior)
  retorno_pct = (valor_actual - valor_anterior) / valor_anterior * 100
  
EJEMPLO (IBEX-35):
  Cierre 2024-01-15 = 9250
  Cierre 2024-01-16 = 9310
  retorno_log = LN(9310) - LN(9250) = 9.140 - 9.133 = 0.0064 = 0.64%
  
PASO 4: Ajustar por inflación
  retorno_real = retorno_nominal - inflación_mensual
  
PASO 5: Output: ibex_retornos.csv, oro_retornos.csv
```

#### **3.6 Enriquecimiento con Metadatos Contextuales**

```pentaho_pseudocode
PASO 1: Add constants - Agregar metadatos de transformación
  ts_transformación = CURRENT_TIMESTAMP
  versión_pipeline = "v2024.1"
  período_base_índice = "2010-01-01"
  
PASO 2: Lookup - Buscar códigos maestros de indicadores, geografía, fuente
  LEFT JOIN dim_indicador di ON raw.indicador_tipo = di.nombre
  LEFT JOIN dim_geografia dg ON raw.región = dg.nombre
  LEFT JOIN dim_fuente df ON raw.institución = df.nombre
  
  Resultado: agregar surrogate keys (indicador_key, geo_key, fuente_key)
  
PASO 3: Output: enriquecido_paso3.csv
```

### 4.5 Transformación 4: Deflactación Integrada y Cálculo de Indicadores Derivados

**Objetivo:** Construir indicadores complejos necesarios para responder a P1–P5.

#### **4.1 Índice de Poder Adquisitivo**

```pentaho_pseudocode
-- PA_real = (Salario_nominal / IPC_base_100) reindexado a 2010
-- Alternativamente: PA_real = Salario_real_índice_base_100

PASO 1: Join - Unir salarios reales ya deflactados con IPC
PASO 2: Calculator
  IF año == 2010 THEN
    poder_adquisitivo_2010 = salario_real_2010  -- valor de referencia
  ELSE
    poder_adquisitivo_índice = 100 * (salario_real_actual / poder_adquisitivo_2010)
  END
  
PASO 3: Calcular pérdida acumulada
  pérdida_real_acumulada_pct = poder_adquisitivo_índice - 100
  
EJEMPLO:
  2010: PA_índice = 100, salario_real = 1500 EUR
  2024: PA_índice = 92.5, salario_real = 1388 EUR
  Pérdida acumulada = 92.5 - 100 = -7.5%

PASO 4: Output: poder_adquisitivo_índice.csv
```

#### **4.2 Correlación Inflación–Salarios (Rezago)**

```pentaho_pseudocode
-- Análisis de rezago: ¿cuántos meses tardan los salarios en ajustarse a la inflación?

PASO 1: Self-join de IPC con offset temporal
  SELECT ipc_t, ipc_t-1, ipc_t-3, ipc_t-6, ipc_t-12
  FROM ipc_mensual
  ORDER BY fecha

PASO 2: Calcular correlaciones cruzadas
  corr_lag_0 = CORR(inflación_t, variación_salario_t)
  corr_lag_3 = CORR(inflación_t-3, variación_salario_t)
  corr_lag_6 = CORR(inflación_t-6, variación_salario_t)
  corr_lag_12 = CORR(inflación_t-12, variación_salario_t)
  
PASO 3: Identificar rezago óptimo
  rezago_óptimo = argmax(corr_lag_k) para k en [0, 3, 6, 12]
  
PASO 4: Output: correlación_inflación_salarios.csv
  Resultado: p.ej., "Rezago óptimo de 6 meses, correlación = 0.72"
```

#### **4.3 Rentabilidad Real del IBEX (Ajustada por Inflación)**

```pentaho_pseudocode
-- Rentabilidad real = Rentabilidad nominal - Inflación

PASO 1: Calcular rentabilidad mensual del IBEX
  retorno_nominal_mensual = (cierre_final_mes - cierre_inicial_mes) / cierre_inicial_mes
  
PASO 2: Obtener inflación mensual
  inflación_mensual = (IPC_final_mes - IPC_inicial_mes) / IPC_inicial_mes

PASO 3: Calculator
  retorno_real = retorno_nominal - inflación_mensual
  
EJEMPLO:
  Enero 2024:
    IBEX retorno nominal = +2.5%
    Inflación = +0.3%
    Retorno real = 2.5% - 0.3% = +2.2%
  
  Media 2010-2024 (ejemplo):
    Retorno nominal promedio = +6.8%
    Inflación promedio = +2.1%
    Retorno real promedio = +4.7%
    → Conclusión: IBEX ha superado inflación en ~2.7% anual promedio

PASO 4: Output: ibex_rentabilidad_real.csv
```

#### **4.4 Correlación Oro–Poder Adquisitivo**

```pentaho_pseudocode
-- Hipótesis: Cuando poder adquisitivo cae, demanda de oro sube (activo refugio)

PASO 1: Normalizar series a base 100 (2010)
  poder_adquisitivo_idx = 100 * (PA_t / PA_2010)
  oro_eur_idx = 100 * (Oro_EUR_t / Oro_EUR_2010)

PASO 2: Calcular correlación mensual
  correlación_mo = CORR(poder_adquisitivo_idx, oro_eur_idx)
  → Esperado: correlación negativa (cuando PA cae, oro sube)
  
PASO 3: Análisis de causalidad (Granger si disponible)
  ¿Oro sube ANTES de que PA caiga (anticipación)?
  ¿O reaccionan juntos a shocks comunes (inflación)?

PASO 4: Output: correlación_oro_pa.csv
```

### 4.6 Transformación 5: Validación de Calidad y Auditoría

**Objetivo:** Implementar reglas de validación exhaustivas y registrar todas las decisiones.

#### **5.1 Reglas de Validación de Rangos**

```pentaho_pseudocode
PASO 1: Range validation
  PARA cada indicador:
    SI indicador == "IPC_ES_100" THEN
      min_permitido = 80, max_permitido = 150
    SINO SI indicador == "Inflación_YoY_%"THEN
      min_permitido = -10, max_permitido = 15
    SINO SI indicador == "Salario_Real_EUR" THEN
      min_permitido = 1000, max_permitido = 5000
    SINO SI indicador == "IBEX35_Retorno_%" THEN
      min_permitido = -30, max_permitido = 20
    FIN SI
    
    SI valor < min_permitido OR valor > max_permitido THEN
      error_validación = "Fuera de rango"
      acción = "Marcar para revisión manual" O "Rechazar fila"
    FIN SI
  FIN PARA

PASO 2: Output: validación_rangos.log
  Ejemplo: "Sor 45: IPC_ES_100 = 156.7 (fuera de rango 80–150) → Revisar"
```

#### **5.2 Validación de Monotonicidad Temporal**

```pentaho_pseudocode
-- Algunos indicadores deben ser monótonamente crecientes (ej: índices acumulativos)

PASO 1: Sort - Ordenar por fecha
PASO 2: PARA cada serie (indicador, geografía, fuente):
  valor_anterior = NULL
  PARA cada fila en orden cronológico:
    SI indicador IN ("IPC_100_Acumulativo", "Poder_Adquisitivo_Acumulativo") THEN
      SI valor_actual < valor_anterior THEN
        advertencia = "Aparente violación de monotonicidad"
        causa_posible = "Cambio de base", "Revisión estadística", "Error"
        calidad_flag = "revisar_monotonicidad"
      FIN SI
    FIN SI
    valor_anterior = valor_actual
  FIN PARA
FIN PARA

PASO 3: Output: validación_monotonicidad.log
```

#### **5.3 Validación de Unicidad de Claves**

```pentaho_pseudocode
-- Garantizar que no haya duplicados en la clave primaria del fact table

PASO 1: Group by - Agrupar por (fecha, indicador, geografía, fuente, unidad)
PASO 2: Count - Contar registros por grupo
PASO 3: Filter - Retener solo grupos con COUNT > 1
PASO 4: PARA cada grupo duplicado:
  acción = "Mantener registro con date más reciente", O
           "Promediar valores si diferencia < 1%", O
           "Rechazar e investigar"
  LOG: "Duplicado encontrado: (2024-01, IPC_ES, ES, INE, %) → Acciones tomadas: ..."

PASO 5: Output: tabla_deduplicada, tabla_duplicados_revisados.csv
```

#### **5.4 Consistencia entre Fuentes**

```pentaho_pseudocode
-- Validar que diferentes fuentes de un mismo indicador sean coherentes

PASO 1: JOIN - IPC (INE) vs HICP (Eurostat)
  SELECT
    ipc.fecha, ipc.valor AS ipc_ine, hicp.valor AS hicp_eurostat,
    ABS(ipc.valor - hicp.valor) / hicp.valor AS diferencia_relativa
  FROM ipc_ine
  LEFT JOIN hicp_eurostat ON ipc.fecha = hicp.fecha

PASO 2: Analizar diferencias
  SI diferencia_relativa < 1% THEN
    validación = "Consistente" → usar promedio ponderado
  SINO SI 1% ≤ diferencia_relativa < 3% THEN
    validación = "Divergencia aceptable" → usar ambas, anotar fuente primaria
  SINO
    validación = "Inconsistencia significativa" → investigar causa, documentar
  FIN SI

PASO 3: Output: validación_consistencia_fuentes.csv
```

#### **5.5 Tratamiento de Valores Atípicos (Outliers) Final**

```pentaho_pseudocode
-- Detección final de outliers después de transformaciones

PASO 1: Zscore detection
  PARA cada indicador:
    media = AVG(valor)
    desv_est = STDEV(valor)
    zscore = (valor - media) / desv_est
    
    SI |zscore| > 3 THEN
      flag_outlier = TRUE
      severity = "EXTREMO"
    SINO SI |zscore| > 2 THEN
      flag_outlier = TRUE
      severity = "MODERADO"
    FIN SI

PASO 2: Contexto y justificación
  EJEMPLO: IPC +50% en un mes durante crisis = EXTREMO pero justificado
  EJEMPLO: IBEX sube 20% en un día post-elecciones = EXTREMO pero real
  
  ACCIÓN: Registrar con contexto, mantener con flag, NO eliminar

PASO 3: Output: outliers_identificados.csv
  Columnas: fecha, indicador, valor, zscore, contexto, acción_tomada
```

### 4.7 Transformación 6: Carga a Data Warehouse

**Objetivo:** Insertar datos validados y transformados en el esquema de hechos.

#### **6.1 Actualización de Dimensiones (Slowly Changing Dimensions)**

```pentaho_pseudocode
PASO 1: Cargar dimensiones maestras (si no existen)
  INSERT INTO dim_tiempo (fecha, año, mes, ...)
    SELECT DISTINCT fecha FROM datos_transformados
    WHERE fecha NOT IN (SELECT fecha FROM dim_tiempo)
    
  INSERT INTO dim_indicador (nombre, descripción, ...)
    SELECT DISTINCT indicador_nombre FROM datos_transformados
    WHERE indicador_nombre NOT IN (SELECT nombre FROM dim_indicador)
  
  -- Similar para dim_geografia, dim_unidad, dim_fuente

PASO 2: Actualizar dimensiones con cambios (SCD Type 2 si necesario)
  -- Ej: Si descripción de un indicador cambia
  INSERT INTO dim_indicador_histórico
    SELECT * FROM dim_indicador WHERE cambio_detectado = TRUE

PASO 3: Obtener surrogate keys
  LEFT JOIN dim_tiempo PARA obtener tiempo_key
  LEFT JOIN dim_indicador PARA obtener indicador_key
  LEFT JOIN dim_geografia PARA obtener geo_key
  LEFT JOIN dim_unidad PARA obtener unit_key
  LEFT JOIN dim_fuente PARA obtener fuente_key
```

#### **6.2 Inserción en Tabla de Hechos**

```pentaho_pseudocode
PASO 1: Preparar datos para inserción
  SELECT
    dt.tiempo_key,
    di.indicador_key,
    dg.geo_key,
    du.unit_key,
    df.fuente_key,
    datos.valor,
    datos.valor_anterior,
    datos.variación_pct,
    datos.quality_flag AS calidad_dato,
    datos.prob_imputación AS probabilidad_imputación,
    CURRENT_TIMESTAMP AS ts_carga
  FROM datos_transformados datos
  LEFT JOIN dim_tiempo dt ON datos.fecha = dt.fecha
  LEFT JOIN dim_indicador di ON datos.indicador_código = di.nombre
  LEFT JOIN dim_geografia dg ON datos.geo_código = dg.código_iso
  LEFT JOIN dim_unidad du ON datos.unidad = du.símbolo
  LEFT JOIN dim_fuente df ON datos.fuente_código = df.institución

PASO 2: Upsert (Insert or Update)
  -- Si registro ya existe (misma clave), actualizar
  -- Si no existe, insertar
  MERGE INTO hechos_indicadores_temporales h
  USING nuevos_datos n
  ON (h.tiempo_key = n.tiempo_key AND
      h.indicador_key = n.indicador_key AND
      h.geo_key = n.geo_key AND
      h.unit_key = n.unit_key AND
      h.fuente_key = n.fuente_key)
  WHEN MATCHED THEN
    UPDATE SET h.valor = n.valor, h.ts_actualización = CURRENT_TIMESTAMP
  WHEN NOT MATCHED THEN
    INSERT (...) VALUES (...)

PASO 3: Output
  LOG: "Insertados X registros nuevos, actualizados Y registros existentes, Z rechazados"
```

### 4.8 Plan de Auditoría y Logs

**Objetivo:** Registrar cada paso para reproducibilidad y auditoría.

#### **8.1 Tabla de Logs (etl_logs)**

```sql
-- Registrar cada ejecución del ETL
INSERT INTO etl_logs (
  nombre_job,
  timestamp_inicio,
  timestamp_fin,
  estado,
  registros_procesados,
  registros_errores,
  descripción_error,
  usuario
) VALUES (
  'ETL_MACROECONOMIA_PIPELINE',
  '2024-12-15 10:00:00',
  '2024-12-15 10:45:30',
  'completado',
  1250000,
  125,
  NULL,
  'etl_user'
);
```

#### **8.2 Tabla de Validación de Calidad (validación_calidad)**

```sql
-- Registrar resultados de cada validación
INSERT INTO validación_calidad (
  fecha_validación,
  indicador_key,
  geo_key,
  tipo_validación,
  resultado,
  descripción,
  acciones_tomadas
) VALUES (
  CURRENT_TIMESTAMP,
  (SELECT indicador_key FROM dim_indicador WHERE nombre = 'IPC_ES_100'),
  (SELECT geo_key FROM dim_geografia WHERE nombre = 'España'),
  'rango_validación',
  TRUE,
  '100% de valores en rango [80, 150]',
  'Ninguna'
);
```

#### **8.3 Tabla de Trazabilidad de Transformaciones**

```sql
-- Registrar cada transformación aplicada
INSERT INTO trazabilidad_transformación (
  nombre_transformación,
  descripción,
  entrada_dataset,
  salida_dataset,
  fórmula_aplicada,
  parámetros,
  resultado_validación,
  timestamp_ejecución
) VALUES (
  'Deflactación_Salarios',
  'Convertir salarios nominales a reales usando IPC',
  'salarios_nominales.csv',
  'salarios_reales.csv',
  'W_real = W_nominal / (CPI_t / 100)',
  '{"base_año": 2010, "método": "CPI_INE"}',
  TRUE,
  CURRENT_TIMESTAMP
);
```

### 4.9 Componentes Específicos de Pentaho a Usar

| Componente | Función | Ejemplo de Uso |
|---|---|---|
| **Text file input** | Extrae CSV | Leer ipc_es_monthly.csv |
| **JSON input** | Parsea JSON | Respuesta de API OANDA |
| **HTTP client** | Llamadas REST | GET a BC EUR/USD endpoint |
| **Sort rows** | Ordena por múltiples campos | Ordenar por (fecha, indicador) |
| **Unique rows** | Elimina duplicados exactos | Deduplicar por clave primaria |
| **Filter rows** | Condiciones booleanas | Mantener solo 2010–2025 |
| **Calculator** | Cálculos en línea | Aplicar fórmulas de deflactación |
| **Join rows** | Une dos flujos | Unir IPC con salarios |
| **Group by** | Agrupación y agregación | SUM/AVG por mes |
| **Mapping (Input/Output)** | Mapeo de campos | Alinear nombres de columnas |
| **Database lookup** | Buscar valores | Obtener surrogate keys de dimensiones |
| **Update/Insert** | Actualiza/inserta en BD | Cargar a hechos_indicadores_temporales |
| **Write to log** | Escribe en logs | Registrar eventos y errores |
| **Excel output** | Exporta a .xlsx | Generar reportes de calidad |
| **CSV file output** | Exporta a CSV | Guardar datasets intermedios |

---

## APARTADO 5: TRANSFORMACIÓN A SCHEMA.ORG (10%)

### 5.1 Mapeo de Clases y Propiedades

**Objetivo:** Transformar datos del DW a tripletas RDF/JSON-LD usando vocabulario schema.org.

#### **5.1.1 Entidades Principales y Clases Schema.org**

| Concepto DW | Clase Schema.org | Propiedades Principales |
|---|---|---|
| **Observación/Hecho** | `Observation` | `observationDate`, `measurementTechnique`, `measurementValue`, `unitText` |
| **Dataset Completo** | `Dataset` | `name`, `description`, `datePublished`, `creator`, `distribution`, `spatialCoverage`, `temporalCoverage` |
| **Indicador** | `Property` (o `DefinedTerm`) | `name`, `description`, `domainIncludes`, `rangeIncludes` |
| **Fuente/Institución** | `Organization` | `name`, `url`, `sameAs`, `contactPoint` |
| **Geografía** | `Place` | `name`, `geo`, `containedInPlace`, `identifier` |
| **Unidad de Medida** | `QuantitativeValue` + `UnitPriceSpecification` | `unitCode`, `unitText`, `priceCurrency` |
| **Persona Responsable** | `Person` | `name`, `email`, `affiliation` |
| **Agregación de Observaciones** | `AggregateOffer` (alternativa) o `Dataset` | `numberOfItems`, `priceCurrency`, `price` |

#### **5.1.2 Mapeo Detallado por Indicador**

**Ejemplo 1: Observación de IPC**

```json
{
  "@context": "https://schema.org",
  "@type": "Observation",
  "@id": "https://example.org/observation/ipc-es-2024-01",
  
  "observationDate": "2024-01-31",
  "measurementTechnique": "IPC metodología INE",
  "measurementValue": 135.5,
  "unitText": "Índice base 100 (2021)",
  "unitCode": "IDX",
  
  "variableMeasured": {
    "@type": "Property",
    "name": "IPC_ES_100",
    "description": "Índice de Precios al Consumo de España, base 100 = 2021"
  },
  
  "spatialCoverage": {
    "@type": "Place",
    "@id": "https://example.org/place/ES",
    "name": "Spain",
    "identifier": "ES"
  },
  
  "temporalCoverage": "2024-01-01/2024-01-31",
  
  "creator": {
    "@type": "Organization",
    "@id": "https://www.ine.es",
    "name": "Instituto Nacional de Estadística",
    "identifier": "INE"
  },
  
  "isPartOf": {
    "@type": "Dataset",
    "@id": "https://example.org/dataset/macroeconomia-espana",
    "name": "Macroeconomic Indicators for Spain",
    "identifier": "DW-MACRO-ES-2024"
  },
  
  "qualityControlled": {
    "@type": "PropertyValue",
    "name": "quality_flag",
    "value": "real",
    "description": "Dato verificado sin imputación"
  }
}
```

**Ejemplo 2: Observación de Salario Real**

```json
{
  "@context": "https://schema.org",
  "@type": "Observation",
  "@id": "https://example.org/observation/salario-real-es-2024-q1",
  
  "observationDate": "2024-03-31",
  "measurementTechnique": "Salario nominal deflactado por IPC_t",
  "measurementValue": 1366.50,
  "unitText": "EUR",
  "unitCode": "EUR",
  
  "variableMeasured": {
    "@type": "Property",
    "name": "Salario_Real",
    "description": "Salario mensual medio en términos reales (2010=100)",
    "formula": "W_real = W_nominal / (CPI_t / 100)",
    "basePeriod": "2010-01-01"
  },
  
  "spatialCoverage": {
    "@type": "Place",
    "@id": "https://example.org/place/ES",
    "name": "Spain"
  },
  
  "creator": {
    "@type": "Organization",
    "@id": "https://www.ine.es",
    "name": "Instituto Nacional de Estadística"
  },
  
  "relatedData": [
    {
      "@type": "Observation",
      "variableMeasured": "Salario_Nominal",
      "measurementValue": 1850,
      "observationDate": "2024-03-31"
    },
    {
      "@type": "Observation",
      "variableMeasured": "IPC_ES_100",
      "measurementValue": 135.5,
      "observationDate": "2024-01-31"
    }
  ]
}
```

**Ejemplo 3: Observación de Oro en EUR**

```json
{
  "@context": "https://schema.org",
  "@type": "Observation",
  "@id": "https://example.org/observation/gold-price-eur-2024-01-31",
  
  "observationDate": "2024-01-31",
  "measurementTechnique": "PM Fixing LBMA convertido a EUR mediante tipo de cambio diario BCE",
  "measurementValue": 1932.45,
  "unitText": "EUR/Troy Oz",
  "unitCode": "XAU-EUR",
  
  "variableMeasured": {
    "@type": "Property",
    "name": "Gold_Price_EUR",
    "description": "Precio internacional del oro en EUR por onza troy",
    "derivedFrom": [
      "Gold_Price_USD",
      "EUR_USD_ExchangeRate"
    ]
  },
  
  "spatialCoverage": {
    "@type": "Place",
    "name": "Global",
    "identifier": "GLOBAL"
  },
  
  "temporalCoverage": "2024-01-31/2024-01-31",
  
  "creator": {
    "@type": "Organization",
    "@id": "https://www.lbma.org.uk",
    "name": "London Bullion Market Association"
  },
  
  "relatedData": {
    "@type": "Observation",
    "variableMeasured": "EUR_USD_ExchangeRate",
    "measurementValue": 0.92,
    "observationDate": "2024-01-31",
    "creator": {
      "@type": "Organization",
      "@id": "https://www.ecb.europa.eu",
      "name": "European Central Bank"
    }
  }
}
```

#### **5.1.3 Dataset Principal (Metadatos de Agregación)**

```json
{
  "@context": "https://schema.org",
  "@type": "Dataset",
  "@id": "https://example.org/dataset/macroeconomia-espana",
  
  "name": "Macroeconomic Indicators for Spain 2010-2025",
  "alternateName": "Indicadores Macroeconómicos de España 2010-2025",
  "description": "Almacén de datos integrado de indicadores macro españoles: IPC, salarios, oro, tipos de cambio, IBEX-35",
  "identifier": "DW-MACRO-ES-2024",
  
  "creator": {
    "@type": "Organization",
    "@id": "https://example.org",
    "name": "Grupo de Investigación Macroeconomía Aplicada",
    "affiliation": {
      "@type": "EducationalOrganization",
      "name": "Universidad de Alicante",
      "url": "https://www.ua.es"
    }
  },
  
  "datePublished": "2024-12-15",
  "dateModified": "2024-12-15",
  
  "license": [
    "https://creativecommons.org/licenses/by/4.0/",
    "https://opendatacommons.org/licenses/by/1.0/"
  ],
  
  "spatialCoverage": [
    {
      "@type": "Place",
      "@id": "https://example.org/place/ES",
      "name": "Spain"
    }
  ],
  
  "temporalCoverage": "2010-01-01/2025-12-31",
  
  "keywords": [
    "macroeconomics",
    "inflation",
    "purchasing power",
    "wages",
    "Spain",
    "euro depreciation",
    "open data"
  ],
  
  "includedInDataCatalog": {
    "@type": "DataCatalog",
    "@id": "https://example.org/datacatalog",
    "name": "Open Macroeconomic Data Catalog Spain"
  },
  
  "distribution": [
    {
      "@type": "DataDownload",
      "contentUrl": "https://github.com/example/macro-es/blob/main/data/hechos_indicadores.csv",
      "encodingFormat": "text/csv",
      "name": "CSV Export - Fact Table"
    },
    {
      "@type": "DataDownload",
      "contentUrl": "https://example.org/api/observations",
      "encodingFormat": "application/json",
      "name": "JSON-LD API - Observations"
    },
    {
      "@type": "DataDownload",
      "contentUrl": "https://example.org/rdf/macroeconomia-es.rdf",
      "encodingFormat": "application/rdf+xml",
      "name": "RDF/XML - Full Graph"
    }
  ],
  
  "hasVersion": "1.0.0",
  "isVersionOf": {
    "@type": "Thing",
    "name": "Macroeconomic Indicators Spain - Base Series"
  },
  
  "contactPoint": {
    "@type": "ContactPoint",
    "name": "Data Manager",
    "email": "data@example.org",
    "contactType": "technical support"
  }
}
```

### 5.2 Herramientas y Proceso de Transformación a RDF/JSON-LD

#### **5.2.1 Opción A: OpenRefine + RDF Extension**

```
Flujo OpenRefine:
1. Cargar CSV de hechos desde DW
   - ARCHIVO: hechos_indicadores_temporales.csv
   
2. Crear Esquema de Mapeo
   - Configurar columnas → propiedades schema.org
   - fecha → observationDate
   - indicador_nombre → variableMeasured.name
   - valor → measurementValue
   - unidad → unitText
   
3. Generar RDF
   - Usar RDF extension
   - Exportar a RDF/XML o Turtle
   - Salida: observations_rdf.ttl o observations_rdf.xml
   
4. Validar con SPARQL endpoint
   - Cargar RDF en Fuseki o similar
   - Ejecutar queries SPARQL para verificar integridad
```

#### **5.2.2 Opción B: Python con rdflib**

```python
from rdflib import Graph, Namespace, Literal, URIRef
from rdflib.namespace import RDF, RDFS, XSD
import pandas as pd
from datetime import datetime

# Definir namespaces
SCHEMA = Namespace("https://schema.org/")
EX = Namespace("https://example.org/")
SKOS = Namespace("http://www.w3.org/2004/02/skos/core#")

# Crear grafo RDF
g = Graph()

# Cargar datos desde CSV
df = pd.read_csv('hechos_indicadores_temporales.csv')

# Para cada fila, crear tripleta
for idx, row in df.iterrows():
    obs_uri = URIRef(f"https://example.org/observation/obs-{idx}")
    
    # Sujeto - Predicado - Objeto (tripleta)
    g.add((obs_uri, RDF.type, SCHEMA.Observation))
    g.add((obs_uri, SCHEMA.observationDate, 
           Literal(row['fecha'], datatype=XSD.date)))
    g.add((obs_uri, SCHEMA.measurementValue,
           Literal(float(row['valor']), datatype=XSD.decimal)))
    g.add((obs_uri, SCHEMA.unitText, 
           Literal(row['unidad'], datatype=XSD.string)))
    
    # Indicador
    indicator_uri = URIRef(f"https://example.org/indicator/{row['indicador_código']}")
    g.add((obs_uri, SCHEMA.variableMeasured, indicator_uri))
    g.add((indicator_uri, RDF.type, SCHEMA.Property))
    g.add((indicator_uri, SCHEMA.name, 
           Literal(row['indicador_nombre'])))
    
    # Geografía
    geo_uri = URIRef(f"https://example.org/place/{row['geo_código']}")
    g.add((obs_uri, SCHEMA.spatialCoverage, geo_uri))
    g.add((geo_uri, RDF.type, SCHEMA.Place))
    g.add((geo_uri, SCHEMA.name, Literal(row['geo_nombre'])))
    
    # Fuente
    source_uri = URIRef(f"https://example.org/org/{row['fuente_código']}")
    g.add((obs_uri, SCHEMA.creator, source_uri))
    g.add((source_uri, RDF.type, SCHEMA.Organization))
    g.add((source_uri, SCHEMA.name, Literal(row['fuente_nombre'])))

# Serializar a diferentes formatos
g.serialize(destination='observations.rdf', format='xml')
g.serialize(destination='observations.ttl', format='turtle')
g.serialize(destination='observations.jsonld', format='json-ld')

print(f"Total tripletas generadas: {len(g)}")
```

#### **5.2.3 Opción C: XSLT Transformation**

Si los datos están en XML, usar XSLT para transformar a RDF:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:schema="https://schema.org/">
  
  <xsl:template match="observation">
    <rdf:Description rdf:about="{@id}">
      <rdf:type rdf:resource="https://schema.org/Observation"/>
      <schema:observationDate>
        <xsl:value-of select="fecha"/>
      </schema:observationDate>
      <schema:measurementValue>
        <xsl:value-of select="valor"/>
      </schema:measurementValue>
      <schema:unitText>
        <xsl:value-of select="unidad"/>
      </schema:unitText>
      <!-- ... más propiedades ... -->
    </rdf:Description>
  </xsl:template>
</xsl:stylesheet>
```

### 5.3 Validación de Calidad del Grafo RDF

#### **5.3.1 Conteo de Clases y Propiedades**

```sparql
-- SPARQL query para validar integridad

PREFIX schema: <https://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

-- Contar observaciones
SELECT (COUNT(?obs) AS ?total_observaciones)
WHERE {
  ?obs rdf:type schema:Observation .
}

-- Contar observaciones por indicador
SELECT ?indicador (COUNT(?obs) AS ?count)
WHERE {
  ?obs rdf:type schema:Observation ;
       schema:variableMeasured ?var .
  ?var schema:name ?indicador .
}
GROUP BY ?indicador
ORDER BY DESC(?count)

-- Validar completitud de propiedades obligatorias
SELECT ?obs 
WHERE {
  ?obs rdf:type schema:Observation .
  FILTER NOT EXISTS { ?obs schema:observationDate ?date . }
  OPTIONAL { ?obs schema:measurementValue ?val . }
  FILTER (!bound(?val))
}
-- Resultado: observaciones incompletas a revisar
```

#### **5.3.2 Enriquecimiento con Vocabularios Externos**

```turtle
# Vincular a Wikidata para mayor semántica

PREFIX schema: <https://schema.org/>
PREFIX wikidata: <http://www.wikidata.org/entity/>
PREFIX dbpedia: <http://dbpedia.org/resource/>

ex:place/ES a schema:Place ;
    schema:name "Spain" ;
    schema:sameAs wikidata:Q29 ,
                   dbpedia:Spain ;
    schema:identifier "ES" .

ex:indicator/IPC a schema:Property ;
    schema:name "Consumer Price Index" ;
    schema:sameAs <http://purl.org/linked-data/sdmx/concept#CPIINDX> ;
    skos:broader <http://www.wikidata.org/entity/Q179540> .  # Índice de inflación
```

#### **5.3.3 Criterios de Validación Finales**

| Criterio | Umbral | Método de Verificación |
|---|---|---|
| **Completitud de observaciones** | ≥98% de fieldsObligatorios presentes | SPARQL query: NOT EXISTS obligatorios |
| **Validez de URIs** | 100% URIs válidas (RFC 3986) | Validador XML/RDF |
| **Consistencia de tipos** | Cada observación es rdf:type schema:Observation | SPARQL: count(?) = count(rdf:type) |
| **Resolución de referencias** | 95% de URIs referenciados son resolubles | HTTP GET a cada URI única |
| **Alineación con ontologías** | Propiedades en schema.org válidas | OWL reasoning |
| **No hay ciclos infinitos** | 0 ciclos en grafo de referencias | Algoritmo DFS |

---

## APARTADO 6: VISUALIZACIONES (10%)

### 6.1 Visualización 1: Evolución del Poder Adquisitivo vs. Inflación y IBEX (2010–2025)

**Pregunta respondida:** P1 "¿Cómo ha evolucionado el índice de poder adquisitivo real en España?"

#### **6.1.1 Especificación de la Visualización**

| Aspecto | Especificación |
|---|---|
| **Tipo de gráfico** | Gráfico de líneas múltiples con dos ejes Y |
| **Eje X** | Tiempo (meses: 2010-01 hasta 2025-12) |
| **Eje Y (Izquierdo)** | Poder Adquisitivo Índice Base 100 (2010=100) |
| **Eje Y (Derecho)** | IBEX-35 Rentabilidad Real Acumulada (%), Inflación YoY (%) |
| **Series de datos** | 1. Poder Adquisitivo (línea azul, espesa) 2. IBEX-35 Rentabilidad Real (línea verde, discontinua) 3. Inflación YoY (línea roja, punteada) |
| **Escala** | Normalizada a base 100 para PA e IBEX; % para inflación |
| **Dimensiones** | 1200 × 600 px |
| **Colores** | PA=Azul (#003da5), IBEX=Verde (#28a745), Inflación=Rojo (#dc3545) |
| **Marcadores** | Puntos en cada mes, tamaño variable según incertidumbre de datos |
| **Anotaciones** | Eventos relevantes (2012 crisis euro, 2015 recuperación, 2020 COVID) |

#### **6.1.2 Especificación de Ejes, Escalas y Normalizaciones**

```
EJE X (Tiempo)
- Intervalo: 2010-01-01 a 2025-12-31
- Granularidad: Mensual
- Formato etiquetas: "Ene-10", "Abr-10", "Jul-10", "Oct-10", "Ene-11", ...
- Ángulo: 45° para legibilidad

EJE Y IZQUIERDO (Poder Adquisitivo)
- Escala: Lineal
- Rango: 80 – 110 (base 100 en 2010)
- Incremento: 5 unidades
- Etiquetas: "80", "85", "90", "95", "100", "105", "110"
- Títular: "Poder Adquisitivo (Índice 2010=100)"

EJE Y DERECHO (IBEX + Inflación)
- Escala: Lineal
- Rango: -30% a +150% (para IBEX acumulado)
- Rango: -5% a +15% (para inflación YoY)
- Incremento: 10% (IBEX), 2% (Inflación)
- Título: "IBEX Rentabilidad Real (%) / Inflación YoY (%)"

NORMALIZACIÓN:
- PA: No normalizar (ya en índice 100)
- IBEX: Rentabilidad real = retorno_nominal - promedio_inflación
- Inflación: YoY = (IPC_t - IPC_t-12) / IPC_t-12 × 100
```

#### **6.1.3 Anotaciones e Interpretación**

```
ANOTACIONES (Eventos macro):
- 2012-08: "Crisis de deuda euro" → Marcar con línea vertical roja pálida
- 2015-01: "Bajos tipos, recuperación" → Marcar con línea vertical verde pálida
- 2020-03: "COVID-19 shock" → Marcar con línea vertical gris oscuro
- 2021-11: "Inflación descontrolada" → Etiqueta "Inflación anual: +5.5%"
- 2024-12: "Último dato disponible" → Punto destacado

INTERPRETACIÓN Y GUÍA DE LECTURA:

1. TENDENCIA GENERAL (2010–2025)
   - Poder adquisitivo cae de 100 a ~92 (aprox. -8% acumulado)
   - Explicación: Inflación acumulada ~35%, salarios nominales crecen ~23%
   - Resultado neto: Pérdida real de ~10% en poder de compra

2. PERÍODOS CLAVE
   a) 2010-2014: Austeridad y estancamiento
      - PA casi plano, inflación moderada (~2% YoY)
      - IBEX muy volátil (-10% a +30% anual)
      → Conclusión: Salarios ajustados a la baja, activos financieros no cobertura

   b) 2015-2019: Recuperación débil
      - PA ligeramente mejora (índice 100 → 98, aún negativo)
      - Inflación reprimida (0% a 2%)
      - IBEX muestra rentabilidad real positiva
      → Conclusión: Recuperación no llega a familias, beneficio en bolsa

   c) 2020-2024: COVID + inflación
      - PA cae más rápidamente (98 → 92)
      - Inflación salta a +8.5% pico (2022)
      - IBEX ajustado cae inicialmente, se recupera parcialmente
      → Conclusión: Compresión salarial real muy severa, desinversión en bolsa

3. CORRELACIONES VISIBLES
   - Cuando inflación sube (línea roja) → PA baja (línea azul) con rezago 3-6 meses
   - IBEX muestra cierta reacción defensiva en crisis (sube cuando PA baja)
   - Oro (no mostrado aquí) sería contraíclico: sube cuando PA cae

4. LIMITACIONES
   - Datos mensuales pueden ocultar volatilidad intradiaria
   - IBEX Total Return Index puede diferir si incluye/excluye dividendos
   - Cobertura sectorial del IBEX no representa toda la economía
```

#### **6.1.4 Implementación Técnica**

**Opción A: Plotly (Python interactivo)**

```python
import plotly.graph_objects as go
import pandas as pd

# Cargar datos
df = pd.read_csv('poder_adquisitivo_ibex_inflacion.csv')
df['fecha'] = pd.to_datetime(df['fecha'])

# Crear figura con dos ejes Y
fig = go.Figure()

# Eje izquierdo: Poder Adquisitivo
fig.add_trace(go.Scatter(
    x=df['fecha'],
    y=df['poder_adquisitivo_idx'],
    name='Poder Adquisitivo (2010=100)',
    line=dict(color='#003da5', width=3),
    yaxis='y'
))

# Eje derecho: IBEX Rentabilidad Real
fig.add_trace(go.Scatter(
    x=df['fecha'],
    y=df['ibex_rentabilidad_real_pct'],
    name='IBEX-35 Rentabilidad Real (%)',
    line=dict(color='#28a745', width=2, dash='dash'),
    yaxis='y2'
))

# Eje derecho: Inflación YoY
fig.add_trace(go.Scatter(
    x=df['fecha'],
    y=df['inflacion_yoy_pct'],
    name='Inflación YoY (%)',
    line=dict(color='#dc3545', width=2, dash='dot'),
    yaxis='y2'
))

# Anotaciones de eventos
events = [
    dict(x='2012-08-01', text='Crisis euro', showarrow=True, arrowhead=2),
    dict(x='2015-01-01', text='Recuperación', showarrow=True, arrowhead=2),
    dict(x='2020-03-01', text='COVID-19', showarrow=True, arrowhead=2),
    dict(x='2021-11-01', text='Inflación +5.5%', showarrow=True, arrowhead=2)
]

fig.update_layout(
    title='Evolución del Poder Adquisitivo vs. Inflación e IBEX (2010-2025)',
    xaxis_title='Período',
    yaxis_title='Poder Adquisitivo (Índice 2010=100)',
    yaxis2=dict(title='IBEX Rentabilidad Real (%) / Inflación YoY (%)', 
                overlaying='y', side='right'),
    hovermode='x unified',
    template='plotly_white',
    width=1200, height=600,
    annotations=events
)

fig.show()
fig.write_html('viz1_poder_adquisitivo.html')
```

**Opción B: D3.js + Observablehq**

```javascript
// Especificación D3.js para visualización interactiva
// Incluir brushing para zoom temporal, tooltip con valores exactos
```

### 6.2 Visualización 2: Correlación Oro-Inflación vs. Poder Adquisitivo (Dispersión con Series Temporales)

**Pregunta respondida:** P3 "¿Cómo se correlaciona el precio del oro en EUR con la pérdida de poder adquisitivo?"

#### **6.2.1 Especificación de la Visualización**

| Aspecto | Especificación |
|---|---|
| **Tipo de gráfico** | Gráfico de dispersión (scatter plot) + línea de tendencia + pequeños gráficos de series temporales en márgenes |
| **Eje X** | Poder Adquisitivo Índice (2010=100) |
| **Eje Y** | Precio del Oro en EUR por onza troy |
| **Puntos** | Cada punto = un mes observado (2010-01 hasta 2025-12) |
| **Tamaño de puntos** | Proporcional a inflación YoY ese mes (mayor inflación = punto más grande) |
| **Color de puntos** | Gradiente temporal: Azul (2010) → Verde (2017) → Rojo (2025) |
| **Línea de tendencia** | Regresión lineal con IC 95% (zona sombreada) |
| **Dimensiones** | 900 × 700 px |
| **Marginales** | Gráficos pequeños de series temporales de PA y Oro en márgenes X e Y |

#### **6.2.2 Especificación de Escalas, Ejes y Normalizaciones**

```
EJE X (Poder Adquisitivo)
- Escala: Lineal
- Rango: 88 – 105 (observado 92–101 en datos)
- Incremento: 2 unidades
- Título: "Poder Adquisitivo (Índice 2010=100)"

EJE Y (Precio Oro)
- Escala: Lineal
- Rango: 1500 – 2400 EUR/oz (rango observado)
- Incremento: 200 EUR
- Título: "Precio del Oro (EUR/oz)"

TAMAÑO DE PUNTOS (Inflación YoY)
- Rango inflación: -1% a +8.5%
- Tamaño mín: 80 px²
- Tamaño máx: 200 px²
- Escala: lineal

COLOR (Período Temporal)
- 2010: Azul (#003da5)
- 2017-18: Verde (#28a745)
- 2025: Rojo (#dc3545)
- Interpolación: RGB lineal en tiempo

CORRELACIÓN ESPERADA:
- Correlación de Pearson esperada: -0.55 a -0.65 (negativa)
- Interpretación: Cuando PA baja, oro sube (activo refugio)
- Significancia: p-value < 0.05

REGRESIÓN:
- Pendiente negativa (~ -10 EUR/oz por cada unidad de PA)
- Intersección: ~ 3000 EUR/oz cuando PA = 0
- R² ~ 0.35–0.40 (relación moderada, no determinista)
```

#### **6.2.3 Anotaciones e Interpretación**

```
ANOTACIONES:

1. ETIQUETADO DE PUNTOS EXTREMOS
   - Punto máx oro (2020-08): 2380 EUR/oz, PA=96 → "Pico COVID"
   - Punto mín oro (2010-06): 1450 EUR/oz, PA=101 → "Previo crisis"
   - Punto más alto PA (2011-01): PA=101.2, Oro=1550 → "Mejor poder adquisitivo"
   - Punto más bajo PA (2024-11): PA=91.8, Oro=2150 → "Peor periodo"

2. ZONAS IDENTIFICADAS
   - Zona 1 (2010-2012): PA alta (100+), Oro bajo (1500-1600)
     → "Época de austeridad/crédito barato, poca demanda refugio"
   - Zona 2 (2013-2016): PA cayendo, Oro subiendo
     → "Transición: empieza preocupación"
   - Zona 3 (2017-2020): PA bajando aceleradamente, Oro extremo
     → "Crisis evidente: fuga a activos seguros"
   - Zona 4 (2021-2025): PA muy bajo (91-93), Oro moderado (2000-2200)
     → "Nueva normalidad: adapta ción a inflación"

INTERPRETACIÓN:

3. CAUSALIDAD POTENCIAL
   a) HIPÓTESIS DEMANDA REFUGIO
      - Cuando familias notan pérdida de poder adquisitivo
      - Buscan activos seguros → demanda de oro sube
      - Evidencia: correlación negativa fuerte en 2020-2022
      
   b) HIPÓTESIS DE SHOCKS COMUNES
      - Ambas variables reaccionan a inflación global
      - Oro sube por inflación esperada (todos lo saben)
      - PA cae porque salarios atrasan
      - Ambos síntomas, no causal directo
      
   c) HIPÓTESIS MONETARIA
      - Depreciación del euro (EUR/USD cae)
      - Oro en USD baja, pero en EUR sube más
      - PA cae simultáneamente por inflación
      - Factores independientes pero correlacionados

4. IMPLICACIONES PARA INVERSORES
   - Diversificación: Oro no perfectamente correlacionado con PA
   - Cobertura parcial: Oro ayuda en crisis, pero no recupera todo
   - Timing: Peak oro en 2020, pero PA seguía cayendo hasta 2024
   → Conclusión: Oro actúa como seguro, no como inversión de retorno

LIMITACIONES:
- Correlación mensual puede ocultar relaciones de más corto plazo
- Oro en EUR depende de tipo de cambio EUR/USD (confounding variable)
- PA es agregado nacional, oro es precio global (mercado distinto)
- Datos de corte transversal en tiempo no implican causalidad
```

#### **6.2.4 Implementación Técnica**

**Opción: Altair (Python + Vega-Lite)**

```python
import altair as alt
import pandas as pd
import numpy as np
from scipy.stats import linregress

# Cargar datos
df = pd.read_csv('poder_adquisitivo_oro_correlacion.csv')
df['fecha'] = pd.to_datetime(df['fecha'])
df['año_fraccional'] = df['fecha'].dt.year + df['fecha'].dt.month / 12

# Calcular regresión
slope, intercept, r_value, p_value, std_err = linregress(
    df['poder_adquisitivo_idx'], df['precio_oro_eur']
)
df['regresion'] = slope * df['poder_adquisitivo_idx'] + intercept

# Normalizar color por tiempo
df['tiempo_norm'] = (df['año_fraccional'] - df['año_fraccional'].min()) / (
    df['año_fraccional'].max() - df['año_fraccional'].min()
)

# Crear escala de color (azul a rojo)
color_scale = alt.Scale(
    domain=[0, 0.5, 1],
    range=['#003da5', '#28a745', '#dc3545']
)

# Gráfico principal
points = alt.Chart(df).mark_point(filled=True, opacity=0.7).encode(
    x=alt.X('poder_adquisitivo_idx:Q',
            title='Poder Adquisitivo (Índice 2010=100)',
            scale=alt.Scale(domain=[88, 105])),
    y=alt.Y('precio_oro_eur:Q',
            title='Precio del Oro (EUR/oz)',
            scale=alt.Scale(domain=[1400, 2500])),
    size=alt.Size('inflacion_yoy_pct:Q',
                  scale=alt.Scale(range=[80, 250]),
                  title='Inflación YoY (%)'),
    color=alt.Color('tiempo_norm:Q',
                   scale=color_scale,
                   title='Período (2010→2025)',
                   legend=None),
    tooltip=['fecha:T', 'poder_adquisitivo_idx:Q', 'precio_oro_eur:Q', 
             'inflacion_yoy_pct:Q']
).interactive()

# Línea de regresión
regresion_line = alt.Chart(df).mark_line(color='black', strokeDash=[5, 5]).encode(
    x='poder_adquisitivo_idx:Q',
    y=alt.Y('regresion:Q')
)

# Combinar
chart = (points + regresion_line).properties(
    width=900,
    height=600,
    title=f'Correlación Oro–Poder Adquisitivo (r={r_value:.3f}, p<0.05)'
).interactive()

chart.show()
chart.save('viz2_correlacion_oro_pa.html')

print(f"Correlación de Pearson: {r_value:.4f}")
print(f"p-value: {p_value:.2e}")
print(f"R²: {r_value**2:.4f}")
print(f"Pendiente: {slope:.4f} EUR/oz por unidad PA")
```

---

## APARTADO 7: MEMORIA DE MÁXIMO 8 PÁGINAS (10%)

[Estructura redactada en documento separado: `MEMORIA_PRÁCTICA_MACROECONOMIA.pdf`]

Contenido mínimo:
1. Portada (autores, fecha, institución)
2. Resumen ejecutivo (1 página)
3. Apartado 1–8 resumido (6 páginas, 0.75 páginas promedio cada uno)
4. Conclusiones y limitaciones (0.5 páginas)
5. Figuras clave (2 visualizaciones principales)

---

## APARTADO 8: REPOSITORIO GITHUB (5%)

### 8.1 Estructura del Proyecto

```
macroeconomia-españa-2024/
│
├── README.md                          # Portada, instrucciones reproducibilidad
├── LICENSE                            # CC-BY-4.0
├── CITATION.cff                       # Cita académica BibTeX
├── requirements.txt                   # Dependencias Python
├── environment.yml                    # Conda environment
├── Makefile                          # Orquestación automática
│
├── data/
│   ├── raw/                          # Datos originales descargados
│   │   ├── ipc_es_ine_2010_2025.csv
│   │   ├── salarios_ine_2010_2025.csv
│   │   ├── hicp_eurostat_2010_2025.csv
│   │   ├── oro_usd_2010_2025.csv
│   │   ├── eurusd_2010_2025.csv
│   │   └── ibex35_bme_2010_2025.csv
│   ├── processed/                     # Datos tras ETL
│   │   ├── ipc_limpio.csv
│   │   ├── salarios_deflactados.csv
│   │   ├── oro_eur_convertido.csv
│   │   ├── poder_adquisitivo_idx.csv
│   │   └── hechos_indicadores_temporales.csv
│   └── intermediate/                  # Pasos intermedios ETL
│       ├── paso2_limpieza.csv
│       ├── paso3_normalizacion.csv
│       └── validacion_calidad.log
│
├── etl/
│   ├── pdi/                          # Pentaho Data Integration
│   │   ├── ETL_MACROECONOMIA_PIPELINE.kjb  # Job maestro
│   │   ├── 01_extraccion_bruto.ktr        # Transformación 1
│   │   ├── 02_limpieza_validacion.ktr      # Transformación 2
│   │   ├── 03_transformacion_enriquecimiento.ktr
│   │   ├── 04_deflactacion_derivados.ktr
│   │   ├── 05_validacion_calidad.ktr
│   │   └── 06_carga_dw.ktr
│   └── python/                        # Scripts Python complementarios
│       ├── extraccion_apis.py
│       ├── imputacion_outliers.py
│       ├── validacion_estadistica.py
│       └── transformacion_rdf.py
│
├── src/
│   ├── create_dw_schema.sql          # Script DDL Data Warehouse
│   ├── conexiones_bd.config          # Config BD (gitignored para prod)
│   └── constantes.py                  # Variables globales, configuración
│
├── notebooks/
│   ├── 01_exploracion_datos.ipynb    # EDA inicial
│   ├── 02_análisis_correlación.ipynb # Análisis estadístico
│   └── 03_validacion_dw.ipynb        # Queries al DW
│
├── viz/
│   ├── 01_poder_adquisitivo_lineal.html   # Visualización 1 (Plotly)
│   ├── 02_correlacion_oro_pa.html          # Visualización 2 (Altair)
│   ├── especificaciones/
│   │   ├── viz1_spec.json
│   │   └── viz2_spec.json
│   └── data_for_viz/
│       ├── poder_adquisitivo_ibex_inflacion.csv
│       └── poder_adquisitivo_oro.csv
│
├── schemaorg/
│   ├── observations_rdf.ttl           # RDF Turtle
│   ├── observations_rdf.xml           # RDF/XML
│   ├── observations.jsonld            # JSON-LD
│   ├── dataset_metadata.jsonld        # Metadatos Dataset
│   └── validacion_grafo.sparql        # Queries SPARQL validación
│
├── docs/
│   ├── MEMORIA_PRÁCTICA.pdf           # Memoria 8 páginas
│   ├── APARTADO_1_definicion.md
│   ├── APARTADO_2_datasets.md
│   ├── APARTADO_3_diseño_dw.md
│   ├── APARTADO_4_etl_pentaho.md
│   ├── APARTADO_5_schemaorg.md
│   ├── APARTADO_6_visualizaciones.md
│   ├── APARTADO_8_github.md
│   ├── CAMBIOS.md                    # Redefiniciones de preguntas
│   ├── LIMITACIONES.md               # Limitaciones metodológicas
│   ├── TRABAJO_FUTURO.md             # Sugerencias mejoras
│   └── REFERENCIAS.bib               # Bibliografía BibTeX
│
├── tests/
│   ├── test_calidad_datos.py         # Tests unitarios validación
│   ├── test_transformaciones.py       # Tests ETL
│   └── test_dw_integridad.sql        # Tests BD integridad
│
├── outputs/
│   ├── logs/
│   │   ├── etl_execution_2024_12_15.log
│   │   └── validation_report_2024_12_15.csv
│   ├── reports/
│   │   ├── calidad_datos_resumen.xlsx
│   │   ├── duplicados_conflictivos.csv
│   │   └── outliers_detectados.csv
│   └── artifacts/
│       ├── dw_schema_diagram.png
│       └── pipeline_flujo.png
│
├── .github/
│   └── workflows/
│       └── etl_pipeline.yml          # CI/CD (ejecutar ETL automático)
│
├── .gitignore                         # Excluir datos sensibles, config local
└── Dockerfile                         # Reproducibilidad en contenedor

```

### 8.2 README.md Detallado

```markdown
# Macroeconomic Indicators for Spain: Power of Acquisition Analysis (2010-2025)

## Descripción

Almacén de datos integrado que analiza la erosión del poder adquisitivo de las familias españolas 
vinculándolo con depreciación del euro, inflación (HICP/IPC), salarios nominales y reales, 
evolución de índices bursátiles (IBEX-35), tipos de cambio EUR/USD y precio del oro.

**Preguntas de investigación:**
- P1: ¿Cómo ha evolucionado el poder adquisitivo real en España (2010-2025)?
- P2: ¿Qué relación existe entre inflación y salarios reales?
- P3: ¿Cómo se correlaciona el oro en EUR con la pérdida de poder adquisitivo?
- P4: ¿Es el IBEX-35 cobertura efectiva contra inflación?
- P5: ¿Cuál ha sido el impacto de depreciación del euro?

## Estructura del Proyecto

Ver archivo `docs/ESTRUCTURA_PROYECTO.md` para detalle completo.

Directorios principales:
- `data/` - Datos raw, processed, e intermedios
- `etl/` - Pipelines Pentaho + Python
- `src/` - Scripts SQL, Python de configuración
- `viz/` - Visualizaciones HTML interactivas
- `schemaorg/` - Transformaciones RDF/JSON-LD
- `docs/` - Documentación completa

## Requisitos y Preparación del Entorno

### Requisitos Previos
- Python 3.9+
- PostgreSQL 12+
- Pentaho Data Integration (Community Edition) 9.0+
- Git

### Instalación

1. **Clonar repositorio:**
   ```bash
   git clone https://github.com/your-username/macroeconomia-españa-2024.git
   cd macroeconomia-españa-2024
   ```

2. **Crear entorno Python:**
   ```bash
   conda env create -f environment.yml
   conda activate macroeconomia-es
   ```

   O con pip:
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   # o
   venv\Scripts\activate  # Windows
   pip install -r requirements.txt
   ```

3. **Configurar Base de Datos:**
   ```bash
   # Crear BD PostgreSQL
   createdb macroeconomia_es
   
   # Cargar esquema
   psql macroeconomia_es -f src/create_dw_schema.sql
   
   # Verificar tablas
   psql macroeconomia_es -c "\dt"
   ```

4. **Configurar variables de entorno:**
   ```bash
   cp .env.template .env
   # Editar .env con credenciales locales (BD, APIs, etc.)
   ```

## Pipeline de Ejecución de Extremo a Extremo

### Opción 1: Automático (Makefile)

```bash
# Ejecutar todo el pipeline
make all

# O pasos individuales:
make extract      # Paso 1: Extracción
make clean         # Paso 2: Limpieza
make transform     # Paso 3-5: Transformación y validación
make load          # Paso 6: Carga a DW
make viz           # Generar visualizaciones
make rdf           # Transformar a RDF
make report        # Generar reportes
```

### Opción 2: Manual con Pentaho

```bash
# 1. Abrir Pentaho Spoon
/opt/pentaho/pdi/spoon.sh

# 2. Abrir job maestro
File > Open > etl/pdi/ETL_MACROECONOMIA_PIPELINE.kjb

# 3. Ejecutar
Action > Run
```

### Opción 3: Python Scripts

```bash
# Ejecutar paso a paso
python etl/python/extraccion_apis.py
python etl/python/imputacion_outliers.py
python etl/python/validacion_estadistica.py
python etl/python/transformacion_rdf.py
```

## Cómo Regenerar Figuras y Análisis

### Visualización 1: Poder Adquisitivo vs. Inflación + IBEX

```bash
# Generar datos de entrada
python notebooks/01_exploracion_datos.ipynb

# Generar visualización
python viz/generar_viz1_plotly.py

# Salida: viz/01_poder_adquisitivo_lineal.html
```

### Visualización 2: Correlación Oro–PA

```bash
python notebooks/02_análisis_correlación.ipynb
python viz/generar_viz2_altair.py

# Salida: viz/02_correlacion_oro_pa.html
```

### Tablas de Análisis

```bash
psql macroeconomia_es -f notebooks/03_validacion_dw.sql > outputs/análisis.txt
```

## Validación de Resultados

### Verificaciones Rápidas Pre-Entrega

```bash
# 1. Verificar integridad de datos
python tests/test_calidad_datos.py

# 2. Verificar transformaciones ETL
python tests/test_transformaciones.py

# 3. Verificar BD y DW
psql macroeconomia_es -f tests/test_dw_integridad.sql

# 4. Validar RDF
python schemaorg/validar_grafo.py

# Resultado esperado: Todos los tests pasan con 0 fallos
```

### Criterios de Calidad

| Métrica | Umbral | Comando |
|---|---|---|
| Cobertura temporal | ≥95% | `make test-cobertura` |
| Consistencia IPC–HICP | <1% RMSE | `make test-consistencia` |
| Completitud ETL | 100% transformaciones | `grep "ERROR" outputs/logs/*.log` |
| RDF Validez | 100% URIs válidas | `python schemaorg/validar_grafo.py` |

## Criterios de Calidad Aplicados

### Datos
- Rango de valores: Validados por indicador
- Monotonicidad temporal: Chequeada en índices acumulativos
- Unicidad de claves: 0 duplicados aceptados
- Consistencia entre fuentes: RMSE(IPC,HICP) < 1%

### Transformaciones
- Cobertura: 100% de registros procesados
- Validaciones pasadas: ≥98%
- Logs completos: Cada paso documentado
- Trazabilidad: Cada derivado vinculado a fuente original

### Visualizaciones
- Exactitud: Verificada vs. queries directas a BD
- Legibilidad: Anotaciones, leyendas, títulos completos
- Interactividad: Tooltip, zoom, brushing

## Licencia

CC-BY-4.0 (Creative Commons Attribution 4.0 International)

Debes atribuir a:
- Instituto Nacional de Estadística (INE) - Datos IPC, Salarios
- Eurostat - Datos HICP
- Banco Central Europeo (BCE) - Tipos EUR/USD
- London Bullion Market Association (LBMA) - Precio oro
- Bolsas y Mercados Españoles (BME) - Datos IBEX-35

## Referencias

[1] Kimball, R., & Ross, M. (2013). The data warehouse toolkit: The definitive guide to dimensional modeling.

[2] INE (2024). Índice de Precios al Consumo - Metodología. https://www.ine.es/

[3] Banco de España (2024). Salarios en la Economía Española. Serie Trimestral.

[4] ECB (2024). Foreign exchange rates. https://www.ecb.europa.eu/

[5] Schema.org (2024). Schema.org Full Hierarchy. https://schema.org/

## Autores

- [Tu Nombre] (Principal)
- [Co-autores si aplica]

## Contacto

Para preguntas, abrira issue en GitHub: https://github.com/your-username/macroeconomia-españa-2024/issues

## Agradecimientos

- Profesores asignatura "Adquisición y Preparación de Datos", Universidad de Alicante
- Comunidad Pentaho Data Integration
- INE, Eurostat, BCE por datos públicos de calidad
```

### 8.3 Versionado y Etiquetado

```bash
# Crear versión v1.0.0
git tag -a v1.0.0 -m "Release: Entrega práctica APD, 2024-12-15"
git push origin v1.0.0

# Versión en CITATION.cff
cff-version: 1.2.0
title: "Depreciación del Euro y Erosión del Poder Adquisitivo en España (2010-2025)"
authors:
  - family-names: "Tu Apellido"
    given-names: "Tu Nombre"
    affiliation: "Universidad de Alicante"
date-released: 2024-12-15
version: 1.0.0
license: CC-BY-4.0
repository-code: https://github.com/your-username/macroeconomia-españa-2024
```

### 8.4 CI/CD con GitHub Actions (Opcional)

```yaml
# .github/workflows/etl_pipeline.yml
name: ETL Macroeconomia Pipeline

on:
  schedule:
    - cron: '0 2 * * SUN'  # Cada domingo a las 02:00 UTC
  workflow_dispatch:

jobs:
  etl:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: 3.9
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
      - name: Run ETL
        run: |
          make extract
          make clean
          make transform
          make load
      - name: Run tests
        run: |
          pytest tests/
      - name: Generate report
        run: make report
      - name: Commit changes
        if: always()
        run: |
          git config user.email "etl@github.com"
          git config user.name "ETL Bot"
          git add -A
          git commit -m "Auto: ETL execution $(date)" || true
          git push
```

---

## CHECKLIST DE VERIFICACIÓN PREVIA A ENTREGA

### Antes de Subir a GitHub

- [ ] Todos los scripts ejecutan sin errores
- [ ] Base de datos creada y poblada completamente
- [ ] Visualizaciones HTML generadas y funcionales
- [ ] RDF validado y sin ciclos
- [ ] Memoria redactada (≤8 páginas)
- [ ] README.md completo y actualizado
- [ ] .gitignore excluye datos/credenciales sensibles
- [ ] LICENSE presente (CC-BY-4.0)
- [ ] CITATION.cff presente
- [ ] requirements.txt y environment.yml sincronizados
- [ ] Makefile funcional para reproducibilidad
- [ ] Al menos 2 tests unitarios pasando
- [ ] Logs de auditoría en outputs/
- [ ] Diagrama de DW en outputs/artifacts/
- [ ] Documento CAMBIOS.md si hubo redefiniciones
- [ ] Documento LIMITACIONES.md completado

### Antes de Entregar en Moodle

- [ ] Todos los puntos anteriores completados
- [ ] Navegación del repositorio clara y lógica
- [ ] Archivos grandes (>10 MB) en .gitignore
- [ ] URLs verificadas y funcionales (sin links rotos)
- [ ] Fechas y formatos de fecha ISO 8601 consistentes
- [ ] Citas de fuentes completas y verificadas
- [ ] Conclusiones y futura investigación documentadas
- [ ] Archivo ZIP del repositorio preparado para entrega alternativa

---

## FICHAS TÉCNICAS DE DATASETS CSV

### Dataset: cpi_es.csv

```
Columna,Tipo,Unidad,Rango,Descripción
date,DATE,ISO 8601,2010-01-01:2025-12-31,Última del mes
hicp_index,DECIMAL(6,2),Índice base=2021,80–150,HICP para España
hicp_yoy,DECIMAL(5,3),%,-5–+15,Variación interanual HICP
ipc_index,DECIMAL(6,2),Índice base=2021,80–150,IPC para España
ipc_yoy,DECIMAL(5,3),%,-5–+15,Variación interanual IPC
geo,VARCHAR(5),ISO 3166-1,ES,Código geográfico
source,VARCHAR(50),,INE; EUROSTAT,Institución origen

Restricciones:
- PK: (date, geo, source)
- date debe ser último día del mes
- Valores NULLs indicarán imputación si probabilidad_imputación > 0
```

### Dataset: salarios.csv

```
Columna,Tipo,Unidad,Rango,Descripción
date,DATE,ISO 8601,2010-Q1:2025-Q4,Periodo trimestral
wage_nominal_idx,DECIMAL(6,2),Índice 2010=100,90–130,Salario nominal indexado
wage_real_idx,DECIMAL(6,2),Índice 2010=100,85–105,Salario real (deflactado)
base_year,INT,,2010,Año base para índice
sector,VARCHAR(20),Opcional,Total Economía,Sector CNAE si disponible
geo,VARCHAR(5),ISO 3166-1,ES,Código geográfico
source,VARCHAR(50),,INE,Institución origen

Restricciones:
- PK: (date, sector, geo, source)
- wage_real_idx = wage_nominal_idx / (CPI_t / 100)
```

### Dataset: ibex.csv

```
Columna,Tipo,Unidad,Rango,Descripción
date,DATE,ISO 8601,2010-01-01:2025-12-31,Fecha de cotización
close,DECIMAL(8,2),Puntos índice,7000–11000,Cierre de sesión
open,DECIMAL(8,2),Puntos índice,7000–11000,Apertura de sesión
high,DECIMAL(8,2),Puntos índice,7000–11000,Máximo del día
low,DECIMAL(8,2),Puntos índice,7000–11000,Mínimo del día
volume,INT,Acciones,0–500M,Volumen de contratación
total_return_idx,DECIMAL(8,2),Índice con dividendos,7000–12000,Índice total return si disponible
currency,VARCHAR(3),ISO 4217,EUR,Moneda (EUR)
source,VARCHAR(50),,BME; Yahoo,Institución origen

Restricciones:
- PK: (date, source)
- close > 0, open > 0
- Sesiones de fin de semana/festivos excluidas
```

### Dataset: oro_eur.csv

```
Columna,Tipo,Unidad,Rango,Descripción
date,DATE,ISO 8601,2010-01-01:2025-12-31,Fecha fixing PM LBMA
price_usd_per_oz,DECIMAL(8,2),USD/oz troy,300–2500,Precio en USD
price_eur_per_oz,DECIMAL(8,2),EUR/oz troy,250–2500,Precio en EUR (convertido)
eurusd_rate,DECIMAL(6,4),EUR/USD,0.80–1.20,Tipo cambio aplicado
source,VARCHAR(50),,LBMA; KITCO; OANDA,Institución origen

Restricciones:
- PK: (date)
- price_eur_per_oz = price_usd_per_oz * eurusd_rate
- Solo fixing PM (15:00 UK)
```

### Dataset: eurusd.csv

```
Columna,Tipo,Unidad,Rango,Descripción
date,DATE,ISO 8601,2010-01-01:2025-12-31,Fecha de cotización
rate,DECIMAL(6,4),EUR/USD,0.80–1.20,Tipo de cambio cierre
source,VARCHAR(50),,BCE; OANDA; Yahoo,Institución origen

Restricciones:
- PK: (date, source)
- rate > 0
- Sesiones de fin de semana/festivos pueden excluirse
```

---

## FÓRMULAS Y EXPRESIONES CLAVE

### Poder Adquisitivo Real

\[ PA_{real,t} = 100 \times \frac{W_{nominal,t}}{CPI_t / 100} \]

Donde:
- PA_{real,t} = Poder adquisitivo en período t
- W_{nominal,t} = Salario nominal período t
- CPI_t = Índice de precios período t (base 100)

Ejemplo: Si W_{nominal,2024} = 1850 EUR y CPI_{2024} = 135.5 (base 2021), entonces:
PA_{real,2024} = 100 × (1850 / (135.5/100)) = 1366 EUR en términos reales

### Variación Interanual

\[ Var_{YoY,t} = \frac{X_t - X_{t-12}}{X_{t-12}} \times 100\% \]

Ejemplo IPC: Si IPC_{Jan-2024} = 135.5 e IPC_{Jan-2023} = 128.2:
Var_{YoY} = ((135.5 - 128.2) / 128.2) × 100% = 5.67%

### Reindexación Base 100

\[ X_{norm,t} = 100 \times \frac{X_t}{X_{t_0}} \]

Donde t_0 = 2010-01-01

Ejemplo IBEX: Si IBEX_{2010-01} = 8965 e IBEX_{2024-12} = 10850:
IBEX_{norm,2024} = 100 × (10850 / 8965) = 121.0 (índice base 100)

### Rendimiento Logarítmico

\[ r_t = \ln(X_t) - \ln(X_{t-1}) \]

Ejemplo: Si Oro_{2024-01-31} = 1932 EUR/oz y Oro_{2024-01-30} = 1920 EUR/oz:
r_t = ln(1932) - ln(1920) = 7.568 - 7.560 = 0.0064 = 0.64%

### Correlación de Pearson

\[ \rho(X,Y) = \frac{\sum_{t=1}^{n} (X_t - \overline{X})(Y_t - \overline{Y})}{\sqrt{\sum_{t=1}^{n} (X_t - \overline{X})^2} \sqrt{\sum_{t=1}^{n} (Y_t - \overline{Y})^2}} \]

Rango: -1 (perfectamente negativa) a +1 (perfectamente positiva)

Ejemplo esperado: Correlación(Poder Adquisitivo, Precio Oro) ≈ -0.60

---

**VERSIÓN:** 1.0.0  
**ÚLTIMA ACTUALIZACIÓN:** 15 de diciembre de 2024  
**ESTADO:** Listo para evaluación académica  
**AUTORES:** [Tu Nombre y Co-autores]  
**INSTITUCIÓN:** Universidad de Alicante, Escuela Politécnica Superior
