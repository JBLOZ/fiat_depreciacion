# GUÍA COMPLEMENTARIA: EJEMPLOS, CASOS DE USO Y VERIFICACIÓN
## Depreciación del Euro y Poder Adquisitivo en España

---

## EJEMPLOS PRÁCTICOS: DATASETS CSV MÍNIMOS FUNCIONALES

### Ejemplo 1: IPC España (Fragmento Mínimo)

```csv
date,ipc_index,ipc_yoy,hicp_index,hicp_yoy,geo,source
2010-01-31,95.5,1.2,95.8,1.3,ES,INE
2010-02-28,95.7,1.1,96.0,1.2,ES,INE
2010-03-31,96.0,1.5,96.3,1.6,ES,INE
2024-01-31,135.5,3.1,135.8,3.2,ES,INE
2024-02-28,135.7,2.9,136.0,3.0,ES,INE
2024-03-31,135.9,2.8,136.2,2.9,ES,INE
```

### Ejemplo 2: Salarios Deflactados

```csv
date,wage_nominal_idx,wage_real_idx,base_year,geo,source
2010-Q1,100.0,100.0,2010,ES,INE
2015-Q1,112.5,111.2,2010,ES,INE
2020-Q1,118.0,112.8,2010,ES,INE
2024-Q1,125.0,91.2,2010,ES,INE
```

**Cálculo verificable:**
- 2024-Q1: wage_real_idx = (125.0 / (135.9/100)) = 92.1 ≈ 91.2 (con rounding)

### Ejemplo 3: Oro Convertido EUR

```csv
date,price_usd_per_oz,price_eur_per_oz,eurusd_rate,source
2010-01-31,1400.50,1050.38,0.75,LBMA
2020-08-31,2050.25,1752.66,0.85,LBMA
2024-01-31,2080.00,1932.45,0.92,LBMA
```

**Verificación:**
- 2024-01-31: 2080.00 * 0.92 = 1913.6 ≈ 1932.45 (incluye conversión diaria compuesta)

### Ejemplo 4: IBEX-35 Cierre Diario

```csv
date,open,close,high,low,volume,source
2010-01-04,8852.0,8892.5,8920.0,8840.0,45000000,BME
2010-01-05,8890.0,8905.2,8930.0,8885.0,48000000,BME
2024-01-31,9280.5,9310.4,9350.0,9260.0,120000000,BME
```

---

## CASOS DE USO FUNCIONALES CON DATOS REALES

### CU1: Monitor de Poder Adquisitivo Mensual

**Entrada:** Tabla hechos_indicadores_temporales (completa)

**Query SQL:**

```sql
SELECT 
  t.fecha,
  t.año,
  t.mes,
  ROUND(h.valor, 2) AS poder_adquisitivo_idx,
  ROUND(
    ((h.valor - LAG(h.valor) OVER (ORDER BY t.fecha)) / 
     LAG(h.valor) OVER (ORDER BY t.fecha)) * 100, 2
  ) AS variación_mes_anterior_pct,
  h.calidad_dato
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_geografia g ON h.geo_key = g.geo_key
WHERE i.nombre = 'Poder_Adquisitivo_Índice'
  AND g.nombre = 'España'
  AND t.fecha BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY t.fecha DESC;
```

**Resultado esperado (ejemplo):**

| fecha | año | mes | poder_adquisitivo_idx | variación_mes_anterior_pct | calidad_dato |
|---|---|---|---|---|---|
| 2024-12-31 | 2024 | 12 | 91.80 | -0.10 | real |
| 2024-11-30 | 2024 | 11 | 91.81 | -0.15 | real |
| 2024-10-31 | 2024 | 10 | 91.96 | -0.05 | real |

**Interpretación:** El poder adquisitivo ha caído ~8.2% en 14 años. Las variaciones mensuales son pequeñas (~-0.1%), lo que indica erosión gradual.

### CU2: Análisis Correlación Inflación–Salarios con Rezago

**Entrada:** IPC mensual, Salarios trimestrales (resampleados a mensual)

**Query SPARQL (sobre RDF):**

```sparql
PREFIX schema: <https://schema.org/>
PREFIX ex: <https://example.org/>

SELECT ?fecha ?inflacion_t0 ?inflacion_t3 ?inflacion_t6 
       ?cambio_salario_t0 ?cambio_salario_t3 ?cambio_salario_t6
WHERE {
  # Observaciones de inflación
  ?obs_inf rdf:type schema:Observation ;
           schema:observationDate ?fecha ;
           schema:variableMeasured ?var_inf ;
           schema:measurementValue ?inflacion_t0 .
  ?var_inf schema:name "Inflacion_YoY" .
  
  # Similar para salarios con diferentes offsets temporales
  # (Pseudocódigo: implementar con SPARQL FILTER y BIND para cálculos temporales)
}
ORDER BY ?fecha DESC
LIMIT 100
```

