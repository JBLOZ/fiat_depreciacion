-- ============================================================================
-- Script 06: Vistas Analíticas y Cubos OLAP
-- ============================================================================
-- Vistas predefinidas para consultas frecuentes y análisis OLAP
-- ============================================================================

-- ============================================================================
-- VISTA 1: Poder Adquisitivo Mensual
-- ============================================================================
-- Vista que muestra la evolución del poder adquisitivo agregado mensual

CREATE OR REPLACE VIEW v_poder_adquisitivo_mensual AS
SELECT
    t.año,
    t.mes,
    t.año_mes,
    t.fecha,
    i.nombre as indicador,
    g.nombre as geografia,
    h.valor,
    h.variacion_pct,
    h.calidad_dato,
    f.institucion as fuente
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_geografia g ON h.geo_key = g.geo_key
JOIN dim_fuente f ON h.fuente_key = f.fuente_key
WHERE i.codigo IN ('SALARIO_REAL_IDX', 'IPC_ES_100', 'PODER_ADQ')
    AND g.codigo = 'ES'
ORDER BY t.fecha DESC, i.codigo;

COMMENT ON VIEW v_poder_adquisitivo_mensual IS 
    'Evolución mensual del poder adquisitivo en España con salario real e IPC';

-- ============================================================================
-- VISTA 2: Correlación Inflación vs Rentabilidad IBEX
-- ============================================================================

CREATE OR REPLACE VIEW v_inflacion_ibex_correlacion AS
SELECT
    t.año,
    t.trimestre,
    t.año_trimestre,
    AVG(CASE WHEN i.codigo = 'IPC_ES_YOY' THEN h.valor END) as inflacion_media,
    AVG(CASE WHEN i.codigo = 'IBEX35_RET_REAL' THEN h.valor END) as rentabilidad_ibex_real_media,
    COUNT(*) as num_observaciones,
    STDDEV(CASE WHEN i.codigo = 'IPC_ES_YOY' THEN h.valor END) as inflacion_desv_est,
    STDDEV(CASE WHEN i.codigo = 'IBEX35_RET_REAL' THEN h.valor END) as rentabilidad_desv_est
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_geografia g ON h.geo_key = g.geo_key
WHERE i.codigo IN ('IPC_ES_YOY', 'IBEX35_RET_REAL')
    AND g.codigo = 'ES'
GROUP BY t.año, t.trimestre, t.año_trimestre
HAVING COUNT(*) > 0
ORDER BY t.año DESC, t.trimestre DESC;

COMMENT ON VIEW v_inflacion_ibex_correlacion IS 
    'Análisis trimestral de correlación entre inflación y rentabilidad real del IBEX-35';

-- ============================================================================
-- VISTA 3: Evolución del Oro en EUR vs Poder Adquisitivo
-- ============================================================================

CREATE OR REPLACE VIEW v_oro_poder_adquisitivo AS
SELECT
    t.año,
    t.mes,
    t.año_mes,
    AVG(CASE WHEN i.codigo = 'ORO_EUR_IDX' THEN h.valor END) as oro_eur_idx_medio,
    AVG(CASE WHEN i.codigo = 'PODER_ADQ' THEN h.valor END) as poder_adquisitivo_idx_medio,
    AVG(CASE WHEN i.codigo = 'IPC_ES_YOY' THEN h.valor END) as inflacion_yoy_media,
    COUNT(DISTINCT t.fecha) as dias_observados
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
WHERE i.codigo IN ('ORO_EUR_IDX', 'PODER_ADQ', 'IPC_ES_YOY')
GROUP BY t.año, t.mes, t.año_mes
ORDER BY t.año DESC, t.mes DESC;

COMMENT ON VIEW v_oro_poder_adquisitivo IS 
    'Evolución mensual del precio del oro en EUR indexado vs poder adquisitivo e inflación';

-- ============================================================================
-- VISTA 4: Indicadores por Fuente (Comparación de fuentes)
-- ============================================================================

CREATE OR REPLACE VIEW v_comparacion_fuentes AS
SELECT
    i.nombre as indicador,
    f.institucion as fuente,
    g.nombre as geografia,
    t.año,
    COUNT(*) as num_observaciones,
    AVG(h.valor) as valor_medio,
    MIN(h.valor) as valor_minimo,
    MAX(h.valor) as valor_maximo,
    STDDEV(h.valor) as desviacion_estandar,
    COUNT(*) FILTER (WHERE h.calidad_dato = 'real') as datos_reales,
    COUNT(*) FILTER (WHERE h.calidad_dato = 'imputado') as datos_imputados
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_geografia g ON h.geo_key = g.geo_key
JOIN dim_fuente f ON h.fuente_key = f.fuente_key
GROUP BY i.nombre, f.institucion, g.nombre, t.año
ORDER BY i.nombre, t.año DESC;

