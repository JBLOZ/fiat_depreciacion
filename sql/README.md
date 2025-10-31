# Data Warehouse SQL - Depreciación del Euro

Este directorio contiene todos los scripts SQL para crear y gestionar el Data Warehouse del proyecto de análisis de depreciación del euro y erosión del poder adquisitivo en España.

## 📋 Estructura del Proyecto SQL

### Scripts Principales (Orden de Ejecución)

1. **00_crear_dw_completo.sql** - Script maestro que ejecuta todos los demás
2. **01_crear_secuencias.sql** - Secuencias para claves sustitutas
3. **02_crear_dimensiones.sql** - Tablas de dimensión (5 dimensiones)
4. **03_crear_tabla_hechos.sql** - Tabla central de hechos
5. **04_crear_tablas_auditoria.sql** - Tablas de auditoría y trazabilidad
6. **05_poblar_dimensiones.sql** - Datos maestros iniciales
7. **06_crear_vistas_analiticas.sql** - Vistas OLAP y funciones
8. **99_tests_validacion.sql** - Suite de pruebas de validación

## 🗄️ Diseño del Data Warehouse

### Esquema Estrella (Kimball)

```
                    ┌─────────────┐
                    │  DIM_TIEMPO │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────▼─────┐      ┌─────▼──────┐    ┌─────▼─────┐
   │DIM_INDIC │      │DIM_GEOGRAFIA│    │DIM_UNIDAD │
   └────┬─────┘      └─────┬──────┘    └─────┬─────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                  ┌────────▼─────────┐
                  │HECHOS_INDICADORES│
                  │   _TEMPORALES    │
                  └────────┬─────────┘
                           │
                      ┌────▼─────┐
                      │DIM_FUENTE│
                      └──────────┘
```

### Dimensiones

1. **dim_tiempo** - Dimensión temporal (2010-2025)
   - Granularidad: Diaria
   - ~5,840 registros
   - Atributos: fecha, año, mes, trimestre, semana, día_semana, festivos

2. **dim_indicador** - Indicadores macroeconómicos
   - IPC/HICP (inflación)
   - Salarios (nominal, real, índice)
   - Poder adquisitivo
   - Oro (USD, EUR, índice)
   - IBEX-35 (cierre, retornos)
   - EUR/USD (tipo de cambio)
   - Empleo

3. **dim_geografia** - Jerarquía geográfica
   - España (país)
   - 17 Comunidades Autónomas
   - Zona Euro
   - Global

4. **dim_unidad** - Unidades de medida
   - Monedas: EUR, USD, EUR/oz, USD/oz
   - Índices: base 100, sin unidad
   - Porcentajes: %, puntos porcentuales
   - Cantidades: miles, millones

5. **dim_fuente** - Fuentes de datos
   - INE, Eurostat, BCE
   - LBMA, BME, Yahoo Finance
   - OANDA, Kitco, Banco de España, OCDE

### Tabla de Hechos

**hechos_indicadores_temporales**
- Clave primaria compuesta: (tiempo_key, indicador_key, geo_key, unit_key, fuente_key)
- Métricas: valor, valor_anterior, variación_absoluta, variación_pct
- Calidad: calidad_dato (real/interpolado/imputado/estimado)
- Auditoría: ts_actualizacion, ts_carga, usuario_carga

### Tablas de Auditoría

- **etl_logs** - Registro de ejecuciones ETL
- **validacion_calidad** - Resultados de validaciones
- **trazabilidad_transformacion** - Linaje de datos
- **datos_rechazados** - Registros rechazados
- **metadata_dw** - Metadatos del DW

## 🚀 Instalación y Ejecución

### Requisitos Previos

- PostgreSQL 12 o superior
- Cliente psql o cualquier herramienta de administración PostgreSQL
- Permisos de creación de base de datos

### Opción 1: Ejecución Completa (Recomendado)

```bash
# 1. Crear base de datos
createdb fiat_depreciacion_dw

# 2. Ejecutar script maestro
psql fiat_depreciacion_dw -f 00_crear_dw_completo.sql

# 3. Ejecutar tests de validación
psql fiat_depreciacion_dw -f 99_tests_validacion.sql
```

### Opción 2: Ejecución Paso a Paso

```bash
# Conectar a la base de datos
psql fiat_depreciacion_dw

# Dentro de psql:
\i 01_crear_secuencias.sql
\i 02_crear_dimensiones.sql
\i 03_crear_tabla_hechos.sql
\i 04_crear_tablas_auditoria.sql
\i 05_poblar_dimensiones.sql
\i 06_crear_vistas_analiticas.sql
```

### Opción 3: Con Docker

```bash
# Iniciar contenedor PostgreSQL
docker run --name fiat-postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=fiat_depreciacion_dw \
  -p 5432:5432 \
  -d postgres:14

# Ejecutar scripts
docker exec -i fiat-postgres psql -U postgres -d fiat_depreciacion_dw < 00_crear_dw_completo.sql
```

## 📊 Vistas Analíticas Disponibles

### Vistas Predefinidas

