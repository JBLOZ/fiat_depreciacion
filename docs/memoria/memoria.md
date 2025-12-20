# MEMORIA DEL PROYECTO
## Depreciación del euro y erosión del poder adquisitivo en España (2010-2025)

**Repositorio GitHub:** https://github.com/JBLOZ/fiat_depreciacion

***

## 1. DEFINICIÓN DEL PROYECTO CENTRADO EN LOS DATOS

### Introducción y contexto

Durante el periodo de 2010 a 2025, la economía española ha estado marcada por una combinación de crisis financieras, políticas monetarias expansivas, choques externos y la crisis de deuda europea. Estos factores han generado un fenómeno económico de gran relevancia: la **inflación oculta**, es decir, aquella inflación que no se mide directamente a través del IPC oficial, sino que se refleja en la depreciación de activos, la pérdida de poder adquisitivo del euro frente a otras monedas y el incremento del valor de activos refugio como el oro.[3][1]

Este proyecto nace de la necesidad de analizar cómo estos fenómenos macroeconómicos han afectado realmente al poder adquisitivo de los hogares españoles, más allá de las cifras oficiales de inflación. La depreciación del euro, el estancamiento salarial y el comportamiento de los mercados financieros son elementos clave para comprender la erosión del bienestar económico de la población.

### Preguntas de investigación

Para abordar este problema de manera estructurada, nos planteamos las siguientes preguntas:

1. **¿Cómo ha evolucionado el valor real de una inversión inicial en diferentes activos frente a la pérdida de poder adquisitivo del efectivo?**
2. **¿Cuál es la "inflación oculta" si medimos el salario medio en activos reales como el oro en lugar de en moneda fiat?**
3. **¿Qué activos han ofrecido rendimientos reales positivos de forma consistente a lo largo del periodo 2010-2025?**
4. **¿Cómo afecta la capacidad de ahorro y la estrategia de inversión a la acumulación de patrimonio según el decil salarial?**
5. **¿En qué medida la brecha de desigualdad patrimonial supera a la brecha salarial debido al acceso diferencial a activos refugio?**

### Objetivos del proyecto

- Integrar datos económicos heterogéneos de fuentes oficiales y mercados financieros (INE y Yahoo Finance)
- Diseñar un almacén de datos analítico que permita consultas temporales complejas
- Implementar un proceso ETL reproducible con Pentaho Data Integration y Python
- Generar visualizaciones que respondan a las preguntas de investigación
- Transformar los datos a formato semántico usando schema.org

***

## 2. ANALIZAR Y EVALUAR NECESIDADES DE DATOS

### Fuentes de datos utilizadas

Para responder a nuestras preguntas de investigación, hemos seleccionado y justificado los siguientes conjuntos de datos:[1][3]

#### **Carpeta 1: Empleo**
- **Salarios temporales e indefinidos (2010-2024):** Datos del INE sobre la evolución salarial según tipo de contrato, fundamentales para analizar la precariedad laboral
- **Desempleo por edades (2010-2025):** Tasas de desempleo desagregadas por grupos de edad, clave para entender el impacto diferencial de las crisis

#### **Carpeta 2: Índices bursátiles**
- **IBEX-35:** Serie histórica del principal índice bursátil español, utilizado como aproximación de la rentabilidad de activos financieros españoles.

#### **Carpeta 3: IPC (Índice de Precios al Consumo)**
- **IPC general (2010-2021):** Índice agregado de inflación oficial
- **IPC por tipos (Tipo 1, Tipo 4, Tipo 11) (2010-2021):** Desagregación por categorías de productos para análisis más fino de la inflación sectorial

#### **Carpeta 4: Oro**
- **Precio del oro (USD):** Serie histórica del precio del oro en dólares, activo refugio tradicional frente a la inflación

#### **Carpeta 5: Salarios**
- **Salario medio mensual (2010-2023):** Datos del INE sobre evolución del salario medio por periodos mensuales
- **Salario medio, mediano y más frecuente anual (2010-2023):** Estadísticas descriptivas para analizar desigualdad y distribución salarial

#### **Carpeta 6: Tipo de cambio**
- **EUR/USD:** Tipo de cambio oficial euro-dólar del BCE, imprescindible para convertir el precio del oro y analizar la depreciación del euro