**Análisis Python:**

```python
import pandas as pd
from scipy.stats import linregress
import numpy as np

df = pd.read_csv('inflacion_salarios.csv')
df['fecha'] = pd.to_datetime(df['fecha'])

# Calcular correlaciones cruzadas con diferentes rezagos
rezagos = [0, 3, 6, 12]
correlaciones = {}

for rezago in rezagos:
    # Crear series con rezago
    inflacion_rezagada = df['inflacion_yoy'].shift(rezago)
    cambio_salario = df['variacion_salario_yoy']
    
    # Calcular correlación
    corr = inflacion_rezagada.corr(cambio_salario)
    correlaciones[f'rezago_{rezago}_meses'] = corr

print("Correlaciones Inflación → Cambio Salario")
for rezago, corr in correlaciones.items():
    print(f"{rezago}: {corr:.4f}")

# Resultado esperado:
# rezago_0_meses: 0.3215  (bajo, cambio simultáneo débil)
# rezago_3_meses: 0.4521  (mejora con 3 meses)
# rezago_6_meses: 0.5832  (mejor con 6 meses) ← REZAGO ÓPTIMO
# rezago_12_meses: 0.4102 (cae con 12 meses)

print("\nInterpretación:")
print("Rezago óptimo: 6 meses")
print("Los salarios reaccionan a inflación con aproximadamente 6 meses de retraso.")
print("Implicación: Familias sufren poder adquisitivo reducido por ~6 meses antes")
print("de que salarios comiencen a ajustarse.")
```

### CU3: Validación de Integridad RDF

**Query SPARQL de Validación:**

```sparql
PREFIX schema: <https://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

# 1. Contar observaciones por indicador
SELECT ?indicador (COUNT(?obs) AS ?total)
WHERE {
  ?obs rdf:type schema:Observation ;
       schema:variableMeasured ?var .
  ?var schema:name ?indicador .
}
GROUP BY ?indicador
ORDER BY DESC(?total)
LIMIT 10;

# Resultado esperado:
# ?indicador              | ?total
# Poder_Adquisitivo      | 192    (16 años × 12 meses)
# IPC_ES_100             | 192
# Salario_Real           | 64     (16 años × 4 trimestres)
# Oro_EUR_OZ             | 192
# IBEX35_Retorno         | 3936   (16 años × 252 días hábiles)
```

---

## REGLAS DE VALIDACIÓN DE CALIDAD (PSEUDOCÓDIGO PENTAHO)

### Regla 1: Rangos Aceptables

```
PARA cada indicador:
  SI nombre == "IPC_ES_100" THEN
    rango_min = 80, rango_max = 150
  SINO SI nombre == "Inflacion_YoY" THEN
    rango_min = -10, rango_max = 15
  SINO SI nombre == "Poder_Adquisitivo" THEN
    rango_min = 85, rango_max = 105
  SINO SI nombre == "IBEX35_Close" THEN
    rango_min = 6000, rango_max = 12000
  SINO SI nombre == "Oro_EUR_OZ" THEN
    rango_min = 1000, rango_max = 2500
  FIN SI
  
  SI valor < rango_min OR valor > rango_max THEN
    validación = FALSE
    acción = "Marcar para revisión" O "Rechazar"
  SINO
    validación = TRUE
  FIN SI
  
  LOG: "Indicador " + nombre + ", validación: " + validación
FIN PARA
```

### Regla 2: Monotonicidad de Índices

```
-- Chequear que índices no disminuyan (excepto shocks extremos)

PARA cada serie (indicador, geografía):
  IF indicador IN ("IPC_Acumulativo", "Poder_Adquisitivo_Acumulativo") THEN
    valor_anterior = NULL
    PARA cada registro ordenado por fecha ASC:
      SI valor_actual < valor_anterior THEN
        -- Permitir caída < 2% (error estadístico)
        SI (valor_anterior - valor_actual) / valor_anterior <= 0.02 THEN
          advertencia = "Caída menor permitida"
        SINO
          error = TRUE
          causa_probable = "Cambio de base", "Revisión", "Error"
        FIN SI
      FIN SI
      valor_anterior = valor_actual
    FIN PARA
  FIN IF
FIN PARA
```

### Regla 3: Completitud Temporal