COMMENT ON VIEW v_comparacion_fuentes IS 
    'Comparación de indicadores entre diferentes fuentes de datos para validación cruzada';

-- ============================================================================
-- VISTA 5: Calidad de Datos por Indicador
-- ============================================================================

CREATE OR REPLACE VIEW v_calidad_por_indicador AS
SELECT
    i.codigo,
    i.nombre as indicador,
    i.categoria,
    COUNT(*) as total_observaciones,
    COUNT(*) FILTER (WHERE h.calidad_dato = 'real') as datos_reales,
    COUNT(*) FILTER (WHERE h.calidad_dato = 'interpolado') as datos_interpolados,
    COUNT(*) FILTER (WHERE h.calidad_dato = 'imputado') as datos_imputados,
    COUNT(*) FILTER (WHERE h.calidad_dato = 'estimado') as datos_estimados,
    ROUND(100.0 * COUNT(*) FILTER (WHERE h.calidad_dato = 'real') / COUNT(*), 2) as pct_datos_reales,
    AVG(h.probabilidad_imputacion) as prob_imputacion_media,
    MIN(t.fecha) as fecha_inicio,
    MAX(t.fecha) as fecha_fin
FROM hechos_indicadores_temporales h
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
GROUP BY i.codigo, i.nombre, i.categoria
ORDER BY total_observaciones DESC;

COMMENT ON VIEW v_calidad_por_indicador IS 
    'Resumen de calidad de datos por indicador: porcentaje de datos reales, imputados, etc.';

-- ============================================================================
-- VISTA 6: Serie Temporal Completa por Indicador
-- ============================================================================

CREATE OR REPLACE VIEW v_serie_temporal_indicadores AS
SELECT
    t.fecha,
    t.año,
    t.mes,
    t.trimestre,
    i.codigo as indicador_codigo,
    i.nombre as indicador_nombre,
    i.categoria,
    g.codigo as geo_codigo,
    g.nombre as geografia,
    u.simbolo as unidad,
    h.valor,
    h.valor_anterior,
    h.variacion_absoluta,
    h.variacion_pct,
    h.calidad_dato,
    f.institucion as fuente
FROM hechos_indicadores_temporales h
JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
JOIN dim_indicador i ON h.indicador_key = i.indicador_key
JOIN dim_geografia g ON h.geo_key = g.geo_key
JOIN dim_unidad u ON h.unit_key = u.unit_key
JOIN dim_fuente f ON h.fuente_key = f.fuente_key
ORDER BY t.fecha DESC, i.codigo, g.codigo;

COMMENT ON VIEW v_serie_temporal_indicadores IS 
    'Serie temporal completa de todos los indicadores con todas sus dimensiones';

-- ============================================================================
-- VISTA 7: Análisis de Variaciones Interanuales
-- ============================================================================

CREATE OR REPLACE VIEW v_variaciones_interanuales AS
WITH datos_actuales AS (
    SELECT
        h.tiempo_key,
        h.indicador_key,
        h.geo_key,
        t.fecha,
        t.año,
        t.mes,
        h.valor as valor_actual
    FROM hechos_indicadores_temporales h
    JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
),
datos_año_anterior AS (
    SELECT
        h.indicador_key,
        h.geo_key,
        t.fecha,
        t.año,
        t.mes,
        h.valor as valor_año_anterior
    FROM hechos_indicadores_temporales h
    JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
)
SELECT
    da.año,
    da.mes,
    da.fecha,
    i.codigo as indicador_codigo,
    i.nombre as indicador,
    g.nombre as geografia,
    da.valor_actual,
    daa.valor_año_anterior,
    da.valor_actual - daa.valor_año_anterior as variacion_absoluta_yoy,
    ROUND(((da.valor_actual - daa.valor_año_anterior) / NULLIF(daa.valor_año_anterior, 0)) * 100, 2) as variacion_pct_yoy
FROM datos_actuales da
JOIN datos_año_anterior daa 
    ON da.indicador_key = daa.indicador_key 
    AND da.geo_key = daa.geo_key
    AND da.año = daa.año + 1
    AND da.mes = daa.mes
JOIN dim_indicador i ON da.indicador_key = i.indicador_key
JOIN dim_geografia g ON da.geo_key = g.geo_key
WHERE da.valor_actual IS NOT NULL AND daa.valor_año_anterior IS NOT NULL
ORDER BY da.fecha DESC, i.codigo;

COMMENT ON VIEW v_variaciones_interanuales IS 
    'Cálculo de variaciones interanuales (YoY) para todos los indicadores';