### Justificación de la selección

Todos estos conjuntos de datos provienen de fuentes públicas y oficiales (INE, Yahoo Finance), garantizando su fiabilidad y permitiendo la reproducibilidad del análisis. La combinación de datos macroeconómicos (IPC, tipo de cambio), laborales (salarios, desempleo) y financieros (IBEX-35, oro) permite una visión multidimensional del fenómeno estudiado.[3]

No ha sido necesario utilizar datos ficticios, ya que todas las fuentes proporcionan series históricas completas para el periodo analizado.

***

## 3. DISEÑO CONCEPTUAL, LÓGICO Y FÍSICO DEL ALMACÉN DE DATOS

### Diseño conceptual

Hemos optado por un **modelo en estrella** que facilita las consultas analíticas temporales. El modelo conceptual se estructura en:[1][3]

- **Tabla de hechos (Fact Table):** Contiene las observaciones económicas, cada registro representa el valor de un indicador en una fecha determinada
- **Dimensiones:**
  - **Tiempo:** Fechas completas (día, mes, año) para análisis temporal
  - **Indicador:** Tipo de medida económica (IPC, salario, precio oro, etc.)
  - **Localización:** Ámbito geográfico (España, Global para datos internacionales)
  - **Fuente:** Origen del dato (INE, BCE, Yahoo Finance)
  - **Unidad:** Unidad de medida (euros, porcentaje, índice base 100, etc.)

### Diseño lógico

El esquema lógico se ha diseñado utilizando **MySQL Workbench**, definiendo las relaciones entre la tabla de hechos y las cinco dimensiones mediante claves foráneas. Cada dimensión tiene una clave primaria (ID) que se referencia desde la tabla de hechos.[1]

**Tabla de hechos:**
- `id_hecho` (PK)
- `id_tiempo` (FK)
- `id_indicador` (FK)
- `id_localizacion` (FK)
- `id_fuente` (FK)
- `id_unidad` (FK)
- `valor` (DECIMAL)

### Diseño físico

El diseño físico se ha implementado en **MySQL**, ejecutándose dentro de un contenedor Docker gestionado mediante **docker-compose**. Esta arquitectura garantiza:[3][1]

- **Reproducibilidad:** Cualquier persona puede levantar la base de datos con un solo comando
- **Backups automáticos:** Se generan archivos `.sql` de forma periódica
- **Portabilidad:** El proyecto es independiente del sistema operativo

El script SQL de creación (`schema.sql`) se generó desde MySQL Workbench y se ejecuta automáticamente al iniciar el contenedor. Disponemos de dos backups principales:
1. **Backup inicial:** Con las primeras cargas de prueba
2. **Backup final:** Con todos los datos procesados e integrados

***

## 4. LIMPIEZA, TRANSFORMACIÓN Y NORMALIZACIN DE DATOS

### Proceso ETL con Pentaho Data Integration

Hemos desarrollado un total de **12 transformaciones en Pentaho**, de las cuales **11 se dedican a la limpieza individual de cada conjunto de datos** y **1 se encarga de la carga final en la base de datos**.[1]

#### Transformaciones de limpieza

Cada archivo CSV bruto pasa por su propia transformación Pentaho que incluye las siguientes operaciones:[1]

- **Table Input / CSV File Input:** Lectura del archivo fuente
- **Select Values:** Selección y renombrado de columnas relevantes
- **Replace in String:** Corrección de caracteres especiales y formatos incorrectos
- **String Operations:** Normalización de textos (trim, mayúsculas/minúsculas)
- **Calculator:** Cálculo de indicadores derivados (ej: deflactación de salarios)
- **Add Constants:** Añadir metadatos fijos (país, fuente, unidad)
- **Filter Rows:** Eliminación de registros inválidos o fuera de rango
- **Sort Rows:** Ordenación temporal para facilitar validaciones
- **Modified Java Script Value:** Transformaciones lógicas complejas cuando es necesario
- **Add Sequence:** Generación de identificadores únicos

#### Normalización de fechas