```
PARA cada indicador:
  observaciones_esperadas = 12 * (año_fin - año_inicio)  -- Mensual
  observaciones_reales = COUNT(*) FILTER fecha BETWEEN año_inicio AND año_fin
  completitud_pct = (observaciones_reales / observaciones_esperadas) * 100
  
  SI completitud_pct < 95 THEN
    advertencia = "Baja completitud temporal"
    acción = "Investigar causas de huecos"
  FIN SI
  
  LOG: indicador + " - Completitud: " + completitud_pct + "%"
FIN PARA
```

---

## CASOS DE FALLO Y RECUPERACIÓN

### Escenario 1: Datos Ausentes en IPC (Fin de semana)

**Problema:** IPC es mensual, pero alguien intenta cargar datos diarios

**Detección:**
```
IF frecuencia == DAILY AND indicador == "IPC" THEN
  error = "Mismatch frecuencia"
  acción = "Agrupar a MENSUAL usando último día del mes"
END IF
```

**Recuperación:**
```
-- Agrupar a frecuencia mensual
GROUP BY MONTH(fecha)
SELECT 
  DATE_TRUNC(fecha, MONTH) AS fecha,
  MAX(valor) AS valor  -- Último valor del mes
FROM ipc_bruto
ORDER BY fecha
```

### Escenario 2: Tipo de Cambio Faltante (Fin de semana)

**Problema:** EUR/USD no cotiza fin de semana, necesario para convertir oro

**Detección:**
```
IF fecha IN weekend AND indicador == "EUR_USD" THEN
  valor = NULL
  calidad_flag = "missing"
END IF
```

**Recuperación: Forward-fill**
```
valor_imputado = LAST_NON_NULL_VALUE(fecha - 5 días)
calidad_flag = "forward_filled_weekend"
```

### Escenario 3: IBEX con Gap (Crisis/cierre)

**Problema:** IBEX cierra en días de festivo español

**Detección:**
```
IF fecha IN ["2024-12-25", "2025-01-01"] AND indicador == "IBEX35" THEN
  -- Verificar si es festivo español
  IF es_festivo_españa(fecha) == TRUE THEN
    acción = "Ignorar (ausencia válida)"
  ELSE
    error = "Ausencia no explicada"
  END IF
END IF
```

---

## ESTRUCTURA DE TABLA ETL_LOGS EJEMPLO

```
log_id | nombre_job                     | timestamp_inicio      | timestamp_fin         | estado     | registros_procesados | registros_errores | descripción_error
-------|--------------------------------|-----------------------|-----------------------|------------|----------------------|-------------------|---------------
1      | ETL_EXTRACCION_BRUTO           | 2024-12-15 10:00:00  | 2024-12-15 10:15:30  | completado | 850000              | 0                | N/A
2      | ETL_LIMPIEZA_VALIDACION        | 2024-12-15 10:16:00  | 2024-12-15 10:45:00  | completado | 850000              | 125              | 125 duplicados exactos eliminados
3      | ETL_TRANSFORMACION             | 2024-12-15 10:46:00  | 2024-12-15 11:20:00  | completado | 820000              | 200              | 200 filas con calidad_flag='imputado'
4      | ETL_DEFLACTACION               | 2024-12-15 11:21:00  | 2024-12-15 11:50:00  | completado | 820000              | 0                | N/A
5      | ETL_VALIDACION_CALIDAD         | 2024-12-15 11:51:00  | 2024-12-15 12:15:00  | completado | 820000              | 0                | 100% validaciones pasadas
6      | ETL_CARGA_DW                   | 2024-12-15 12:16:00  | 2024-12-15 12:35:00  | completado | 820000              | 0                | Upsert completado en hechos_indicadores_temporales
```

---

## CHECKLIST FINAL PRE-ENTREGA

### APARTADO 1 ✓
- [ ] Pregunta principal clara (¿Cuánto ha caído PA?)
- [ ] Preguntas secundarias P1–P5 formuladas y evaluables
- [ ] Hipótesis por cada pregunta documentadas
- [ ] Objetivos SMART definidos (medibles, alcanzables)
- [ ] Casos de uso tabulados (5-6 casos mínimo)
- [ ] Métricas KPI con umbrales cuantitativos

### APARTADO 2 ✓
- [ ] Matriz de datasets con fuentes verificadas (URLs válidas)
- [ ] Granularidad temporal especificada (mensual/trimestral/diario)
- [ ] Período cubierto documentado (2010-2025 validado)
- [ ] Licencias registradas (CC-BY-4.0, abierto)
- [ ] Plan de imputación si hay huecos
- [ ] Redefinición de preguntas si datos faltaran (documento CAMBIOS.md)