1. **v_poder_adquisitivo_mensual** - Evolución mensual del poder adquisitivo
2. **v_inflacion_ibex_correlacion** - Correlación inflación vs IBEX-35
3. **v_oro_poder_adquisitivo** - Oro EUR vs poder adquisitivo
4. **v_comparacion_fuentes** - Comparación entre fuentes de datos
5. **v_calidad_por_indicador** - Resumen de calidad por indicador
6. **v_serie_temporal_indicadores** - Series temporales completas
7. **v_variaciones_interanuales** - Cálculo de variaciones YoY
8. **v_dashboard_ejecutivo** - KPIs principales
9. **v_resumen_calidad_dw** - Estado general del DW

### Funciones Disponibles

```sql
-- Obtener valor de un indicador
SELECT fn_obtener_valor_indicador('IPC_ES_100', '2024-01-01', 'ES');

-- Calcular correlación entre indicadores
SELECT fn_calcular_correlacion('IPC_ES_YOY', 'SALARIO_REAL', '2010-01-01', '2024-12-31');
```

## 🔍 Consultas de Ejemplo

### Ejemplo 1: Poder Adquisitivo Último Año

```sql
SELECT 
    t.año_mes,
    h.valor as poder_adquisitivo_idx,
    h.variacion_pct
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_geografia g ON h.geo_key = g.geo_key
WHERE i.codigo = 'PODER_ADQ'
    AND g.codigo = 'ES'
    AND t.año = 2024
ORDER BY t.fecha;
```

### Ejemplo 2: Comparar Inflación INE vs Eurostat

```sql
SELECT 
    t.año_mes,
    f.institucion as fuente,
    AVG(h.valor) as inflacion_promedio
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_fuente f ON h.fuente_key = f.fuente_key
WHERE i.categoria = 'inflacion'
    AND t.año >= 2020
GROUP BY t.año_mes, f.institucion
ORDER BY t.año_mes, f.institucion;
```

### Ejemplo 3: Top 5 Meses con Mayor Pérdida de Poder Adquisitivo

```sql
SELECT 
    t.fecha,
    t.año_mes,
    h.valor as poder_adquisitivo,
    h.variacion_pct,
    CASE 
        WHEN h.variacion_pct < -2 THEN 'Pérdida Severa'
        WHEN h.variacion_pct < 0 THEN 'Pérdida Moderada'
        ELSE 'Ganancia'
    END as categoria
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
WHERE i.codigo = 'PODER_ADQ'
ORDER BY h.variacion_pct ASC
LIMIT 5;
```

## ✅ Validación y Pruebas

### Ejecutar Suite Completa de Tests

```bash
psql fiat_depreciacion_dw -f 99_tests_validacion.sql
```

### Tests Incluidos

- ✓ Existencia de todas las tablas
- ✓ Poblado correcto de dimensiones
- ✓ Integridad referencial
- ✓ Índices creados
- ✓ Rangos de fechas correctos
- ✓ Vistas analíticas funcionales
- ✓ Funciones operativas
- ✓ Categorías de indicadores
- ✓ Jerarquía geográfica
- ✓ Metadatos del DW
- ✓ Inserción de datos de prueba
- ✓ Vistas de resumen

### Verificación Rápida

```sql
-- Ver resumen del DW
SELECT * FROM v_resumen_calidad_dw;

-- Contar registros por dimensión
SELECT 
    'dim_tiempo' as dimension, COUNT(*) as registros FROM dim_tiempo
UNION ALL
SELECT 'dim_indicador', COUNT(*) FROM dim_indicador
UNION ALL
SELECT 'dim_geografia', COUNT(*) FROM dim_geografia
UNION ALL
SELECT 'dim_unidad', COUNT(*) FROM dim_unidad
UNION ALL
SELECT 'dim_fuente', COUNT(*) FROM dim_fuente;
```

## 📈 Métricas de Calidad Esperadas

| Métrica | Umbral Esperado | Comando de Verificación |
|---------|-----------------|-------------------------|
| Cobertura temporal | ≥ 95% (5,549 de 5,840 días) | `SELECT COUNT(*) FROM dim_tiempo;` |
| Registros en hechos | Depende de ETL | `SELECT COUNT(*) FROM hechos_indicadores_temporales;` |
| Datos reales | ≥ 95% | `SELECT pct_datos_reales FROM v_resumen_calidad_dw;` |
| Integridad referencial | 100% | `SELECT * FROM 99_tests_validacion.sql;` |

## 🔧 Mantenimiento

### Actualizar Estadísticas

```sql
ANALYZE hechos_indicadores_temporales;
ANALYZE dim_tiempo;
ANALYZE dim_indicador;
```

### Ver Tamaño de Tablas

```sql
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Limpiar y Recrear

```sql
-- CUIDADO: Esto eliminará todos los datos
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
-- Luego ejecutar 00_crear_dw_completo.sql
```

## 📚 Documentación Adicional

- **PROYECTO.md** - Especificación completa del proyecto
- **docs/estructura_final.md** - Estructura detallada esperada
- **docs/enunciado.md** - Enunciado original del proyecto

## 👤 Autor

**Jordi Blasco Lozano**
- Universidad de Alicante - Escuela Politécnica Superior
- Grado en Ingeniería en Inteligencia Artificial
- Asignatura: Adquisición y Preparación de Datos
- Fecha: 31 de octubre de 2025

## 📝 Licencia

Este proyecto es parte de una práctica académica.
Los datos utilizados provienen de fuentes públicas (INE, Eurostat, BCE, etc.) con sus respectivas licencias.