Un aspecto crítico ha sido la **unificación del formato de fechas**. Los datos originales presentaban diferentes formatos (YYYY, YYYY-MM, DD/MM/YYYY), por lo que hemos creado una transformación específica que convierte todos los valores a formato estándar **YYYY-MM-DD**, asegurando la consistencia para la dimensión temporal.[1]

#### Enriquecimiento de datos

Una transformación específica se encarga de **convertir el precio del oro de USD a EUR**, aplicando el tipo de cambio diario EUR/USD. Esto permite comparar el comportamiento del oro con otros activos en la misma moneda.[1]

#### Gestión de valores faltantes y outliers

- **Valores faltantes:** Se han gestionado mediante arrastre del último valor válido (forward fill) en series temporales, o eliminación del registro si afecta a variables clave
- **Outliers:** Se han identificado mediante análisis estadístico básico y validado manualmente contra las fuentes oficiales. No se han detectado errores.

Al tener tantas transformaciones no podemos detallar cada una, pero el patrón general es el siguiente:
1. Leer el CSV bruto
2. Limpiar mediante formatos mediante el nodo de leer csv
4. Filtrar filas inválidas
5. Remplazar valores sin formato UTF-8
6. Remplazar valores nulos o vacíos
7. Remplazar comas por puntos en valores numéricos
8. Remplazar y cortar strings para normalizar los valores
9. Hacer la media de valores dobles como (hombre y mujer) si aplica 
10. Convertir fechas a formato YYYY-MM-DD mediante formulas o javascripts
11. Renombrar columnas para estandarizar
12. Sort de filas por fecha
13. Exportar CSV limpio a carpeta de datos procesados

### Scripts Python de apoyo

Aunque la mayor parte del trabajo ETL se ha realizado en Pentaho, hemos utilizado algunos **scripts Python** para:[1]

- Descarga automatizada de datos desde APIs (cuando está disponible)
- Validación cruzada de fechas entre diferentes fuentes
- Generación de estadísticas de calidad de datos pre-carga

### Datos procesados

Tras el proceso de limpieza, se generan **CSV procesados** en carpetas separadas:[1]

- `empleo/asalariados_indefinidos_temporales_2010_2024.csv`
- `empleo/desempleo_porcentaje_edades.csv`
- `tipo_cambio/euro_exchange_rate.csv`
- `oro/precio_oro_euros.csv` (ya convertido de USD)
- `ipc/ipc_general_anual_2010_2021.csv`
- `indices_bursatiles/ibex35.csv`
- `salarios/salario_anual_medio_mediano_frecuente_2010_2023.csv`
- `salarios/salario_mensual_deciles_2010_2023.csv`

### Transformación de carga en base de datos

La **12ª transformación de Pentaho** es la más compleja: toma cada CSV procesado y lo integra en el modelo estrella:[1]

1. **Lee el CSV procesado**
2. **Aplica constantes específicas** según el tipo de dato (ej: para oro → país='Global', fuente='Yahoo Finance', unidad='EUR/onza', indicador='Precio del oro en euros')
3. **Busca o inserta en dimensiones** mediante componentes `Dimension Lookup/Update`:
   - Si el valor ya existe en la dimensión, recupera su ID
   - Si no existe, lo inserta y devuelve el nuevo ID
4. **Genera o recupera fechas** en la dimensión tiempo usando `Database Lookup`
5. **Inserta en la tabla de hechos** con todos los IDs de dimensiones y el valor numérico

Este proceso garantiza la **integridad referencial** y evita duplicados en las dimensiones.

### Estrategia de ejecución: Transformaciones independientes vs. job de orquestación

Aunque tradicionalmente se recomienda crear un job de Pentaho que orqueste todas las transformaciones en secuencia, en nuestro caso hemos adoptado una **estrategia alternativa** basada en ejecuciones independientes:

**Razón principal:** El proyecto ha sido desarrollado de forma colaborativa desde múltiples dispositivos, con cada usuario manejando rutas locales diferentes para importar CSVs brutos y exportar procesados.

**Decisión:** En lugar de crear un job que ejecute las 12 transformaciones en secuencia, hemos optado por ejecutar cada transformación de forma individual. Esto fue más pragmático porque:

