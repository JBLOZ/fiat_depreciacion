# Resumen de Implementación SQL - Data Warehouse

## ✅ Completado: Apartado 3 del Proyecto

### 📊 Estructura Implementada

```
sql/
├── 00_crear_dw_completo.sql         ⭐ Script maestro (183 líneas)
├── 01_crear_secuencias.sql          📋 Secuencias (77 líneas)
├── 02_crear_dimensiones.sql         🗂️  5 Dimensiones (184 líneas)
├── 03_crear_tabla_hechos.sql        📈 Tabla central (149 líneas)
├── 04_crear_tablas_auditoria.sql    🔍 Auditoría (229 líneas)
├── 05_poblar_dimensiones.sql        💾 Datos maestros (362 líneas)
├── 06_crear_vistas_analiticas.sql   📊 9 Vistas + 2 Funciones (334 líneas)
├── 99_tests_validacion.sql          ✅ Suite de tests (340 líneas)
├── ejecutar_dw.sh                   🚀 Script ejecución (ejecutable)
└── README.md                        📖 Documentación completa
```

**Total: 1,858 líneas de SQL + 590 líneas de documentación = 2,448 líneas**

---

## 🌟 Esquema Estrella Implementado

```
                      ┌───────────────────┐
                      │   DIM_TIEMPO      │
                      │  5,840 registros  │
                      │  2010-01-01 a     │
                      │  2025-12-31       │
                      └─────────┬─────────┘
                                │
          ┌─────────────────────┼─────────────────────┐
          │                     │                     │
    ┌─────▼──────┐      ┌───────▼────────┐    ┌──────▼──────┐
    │DIM_INDICAD │      │ DIM_GEOGRAFIA  │    │ DIM_UNIDAD  │
    │            │      │                │    │             │
    │ 17 indic.  │      │  ES + 17 CCAA  │    │ 12 unidades │
    │ · IPC      │      │  + Zona Euro   │    │ · EUR, USD  │
    │ · Salarios │      │  + Global      │    │ · Índices   │
    │ · Oro      │      │                │    │ · %         │
    │ · IBEX-35  │      │  20 registros  │    │             │
    │ · EUR/USD  │      │                │    │             │
    └─────┬──────┘      └───────┬────────┘    └──────┬──────┘
          │                     │                     │
          └─────────────────────┼─────────────────────┘
                                │
                  ┌─────────────▼──────────────┐
                  │     HECHOS_INDICADORES     │
                  │       _TEMPORALES          │
                  │                            │
                  │ Clave: (tiempo, indicador, │
                  │  geo, unidad, fuente)      │
                  │                            │
                  │ Métricas:                  │
                  │  · valor                   │
                  │  · valor_anterior          │
                  │  · variacion_absoluta      │
                  │  · variacion_pct           │
                  │  · calidad_dato            │
                  │  · probabilidad_imputacion │
                  │                            │
                  │ 9 índices optimizados      │
                  └─────────────┬──────────────┘
                                │
                         ┌──────▼───────┐
                         │ DIM_FUENTE   │
                         │              │
                         │ 10 fuentes   │
                         │ · INE        │
                         │ · Eurostat   │
                         │ · BCE        │
                         │ · LBMA       │
                         │ · BME        │
                         └──────────────┘
```

---

## 📋 Dimensiones Pobladas

### 1️⃣ dim_tiempo (5,840+ registros)
- ✅ Período completo: 2010-01-01 hasta 2025-12-31
- ✅ Granularidad: Diaria
- ✅ Atributos: año, mes, trimestre, semana, día_semana
- ✅ Festivos nacionales marcados
- ✅ Campos calculados: año_mes, año_trimestre

### 2️⃣ dim_indicador (17 indicadores)

**Inflación (3)**
- IPC_ES_100 - IPC España Base 100
- IPC_ES_YOY - Inflación Interanual
- HICP_ES - HICP Eurostat