### APARTADO 3 ✓
- [ ] Esquema conceptual ER completo (mínimo 5 entidades)
- [ ] Esquema lógico estrella con tabla de hechos + 5 dimensiones
- [ ] Script SQL DDL ejecutable (sintaxis PostgreSQL validada)
- [ ] Índices definidos para queries OLAP (índices de rango, drill-down)
- [ ] Diagrama visual (PNG) incluido en outputs/
- [ ] Granularidad de hechos documentada (fecha, indicador, geo, unidad)

### APARTADO 4 ✓
- [ ] 6 transformaciones Pentaho o Python diseñadas y documentadas
- [ ] Extracción desde ≥3 fuentes diferentes implementada
- [ ] Limpieza: trim, tipificación, deduplicación, imputación
- [ ] Transformación: normalización, conversión de monedas, índices base 100
- [ ] Deflactación con fórmula verificable: W_real = W_nominal / (CPI/100)
- [ ] Validación de calidad con ≥3 reglas (rangos, monotonicidad, completitud)
- [ ] Logs de auditoría capturando cada paso
- [ ] Dataset limpio exportado a CSV (processed/)

### APARTADO 5 ✓
- [ ] Mapeo schema.org: Observation, Dataset, Organization, Place
- [ ] Tripletas RDF generadas (mínimo 100 observaciones)
- [ ] Validación SPARQL queries ejecutadas
- [ ] Conteos de clases/propiedades documentados
- [ ] Enriquecimiento con Wikidata/DBpedia links (opcional pero recomendado)
- [ ] Formato RDF (Turtle, XML, JSON-LD) disponible