-- ============================================================================
-- VISTA 8: Dashboard Ejecutivo (KPIs principales)
-- ============================================================================

CREATE OR REPLACE VIEW v_dashboard_ejecutivo AS
WITH ultimo_mes AS (
    SELECT MAX(año_mes) as mes_actual FROM dim_tiempo WHERE fecha <= CURRENT_DATE
),
datos_recientes AS (
    SELECT
        i.categoria,
        i.nombre as indicador,
        h.valor,
        h.variacion_pct,
        t.año_mes
    FROM hechos_indicadores_temporales h
    JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
    JOIN dim_indicador i ON h.indicador_key = i.indicador_key
    JOIN dim_geografia g ON h.geo_key = g.geo_key
    WHERE g.codigo = 'ES'
        AND t.año_mes = (SELECT mes_actual FROM ultimo_mes)
)
SELECT
    MAX(CASE WHEN indicador = 'IPC España Base 100' THEN valor END) as ipc_actual,
    MAX(CASE WHEN indicador = 'Inflación Interanual España' THEN valor END) as inflacion_yoy,
    MAX(CASE WHEN indicador = 'Salario Real Deflactado' THEN valor END) as salario_real,
    MAX(CASE WHEN indicador = 'Poder Adquisitivo Índice' THEN valor END) as poder_adquisitivo_idx,
    MAX(CASE WHEN indicador = 'Precio Oro EUR' THEN valor END) as oro_eur,
    MAX(CASE WHEN indicador = 'IBEX-35 Cierre' THEN valor END) as ibex35,
    MAX(CASE WHEN indicador = 'Tipo de Cambio EUR/USD' THEN valor END) as eur_usd,
    (SELECT mes_actual FROM ultimo_mes) as periodo
FROM datos_recientes;

COMMENT ON VIEW v_dashboard_ejecutivo IS 
    'Dashboard con KPIs principales del último mes disponible';

-- ============================================================================
-- FUNCIONES AUXILIARES
-- ============================================================================

-- Función para obtener valor de un indicador en una fecha específica
CREATE OR REPLACE FUNCTION fn_obtener_valor_indicador(
    p_codigo_indicador VARCHAR,
    p_fecha DATE,
    p_codigo_geo VARCHAR DEFAULT 'ES'
)
RETURNS DECIMAL(15,4) AS $$
DECLARE
    v_valor DECIMAL(15,4);
BEGIN
    SELECT h.valor INTO v_valor
    FROM hechos_indicadores_temporales h
    JOIN dim_tiempo t ON h.tiempo_key = t.tiempo_key
    JOIN dim_indicador i ON h.indicador_key = i.indicador_key
    JOIN dim_geografia g ON h.geo_key = g.geo_key
    WHERE i.codigo = p_codigo_indicador
        AND t.fecha = p_fecha
        AND g.codigo = p_codigo_geo
    LIMIT 1;
    
    RETURN v_valor;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_obtener_valor_indicador IS 
    'Obtiene el valor de un indicador en una fecha y geografía específica';

-- Función para calcular correlación entre dos indicadores
CREATE OR REPLACE FUNCTION fn_calcular_correlacion(
    p_indicador1 VARCHAR,
    p_indicador2 VARCHAR,
    p_fecha_inicio DATE DEFAULT '2010-01-01',
    p_fecha_fin DATE DEFAULT CURRENT_DATE
)
RETURNS DECIMAL(6,4) AS $$
DECLARE
    v_correlacion DECIMAL(6,4);
BEGIN
    SELECT CORR(h1.valor, h2.valor)::DECIMAL(6,4) INTO v_correlacion
    FROM hechos_indicadores_temporales h1
    JOIN hechos_indicadores_temporales h2 
        ON h1.tiempo_key = h2.tiempo_key 
        AND h1.geo_key = h2.geo_key
    JOIN dim_indicador i1 ON h1.indicador_key = i1.indicador_key
    JOIN dim_indicador i2 ON h2.indicador_key = i2.indicador_key
    JOIN dim_tiempo t ON h1.tiempo_key = t.tiempo_key
    WHERE i1.codigo = p_indicador1
        AND i2.codigo = p_indicador2
        AND t.fecha BETWEEN p_fecha_inicio AND p_fecha_fin;
    
    RETURN v_correlacion;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_calcular_correlacion IS 
    'Calcula la correlación de Pearson entre dos indicadores en un período de tiempo';

-- ============================================================================
-- VERIFICACIÓN DE VISTAS CREADAS
-- ============================================================================

SELECT 
    table_name as vista,
    view_definition IS NOT NULL as creada_correctamente
FROM information_schema.views
WHERE table_schema = 'public' 
    AND table_name LIKE 'v_%'
ORDER BY table_name;