**Salarios (3)**
- SALARIO_NOM - Salario Nominal Medio
- SALARIO_REAL - Salario Real Deflactado
- SALARIO_REAL_IDX - Índice Base 100

**Poder Adquisitivo (1)**
- PODER_ADQ - Poder Adquisitivo Índice

**Activos Financieros (6)**
- ORO_USD - Precio Oro USD
- ORO_EUR - Precio Oro EUR
- ORO_EUR_IDX - Oro EUR Base 100
- IBEX35_CIERRE - IBEX-35 Cierre
- IBEX35_RET_LOG - Retorno Logarítmico
- IBEX35_RET_REAL - Rentabilidad Real

**Tipo de Cambio (2)**
- EUR_USD - Tipo de Cambio
- EUR_USD_VAR - Variación %

**Empleo (2)**
- TASA_PARO - Tasa de Desempleo
- EMPLEO_TOTAL - Empleo Total

### 3️⃣ dim_geografia (20 registros)
- ✅ España (país, nivel 0)
- ✅ 17 Comunidades Autónomas (región, nivel 1)
- ✅ Zona Euro (zona_economica)
- ✅ Global (para indicadores mundiales)
- ✅ Jerarquía: País → Región con geo_padre_key

### 4️⃣ dim_unidad (12 unidades)
**Monedas:** EUR, USD, USD/oz, EUR/oz
**Índices:** Índice, Índice_100
**Porcentajes:** %, pp (puntos porcentuales)
**Otros:** Rate, Miles, Millones, Unidades

### 5️⃣ dim_fuente (10 fuentes)
- INE (Instituto Nacional de Estadística)
- Eurostat (Oficina Estadística UE)
- BCE (Banco Central Europeo)
- LBMA (London Bullion Market Association)
- BME (Bolsas y Mercados Españoles)
- Yahoo Finance
- OANDA (Currency Data)
- Kitco Metals
- Banco de España
- OCDE

---

## 🔍 Tablas de Auditoría (5 tablas)

### 1. etl_logs
- Registro de todas las ejecuciones ETL
- Estado: iniciado, completado, error, advertencia
- Métricas: registros procesados, insertados, actualizados, errores
- Duración calculada automáticamente

### 2. validacion_calidad
- Resultados de validaciones de datos
- Tipos: rango, monotonicidad, unicidad, consistencia_fuentes, outliers
- Severidad: info, warning, error, critico
- Registro de acciones tomadas

### 3. trazabilidad_transformacion
- Linaje completo de datos
- Entrada → Transformación → Salida
- Fórmulas aplicadas y parámetros (JSON)
- Vinculado a etl_logs

### 4. datos_rechazados
- Registros que fallaron validación
- Datos originales en JSON
- Motivo de rechazo detallado
- Estado de reprocesamiento

### 5. metadata_dw
- Metadatos generales del DW
- Versión, configuración, autor
- Período de análisis, año base
- Actualizable

---

## 📊 Vistas Analíticas (9 vistas)

### Vistas de Análisis Principal

1. **v_poder_adquisitivo_mensual**
   - Evolución mensual del poder adquisitivo
   - Salario real e IPC
   - Para responder P1

2. **v_inflacion_ibex_correlacion**
   - Análisis trimestral
   - Correlación inflación vs IBEX-35
   - Para responder P2 y P4

3. **v_oro_poder_adquisitivo**
   - Evolución mensual oro EUR vs PA
   - Incluye inflación
   - Para responder P3

### Vistas de Calidad y Validación

4. **v_comparacion_fuentes**
   - Comparación entre fuentes
   - Validación cruzada

5. **v_calidad_por_indicador**
   - Resumen de calidad por indicador
   - % datos reales, imputados, etc.

### Vistas de Series Temporales

6. **v_serie_temporal_indicadores**
   - Serie temporal completa
   - Todos los indicadores con dimensiones

7. **v_variaciones_interanuales**
   - Cálculo automático de variaciones YoY
   - Para todos los indicadores