- Habría requerido modificar todas las 12 transformaciones para usar rutas estándar
- La estructura de carpetas (`datos/raw/` y `datos/procesados/`) ya garantiza organización clara
- Se mantiene flexibilidad para cambios incrementales

**Ventaja en mantenimiento:** Si necesitamos ajustar un CSV procesado, simplemente:
1. Modificamos los nodos relevantes en la transformación correspondiente
2. Re-ejecutamos esa transformación
3. Re-ejecutamos la transformación de carga en base de datos para sincronizar

Esta aproximación es válida cuando el flujo de datos es claro y las transformaciones no tienen interdependencias críticas.

***

## 5. TRANSFORMACIÓN SEGÚN SCHEMA.ORG

Para cumplir con el requisito de transformación semántica, hemos generado un archivo **JSON-LD** utilizando el vocabulario de **schema.org**.[3][1]

### Clases y propiedades utilizadas

Hemos mapeado nuestros datos a las siguientes clases de schema.org:

- **`Dataset`:** Representa cada conjunto de datos (IPC, salarios, oro, etc.)
  - `name`: Nombre descriptivo del dataset
  - `description`: Descripción del contenido
  - `creator`: Organización responsable (INE, BCE, etc.)
  - `temporalCoverage`: Rango temporal (ej: "2010/2025")
  - `spatialCoverage`: Cobertura geográfica (España, Global)
  
- **`Observation`:** Representa cada observación individual (un valor en una fecha)
  - `observedNode`: Indicador medido
  - `measuredValue`: Valor numérico
  - `observationDate`: Fecha de la observación

- **`Organization`:** Representa las fuentes de datos (INE, BCE, Yahoo Finance)
  - `name`: Nombre de la organización
  - `url`: Sitio web oficial

- **`Place`:** Representa las localizaciones (España, Global)
  - `name`: Nombre del lugar

### Proceso de transformación

La transformación se realizó mediante un **notebook Python** (`schema_org.ipynb`) que:[1]

1. Lee los datos procesados desde la base de datos
2. Itera sobre cada indicador y genera su estructura JSON-LD
3. Valida la estructura sintáctica del JSON generado
4. Exporta el resultado a `output/schema.jsonld`

### Validación

Hemos validado el archivo JSON-LD generado mediante:
- Verificación sintáctica con parsers JSON estándar
- Comprobación de tipos y propiedades contra la especificación de schema.org
- Revisión manual de una muestra representativa de observaciones

Este formato permite la **interoperabilidad** de nuestros datos con sistemas de datos enlazados y facilita su reutilización por terceros.

***

## 6. VISUALIZACIÓN

Para responder a las preguntas de investigación planteadas, hemos implementado múltiples visualizaciones en el notebook `visualizaciones_finales.ipynb`.[1]

### Visualización 1: La Gran Divergencia - Euro vs Activos Reales

**Tipo:** Gráfico de líneas múltiples y áreas

**Descripción:** Representa la evolución de 100€ invertidos en 2010 en diferentes activos (Efectivo, Oro, IBEX-35 y Salario Medio), todos ajustados por la inflación real para mostrar su poder adquisitivo.

**Conclusión:** El efectivo pierde valor de forma garantizada por la inflación, mientras que el oro ha multiplicado su valor real un ~150%, actuando como la mejor reserva de valor del periodo.

### Visualización 2: El Salario medido en Oro (Inflación Oculta)

**Tipo:** Gráfico de barras y áreas

**Descripción:** Muestra cuántas onzas de oro puede comprar un salario medio anual y el número de horas de trabajo necesarias para adquirir una onza de oro.

**Conclusión:** Se revela una "inflación oculta" masiva: un trabajador español necesita trabajar hoy aproximadamente un 60% más de horas que en 2010 para adquirir la misma cantidad de oro.

### Visualización 3: Heatmap de Rendimientos Reales Anuales

**Tipo:** Mapa de calor (Heatmap)

**Descripción:** Presenta el rendimiento porcentual anual de cada activo una vez descontada la inflación oficial (IPC).

**Conclusión:** El efectivo muestra rendimientos reales negativos constantes (pérdida de poder adquisitivo), mientras que el oro destaca como el activo con rendimientos positivos más consistentes.

### Visualización 4: Simulación de Patrimonio por Clase Social