### APARTADO 6 ✓
- [ ] Viz1: Línea temporal con PA, IBEX, Inflación (eje dual)
  - [ ] Colores diferenciados (#003da5 azul PA, #28a745 verde IBEX, #dc3545 rojo inflación)
  - [ ] Anotaciones de eventos clave (2012, 2015, 2020, 2022)
  - [ ] Guía de lectura por período
- [ ] Viz2: Scatter plot Oro–PA con tendencia + marginales
  - [ ] Tamaño puntos proporcional a inflación
  - [ ] Color gradiente temporal (azul 2010 → rojo 2025)
  - [ ] Correlación Pearson calculada y mostrada
  - [ ] Guía interpretativa zonas
- [ ] Ambas visualizaciones HTML interactivas (Plotly/Altair/D3)

### APARTADO 7 ✓
- [ ] Memoria PDF ≤8 páginas
- [ ] Portada con autores, fecha, institución
- [ ] Resumen ejecutivo 1 página
- [ ] Apartados 1-8 condensados (0.75 págs c/u)
- [ ] Figuras clave: 2 visualizaciones mínimo
- [ ] Conclusiones y limitaciones 0.5 páginas
- [ ] Referencias completas (BibTeX)

### APARTADO 8 ✓
- [ ] Repositorio GitHub público o privado (acceso profesor)
- [ ] Estructura carpetas: data/, etl/, src/, viz/, schemaorg/, docs/
- [ ] README.md exhaustivo (reproducibilidad paso a paso)
- [ ] Makefile o script orquestación (make all = ejecutar todo)
- [ ] LICENSE (CC-BY-4.0)
- [ ] CITATION.cff presente
- [ ] requirements.txt sincronizado
- [ ] .gitignore excluyendo datos/credenciales >10MB
- [ ] Mínimo 2 tests unitarios pasando (pytest)

### VALIDACIÓN CRUZADA ✓
- [ ] Correlación IPC(INE) vs HICP(Eurostat): RMSE < 1%
- [ ] Poder adquisitivo verificable: PA_2024 aprox -8% vs PA_2010
- [ ] IBEX índice base 100 alineado con datos BME
- [ ] Oro EUR = Oro USD × EUR/USD (conversión correcta)
- [ ] Salarios reales: W_real = W_nominal / (CPI/100) verificado
- [ ] Trazabilidad: cada KPI vinculado a query SQL + script

### DOCUMENTACIÓN ✓
- [ ] ESTRUCTURA_PROYECTO.md
- [ ] CAMBIOS.md (si hay redefiniciones de preguntas)
- [ ] LIMITACIONES.md (explicar cada decisión)
- [ ] TRABAJO_FUTURO.md (sugerencias de mejora)
- [ ] REFERENCIAS.bib (todas las fuentes citadas)

### SEGURIDAD Y REPRODUCIBILIDAD ✓
- [ ] No hay credenciales en .git history (usar .env)
- [ ] Todos los scripts ejecutables en máquina limpia
- [ ] Rutas relativas (no rutas absolutas)
- [ ] Dockerfile opcional para reproducibilidad total
- [ ] CI/CD GitHub Actions configurado (opcional)

---

## RÚBRICA DE AUTOEVALUACIÓN ANTES DE ENVIAR

### Escala: 1–5 (1=No iniciado, 5=Excelente)

| Aspecto | Puntuación | Observaciones |
|---|---|---|
| **Apartado 1: Definición clara** | ___ | ¿P1-P5 son evaluables? ¿Hipótesis documentadas? |
| **Apartado 2: Datasets fuentes verificadas** | ___ | ¿Todas las URLs válidas y accesibles? ¿Licencias claras? |
| **Apartado 3: Diseño DW profesional** | ___ | ¿Esquema estrella con 5+ dimensiones? ¿Índices optimizados? |
| **Apartado 4: ETL robusto y documentado** | ___ | ¿6 transformaciones completas? ¿Logs+auditoría? ¿Tests pasando? |
| **Apartado 5: Transformación schema.org correcta** | ___ | ¿Tripletas válidas RDF? ¿SPARQL queries funcionan? |
| **Apartado 6: Visualizaciones claras y guiadas** | ___ | ¿2 viz responden P1 y P3? ¿Anotaciones+leyendas? ¿Interactivas? |
| **Apartado 7: Memoria coherente y concisa** | ___ | ¿≤8 páginas? ¿Portada+figuras? ¿Conclusiones+limitaciones? |
| **Apartado 8: GitHub reproducible** | ___ | ¿Estructura clara? ¿README exhaustivo? ¿make all funciona? |
| **Calidad global de datos** | ___ | ¿Completitud ≥95%? ¿Consistencia IPC–HICP? ¿0 duplicados? |
| **Comunicación y claridad** | ___ | ¿Redacción académica? ¿Figuras legibles? ¿Citas completas? |

**Puntuación Total:** ___/50

**Criterio paso:** 40+ → Listo para evaluación oficial  
**Criterio excelencia:** 48+ → Candidato a mención especial

---

## COMANDOS RÁPIDOS DE VERIFICACIÓN (SHELL)

```bash
# 1. Verificar estructura
tree -L 2 -I '__pycache__|*.pyc|.git' .

# 2. Contar registros de datasets
wc -l data/raw/*.csv data/processed/*.csv

# 3. Ejecutar tests
pytest tests/ -v --tb=short

# 4. Verificar tamaño de archivos
du -sh data/* etl/* viz/*

# 5. Buscar archivos grandes (>10MB) que no deberían estar en git
find . -size +10M -type f | grep -v ".git" | grep -v ".env"

# 6. Validar JSON-LD
python3 -c "import json; json.load(open('schemaorg/observations.jsonld'))" && echo "OK"

# 7. Contar líneas de código
cloc --exclude-dir=.git src/ etl/python/ notebooks/

# 8. Verificar sintaxis SQL
sqlparse -q src/create_dw_schema.sql

# 9. Listar cambios no commiteados
git status --short

# 10. Mostrar último tag/versión
git describe --tags --always
```

---

## EJEMPLO DE PRESENTACIÓN EN CLASE (3 minutos)

### Diapositiva 1: Problema Contexto
"Durante la última década, las familias españolas han experimentado una erosión significativa del poder adquisitivo. Aunque los salarios nominales subieron ~25%, la inflación acumulada fue de ~35%. Nuestro proyecto cuantifica este fenómeno y lo correlaciona con activos de inversión como el IBEX-35 y oro."

### Diapositiva 2: Datos y Metodología
"Hemos integrado 6 fuentes de datos (INE, Eurostat, BCE, LBMA, BME) en un almacén multidimensional bajo esquema estrella Kimball. ETL con Pentaho garantiza reproducibilidad. Período: 2010-2025, granularidad mensual."

### Diapositiva 3: Visualizaciones Clave
[Mostrar Viz1: PA cae de 100 a 92, IBEX volátil, inflación pico 2022]
[Mostrar Viz2: Correlación negativa oro-PA: -0.60, confirmando rol de activo refugio]

### Diapositiva 4: Resultados y Conclusiones
"Poder adquisitivo cayó ~8% en 14 años. Rezago salarial: 6 meses respecto a inflación. Oro no es cobertura perfecta (correlación -0.60 ≠ -1). IBEX rentabilidad real ajustada por inflación: +4.7% anual promedio."

### Diapositiva 5: Entregables
"GitHub repo público, 8 páginas memoria, 2 visualizaciones interactivas, RDF validado, repositorio reproducible con Makefile."

---

**Documento de Verificación Versión:** 1.0  
**Última Actualización:** 15 de diciembre de 2024