### Vistas Ejecutivas

8. **v_dashboard_ejecutivo**
   - KPIs principales del último mes
   - Vista rápida de estado actual

9. **v_resumen_calidad_dw**
   - Estado general del DW
   - Métricas de calidad consolidadas

---

## ⚙️ Funciones SQL (2 funciones)

### 1. fn_obtener_valor_indicador
```sql
SELECT fn_obtener_valor_indicador(
    'IPC_ES_100',     -- Código indicador
    '2024-01-01',     -- Fecha
    'ES'              -- Geografía
);
```
Retorna el valor de un indicador en fecha específica.

### 2. fn_calcular_correlacion
```sql
SELECT fn_calcular_correlacion(
    'IPC_ES_YOY',          -- Indicador 1
    'SALARIO_REAL',        -- Indicador 2
    '2010-01-01',          -- Fecha inicio
    '2024-12-31'           -- Fecha fin
);
```
Calcula correlación de Pearson entre dos indicadores.

---

## ✅ Suite de Validación (13 tests)

1. ✓ Verificar existencia de todas las tablas
2. ✓ Verificar poblado de dimensiones
3. ✓ Verificar integridad referencial (5 FKs)
4. ✓ Verificar índices (9+ índices)
5. ✓ Verificar rangos de fechas (2010-2025)
6. ✓ Verificar vistas analíticas (9 vistas)
7. ✓ Verificar funciones (2 funciones)
8. ✓ Verificar categorías de indicadores
9. ✓ Verificar jerarquía geográfica
10. ✓ Verificar metadatos del DW
11. ✓ Prueba de inserción de datos
12. ✓ Probar vista de resumen de calidad
13. ✓ Probar funciones SQL

**Resultado esperado: 13/13 tests PASADOS ✅**

---

## 🚀 Cómo Ejecutar

### Opción 1: Script Maestro (Todo de una vez)
```bash
cd sql/
./ejecutar_dw.sh
```

### Opción 2: PostgreSQL Directamente
```bash
# Crear base de datos
createdb fiat_depreciacion_dw

# Ejecutar creación completa
psql fiat_depreciacion_dw -f 00_crear_dw_completo.sql

# Ejecutar tests
psql fiat_depreciacion_dw -f 99_tests_validacion.sql
```

### Opción 3: Docker (Sin instalación local)
```bash
# Iniciar contenedor PostgreSQL
docker run --name fiat-postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=fiat_depreciacion_dw \
  -p 5432:5432 -d postgres:14

# Ejecutar scripts
docker exec -i fiat-postgres \
  psql -U postgres -d fiat_depreciacion_dw \
  < 00_crear_dw_completo.sql

# Ejecutar tests
docker exec -i fiat-postgres \
  psql -U postgres -d fiat_depreciacion_dw \
  < 99_tests_validacion.sql
```

---

## 📈 Consultas de Ejemplo Incluidas

### Poder Adquisitivo Último Año
```sql
SELECT 
    t.año_mes,
    h.valor as poder_adquisitivo_idx,
    h.variacion_pct
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
WHERE i.codigo = 'PODER_ADQ' AND t.año = 2024
ORDER BY t.fecha;
```

### Correlación Inflación-Salarios
```sql
SELECT fn_calcular_correlacion(
    'IPC_ES_YOY', 
    'SALARIO_REAL',
    '2010-01-01',
    '2024-12-31'
) as correlacion;
```

### Dashboard Ejecutivo
```sql
SELECT * FROM v_dashboard_ejecutivo;
```

---

## 📝 Cumplimiento del Proyecto

### ✅ Requisitos Cumplidos del Apartado 3

- [x] **3.1** Diseño Conceptual - Identificación de hechos y dimensiones
- [x] **3.2** Matriz Dimensional Multidimensional
- [x] **3.3** Modelo Conceptual ER completo
- [x] **3.4** Diseño Lógico - Esquema Estrella
- [x] **3.5** Diseño Físico - Schema SQL Completo
- [x] **3.6** Índices para Rendimiento OLAP (9 índices)
- [x] **3.7** Diagrama ERD (en documentación)
- [x] **3.8** Vistas Analíticas Estándar (9 vistas)
- [x] **3.9** Script de Creación Completo ✨