**Tipo:** Gráfico de líneas y barras apiladas

**Descripción:** Simulación de la evolución del patrimonio de tres perfiles (Clase Baja, Media y Alta) basada en su capacidad de ahorro y su estrategia de inversión (acceso a activos reales vs. efectivo).

**Conclusión:** La capacidad de ahorro combinada con el acceso a activos que baten la inflación actúa como un multiplicador de la riqueza, ensanchando la brecha entre clases sociales.

### Visualización 5: Brechas de Desigualdad (Salarial vs. Patrimonial)

**Tipo:** Gráfico de áreas

**Descripción:** Compara el ratio de desigualdad salarial (Decil 9 / Decil 1) frente al ratio de desigualdad patrimonial acumulada.

**Conclusión:** La brecha patrimonial crece a un ritmo muy superior a la brecha salarial, demostrando que la desigualdad no solo es una cuestión de ingresos, sino de capacidad de preservación del valor del ahorro.

### Herramientas utilizadas

Las visualizaciones se han generado con:
- **Python:** matplotlib, seaborn, numpy
- **Jupyter Notebook:** Para documentar el proceso analítico

Todas las visualizaciones están exportadas en formato PNG de alta resolución en la carpeta `docs/`.

***

## 7. Conclusionse


### Contribuciones del equipo

### Resultados principales

1. **Pérdida de poder adquisitivo confirmada:** El efectivo ha perdido una parte sustancial de su valor real, mientras que los salarios apenas han logrado mantener el ritmo de la inflación oficial.
2. **Inflación oculta detectada:** Al medir la economía en activos reales (oro), se observa una erosión del bienestar mucho mayor que la reportada por el IPC oficial.
3. **Desigualdad patrimonial acelerada:** El acceso diferencial a activos refugio (oro, bolsa) ha provocado que la brecha de riqueza crezca más rápido que la brecha de ingresos.
4. **Eficacia de los activos refugio:** El oro se ha consolidado como la mejor protección contra la depreciación monetaria en el periodo 2010-2025.

### Limitaciones

- Diferencias de frecuencia temporal entre indicadores (algunos anuales, otros mensuales)
- Dependencia de revisiones estadísticas oficiales del INE
- Simplificaciones en la imputación de valores faltantes

### Trabajo futuro

- Incorporar modelos predictivos (ARIMA, LSTM) para proyectar tendencias
- Desagregar geográficamente por comunidades autónomas
- Integrar datos de patrimonio inmobiliario como activo adicional

***

## 8. REPOSITORIO DE CÓDIGO

### Estructura del repositorio

El proyecto está completamente documentado y disponible en GitHub: **https://github.com/JBLOZ/fiat_depreciacion**

```
fiat_depreciacion/
├── datos/
│   ├── brutos/              # CSVs originales sin procesar
│   └── procesados/          # CSVs limpios y normalizados
├── pentaho/
│   ├── transformaciones/    # 12 archivos .ktr
│   └── jobs/                # Orquestación de transformaciones
├── scripts/
│   └── python/              # Scripts auxiliares
├── sql/
│   ├── schema.sql           # Creación del almacén de datos
│   └── backups/             # Copias de seguridad
├── notebooks/
│   ├── schema_org.ipynb     # Transformación semántica
│   └── visualizaciones_finales.ipynb  # Análisis y gráficos
├── docs/
│   └── imagenes/            # Visualizaciones exportadas
├── output/
│   └── schema.jsonld        # Datos en formato JSON-LD
├── docker-compose.yml       # Configuración de MySQL
├── README.md                # Descripción del proyecto
└── PROYECTO.md              # Documentación extendida
```

### README.md

El archivo README.md incluye:[4]
- Descripción general del proyecto
- Instrucciones de instalación y uso
- Tecnologías utilizadas
- Estructura del repositorio
- Enlace a la documentación completa

### Licencia

El proyecto se distribuye bajo una licencia de código abierto que permite su reutilización con atribución.

### Referencias

- Instituto Nacional de Estadística (INE): https://www.ine.es
- Banco Central Europeo (BCE): https://www.ecb.europa.eu
- Yahoo Finance: https://finance.yahoo.com
- Schema.org: https://schema.org