### Adicional Implementado

- [x] Tablas de auditoría y trazabilidad (5 tablas)
- [x] Funciones SQL personalizadas (2 funciones)
- [x] Suite completa de tests (13 tests)
- [x] Script de ejecución interactivo
- [x] Documentación exhaustiva (README.md)
- [x] Metadatos del DW (versión, autor, período)
- [x] Validación de calidad automatizada
- [x] Linaje de datos (trazabilidad completa)

---

## 📊 Estadísticas del Código

```
Archivo                          Líneas  Descripción
─────────────────────────────────────────────────────────────
00_crear_dw_completo.sql           183  Script maestro
01_crear_secuencias.sql             77  5 secuencias
02_crear_dimensiones.sql           184  5 dimensiones
03_crear_tabla_hechos.sql          149  Tabla central + 9 índices
04_crear_tablas_auditoria.sql      229  5 tablas auditoría
05_poblar_dimensiones.sql          362  Datos maestros
06_crear_vistas_analiticas.sql     334  9 vistas + 2 funciones
99_tests_validacion.sql            340  13 tests validación
ejecutar_dw.sh                     247  Script interactivo
README.md                          590  Documentación completa
─────────────────────────────────────────────────────────────
TOTAL                            2,695  líneas

Distribución:
  SQL puro:           1,858 líneas (69%)
  Tests:               340 líneas (13%)
  Script shell:        247 líneas (9%)
  Documentación:       590 líneas (22%)
```

---

## 🎯 Próximos Pasos

1. ✅ **Apartado 3 completado** - Data Warehouse SQL
2. ⏳ **Apartado 4** - Pipeline ETL con Pentaho
3. ⏳ **Apartado 5** - Transformación a Schema.org
4. ⏳ **Apartado 6** - Visualizaciones
5. ⏳ **Apartado 7** - Memoria ejecutiva
6. ⏳ **Apartado 8** - Repositorio GitHub

---

## 🌟 Características Destacadas

### Diseño Robusto
- ✅ Metodología Kimball (esquema estrella)
- ✅ Normalización adecuada
- ✅ Claves sustitutas (surrogate keys)
- ✅ Granularidad diaria

### Optimización
- ✅ 9 índices estratégicos para OLAP
- ✅ Índices compuestos para drill-down
- ✅ Índices de cobertura (INCLUDE)
- ✅ Estadísticas actualizadas

### Calidad
- ✅ Calidad de datos rastreada (real/imputado/interpolado)
- ✅ Probabilidad de imputación
- ✅ Validaciones automatizadas
- ✅ Suite de 13 tests

### Auditoría
- ✅ Trazabilidad completa (linaje)
- ✅ Logs de ETL detallados
- ✅ Registro de validaciones
- ✅ Datos rechazados con motivo

### Análisis
- ✅ 9 vistas predefinidas
- ✅ 2 funciones SQL personalizadas
- ✅ Dashboard ejecutivo
- ✅ Correlaciones automáticas

### Documentación
- ✅ README.md exhaustivo
- ✅ Comentarios en cada tabla/columna
- ✅ Script de demostración
- ✅ Ejemplos de uso

---

## 📞 Soporte

Para más información:
- **README.md** en directorio `sql/`
- **PROYECTO.md** para especificaciones completas
- **docs/estructura_final.md** para estructura esperada

---

**Creado por:** Jordi Blasco Lozano  
**Fecha:** 31 de octubre de 2025  
**Universidad:** Universidad de Alicante - EPS  
**Asignatura:** Adquisición y Preparación de Datos  
**Proyecto:** Depreciación del Euro y Erosión del Poder Adquisitivo en España
