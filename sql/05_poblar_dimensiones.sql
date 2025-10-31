-- ============================================================================
-- Script 05: Poblado Inicial de Dimensiones Maestras
-- ============================================================================
-- Inserción de datos maestros en las dimensiones
-- Datos necesarios para el correcto funcionamiento del DW
-- ============================================================================

-- ============================================================================
-- POBLADO: dim_tiempo (2010-2025)
-- ============================================================================
-- Generar todas las fechas del período de análisis

INSERT INTO dim_tiempo (
    fecha, 
    año, 
    mes, 
    trimestre, 
    semana, 
    dia_semana,
    nombre_mes,
    nombre_dia,
    es_festivo,
    periodo_fiscal,
    año_mes,
    año_trimestre
)
SELECT
    fecha_generada::DATE as fecha,
    EXTRACT(YEAR FROM fecha_generada)::SMALLINT as año,
    EXTRACT(MONTH FROM fecha_generada)::SMALLINT as mes,
    EXTRACT(QUARTER FROM fecha_generada)::SMALLINT as trimestre,
    EXTRACT(WEEK FROM fecha_generada)::SMALLINT as semana,
    EXTRACT(ISODOW FROM fecha_generada)::SMALLINT as dia_semana,
    CASE EXTRACT(MONTH FROM fecha_generada)
        WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
    END as nombre_mes,
    CASE EXTRACT(ISODOW FROM fecha_generada)
        WHEN 1 THEN 'Lunes' WHEN 2 THEN 'Martes' WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves' WHEN 5 THEN 'Viernes' 
        WHEN 6 THEN 'Sábado' WHEN 7 THEN 'Domingo'
    END as nombre_dia,
    FALSE as es_festivo, -- Se actualizará posteriormente con festivos españoles
    'Q' || EXTRACT(QUARTER FROM fecha_generada)::TEXT as periodo_fiscal,
    TO_CHAR(fecha_generada, 'YYYY-MM') as año_mes,
    EXTRACT(YEAR FROM fecha_generada)::TEXT || '-Q' || EXTRACT(QUARTER FROM fecha_generada)::TEXT as año_trimestre
FROM generate_series(
    '2010-01-01'::DATE,
    '2025-12-31'::DATE,
    '1 day'::INTERVAL
) as fecha_generada;

-- Marcar festivos nacionales españoles (principales)
-- Nota: Esta es una lista simplificada. En producción se completaría con todos los festivos
UPDATE dim_tiempo SET es_festivo = TRUE 
WHERE (mes = 1 AND (SELECT EXTRACT(DAY FROM fecha)) = 1)  -- Año Nuevo
   OR (mes = 1 AND (SELECT EXTRACT(DAY FROM fecha)) = 6)  -- Reyes
   OR (mes = 5 AND (SELECT EXTRACT(DAY FROM fecha)) = 1)  -- Día del Trabajo
   OR (mes = 8 AND (SELECT EXTRACT(DAY FROM fecha)) = 15) -- Asunción
   OR (mes = 10 AND (SELECT EXTRACT(DAY FROM fecha)) = 12) -- Fiesta Nacional
   OR (mes = 11 AND (SELECT EXTRACT(DAY FROM fecha)) = 1) -- Todos los Santos
   OR (mes = 12 AND (SELECT EXTRACT(DAY FROM fecha)) = 6) -- Constitución
   OR (mes = 12 AND (SELECT EXTRACT(DAY FROM fecha)) = 8) -- Inmaculada
   OR (mes = 12 AND (SELECT EXTRACT(DAY FROM fecha)) = 25); -- Navidad

SELECT 
    'dim_tiempo poblada' as tabla,
    COUNT(*) as total_registros,
    MIN(fecha) as fecha_minima,
    MAX(fecha) as fecha_maxima,
    COUNT(*) FILTER (WHERE es_festivo = TRUE) as total_festivos
FROM dim_tiempo;

-- ============================================================================
-- POBLADO: dim_indicador (Indicadores macroeconómicos)
-- ============================================================================

INSERT INTO dim_indicador (
    codigo, nombre, descripcion, formula_calculo, categoria, subcategoria, 
    es_agregable, unidad_base, periodo_base, frecuencia_actualizacion
) VALUES
    -- Indicadores de Inflación
    ('IPC_ES_100', 
     'IPC España Base 100', 
     'Índice de Precios al Consumo de España, base 100 en año 2010',
     'Índice base 100 = (IPC_t / IPC_2010) * 100',
     'inflacion', 'ipc', TRUE, 'Índice', '2010-01-01', 'Mensual'),
    
    ('IPC_ES_YOY', 
     'Inflación Interanual España', 
     'Variación interanual del IPC en porcentaje',
     'Inflación_YoY = ((IPC_t - IPC_t-12) / IPC_t-12) * 100',
     'inflacion', 'variacion', FALSE, '%', NULL, 'Mensual'),
    
    ('HICP_ES', 
     'HICP España (Eurostat)', 
     'Índice Armonizado de Precios al Consumo',
     'HICP armonizado según metodología Eurostat',
     'inflacion', 'hicp', TRUE, 'Índice', '2015', 'Mensual'),
    
    -- Indicadores de Salarios
    ('SALARIO_NOM', 
     'Salario Nominal Medio', 
     'Salario mensual medio nominal en España',
     'Media de salarios brutos mensuales',
     'salarios', 'nominal', TRUE, 'EUR', NULL, 'Trimestral'),
    
    ('SALARIO_REAL', 
     'Salario Real Deflactado', 
     'Salario nominal deflactado por IPC',
     'W_real = W_nominal / (CPI_t / 100)',
     'salarios', 'real', TRUE, 'EUR', '2010-01-01', 'Trimestral'),
    
    ('SALARIO_REAL_IDX', 
     'Índice Salario Real Base 100', 
     'Índice de salario real base 100 en 2010',
     'Índice_2010 = (W_real_t / W_real_2010) * 100',
     'salarios', 'indice', TRUE, 'Índice', '2010-01-01', 'Trimestral'),
    
    -- Indicadores de Poder Adquisitivo
    ('PODER_ADQ', 
     'Poder Adquisitivo Índice', 
     'Índice de poder adquisitivo de los salarios',
     'PA = (Salario_real_t / IPC_t) * 100',
     'salarios', 'poder_adquisitivo', TRUE, 'Índice', '2010-01-01', 'Trimestral'),
    
    -- Indicadores de Activos Financieros
    ('ORO_USD', 
     'Precio Oro USD', 
     'Precio del oro en dólares por onza troy',
     'Precio fixing LBMA PM',
     'activos_financieros', 'materias_primas', TRUE, 'USD/oz', NULL, 'Diario'),
    
    ('ORO_EUR', 
     'Precio Oro EUR', 
     'Precio del oro en euros por onza troy',
     'ORO_EUR = ORO_USD / EUR_USD_Rate',
     'activos_financieros', 'materias_primas', TRUE, 'EUR/oz', NULL, 'Diario'),
    
    ('ORO_EUR_IDX', 
     'Índice Oro EUR Base 100', 
     'Precio del oro en EUR indexado a base 100 en 2010',
     'Índice_2010 = (ORO_EUR_t / ORO_EUR_2010) * 100',
     'activos_financieros', 'indice', TRUE, 'Índice', '2010-01-01', 'Diario'),
    
    ('IBEX35_CIERRE', 
     'IBEX-35 Cierre', 
     'Índice IBEX-35 al cierre de sesión',
     'Valor de cierre diario',
     'activos_financieros', 'renta_variable', TRUE, 'Índice', NULL, 'Diario'),
    
    ('IBEX35_RET_LOG', 
     'IBEX-35 Retorno Logarítmico', 
     'Retorno logarítmico diario del IBEX-35',
     'r_t = ln(P_t / P_{t-1})',
     'activos_financieros', 'rentabilidad', FALSE, '%', NULL, 'Diario'),
    
    ('IBEX35_RET_REAL', 
     'IBEX-35 Rentabilidad Real', 
     'Rentabilidad del IBEX ajustada por inflación',
     'Ret_real = Ret_nominal - Inflación',
     'activos_financieros', 'rentabilidad_real', FALSE, '%', NULL, 'Mensual'),
    
    -- Indicadores de Tipo de Cambio
    ('EUR_USD', 
     'Tipo de Cambio EUR/USD', 
     'Tipo de cambio euro a dólar',
     'Tipo de cierre BCE',
     'tipo_cambio', 'principal', TRUE, 'Rate', NULL, 'Diario'),
    
    ('EUR_USD_VAR', 
     'Variación EUR/USD', 
     'Variación porcentual del tipo de cambio',
     'Var = ((Rate_t - Rate_{t-1}) / Rate_{t-1}) * 100',
     'tipo_cambio', 'variacion', FALSE, '%', NULL, 'Diario'),
    
    -- Indicadores de Empleo (contextuales)
    ('TASA_PARO', 
     'Tasa de Desempleo', 
     'Tasa de paro en España',
     'Paro = (Desempleados / Población_Activa) * 100',
     'empleo', 'desempleo', TRUE, '%', NULL, 'Trimestral'),
    
    ('EMPLEO_TOTAL', 
     'Empleo Total', 
     'Número total de ocupados',
     'Suma de ocupados totales',
     'empleo', 'ocupacion', TRUE, 'Miles', NULL, 'Trimestral');

SELECT 
    'dim_indicador poblada' as tabla,
    COUNT(*) as total_registros,
    COUNT(*) FILTER (WHERE categoria = 'inflacion') as indicadores_inflacion,
    COUNT(*) FILTER (WHERE categoria = 'salarios') as indicadores_salarios,
    COUNT(*) FILTER (WHERE categoria = 'activos_financieros') as indicadores_activos
FROM dim_indicador;

-- ============================================================================
-- POBLADO: dim_geografia (España y comunidades autónomas)
-- ============================================================================

-- País: España (nivel 0)
INSERT INTO dim_geografia (codigo, nombre, codigo_iso, tipo, geo_padre_key, nivel_jerarquia, poblacion)
VALUES ('ES', 'España', 'ES', 'pais', NULL, 0, 47450000);

-- Comunidades Autónomas (nivel 1)
INSERT INTO dim_geografia (codigo, nombre, codigo_iso, tipo, geo_padre_key, nivel_jerarquia, poblacion)
SELECT 
    codigo, nombre, codigo_iso, 'region', 
    (SELECT geo_key FROM dim_geografia WHERE codigo = 'ES'), 1, poblacion
FROM (VALUES
    ('ES-AN', 'Andalucía', 'ES-AN', 8475000),
    ('ES-AR', 'Aragón', 'ES-AR', 1330000),
    ('ES-AS', 'Principado de Asturias', 'ES-AS', 1020000),
    ('ES-IB', 'Illes Balears', 'ES-IB', 1180000),
    ('ES-CN', 'Canarias', 'ES-CN', 2200000),
    ('ES-CB', 'Cantabria', 'ES-CB', 580000),
    ('ES-CL', 'Castilla y León', 'ES-CL', 2400000),
    ('ES-CM', 'Castilla-La Mancha', 'ES-CM', 2050000),
    ('ES-CT', 'Catalunya', 'ES-CT', 7760000),
    ('ES-VC', 'Comunitat Valenciana', 'ES-VC', 5060000),
    ('ES-EX', 'Extremadura', 'ES-EX', 1060000),
    ('ES-GA', 'Galicia', 'ES-GA', 2700000),
    ('ES-MD', 'Comunidad de Madrid', 'ES-MD', 6750000),
    ('ES-MC', 'Región de Murcia', 'ES-MC', 1520000),
    ('ES-NC', 'Comunidad Foral de Navarra', 'ES-NC', 660000),
    ('ES-PV', 'País Vasco', 'ES-PV', 2210000),
    ('ES-RI', 'La Rioja', 'ES-RI', 320000)
) AS ccaa(codigo, nombre, codigo_iso, poblacion);

-- Zona Económica: Zona Euro (nivel 0, sin padre)
INSERT INTO dim_geografia (codigo, nombre, codigo_iso, tipo, geo_padre_key, nivel_jerarquia, poblacion)
VALUES ('EU-EURO', 'Zona Euro', 'EU', 'zona_economica', NULL, 0, 340000000);

-- Global (para indicadores globales como oro)
INSERT INTO dim_geografia (codigo, nombre, codigo_iso, tipo, geo_padre_key, nivel_jerarquia, poblacion)
VALUES ('GLOBAL', 'Global', 'XX', 'zona_economica', NULL, 0, NULL);

SELECT 
    'dim_geografia poblada' as tabla,
    COUNT(*) as total_registros,
    COUNT(*) FILTER (WHERE tipo = 'pais') as paises,
    COUNT(*) FILTER (WHERE tipo = 'region') as regiones,
    COUNT(*) FILTER (WHERE tipo = 'zona_economica') as zonas_economicas
FROM dim_geografia;

-- ============================================================================
-- POBLADO: dim_unidad (Unidades de medida)
-- ============================================================================

INSERT INTO dim_unidad (simbolo, descripcion, tipo_medida, decimales, factor_conversion)
VALUES
    -- Monedas
    ('EUR', 'Euro', 'moneda', 2, 1.0),
    ('USD', 'Dólar Estadounidense', 'moneda', 2, 1.0),
    ('USD/oz', 'Dólares por onza troy', 'moneda', 2, 1.0),
    ('EUR/oz', 'Euros por onza troy', 'moneda', 2, 1.0),
    
    -- Índices
    ('Índice', 'Índice sin unidad específica', 'indice', 2, 1.0),
    ('Índice_100', 'Índice base 100', 'indice', 2, 1.0),
    
    -- Porcentajes
    ('%', 'Porcentaje', 'porcentaje', 3, 1.0),
    ('pp', 'Puntos porcentuales', 'porcentaje', 3, 1.0),
    
    -- Tipos de cambio
    ('Rate', 'Tipo de cambio (rate)', 'indice', 4, 1.0),
    
    -- Cantidades
    ('Miles', 'Miles de unidades', 'cantidad', 0, 1000.0),
    ('Millones', 'Millones de unidades', 'cantidad', 0, 1000000.0),
    ('Unidades', 'Unidades individuales', 'cantidad', 0, 1.0);

SELECT 
    'dim_unidad poblada' as tabla,
    COUNT(*) as total_registros,
    COUNT(*) FILTER (WHERE tipo_medida = 'moneda') as unidades_moneda,
    COUNT(*) FILTER (WHERE tipo_medida = 'indice') as unidades_indice,
    COUNT(*) FILTER (WHERE tipo_medida = 'porcentaje') as unidades_porcentaje
FROM dim_unidad;

-- ============================================================================
-- POBLADO: dim_fuente (Fuentes de datos)
-- ============================================================================

INSERT INTO dim_fuente (
    codigo, institucion, url_base, licencia, pais_origen, 
    frecuencia_actualizacion, confiabilidad
)
VALUES
    ('INE', 
     'Instituto Nacional de Estadística', 
     'https://www.ine.es', 
     'CC-BY-4.0', 'ES', 30, 'alta'),
    
    ('EUROSTAT', 
     'Eurostat - Oficina Estadística de la Unión Europea', 
     'https://ec.europa.eu/eurostat', 
     'CC-BY-4.0', 'EU', 30, 'alta'),
    
    ('BCE', 
     'Banco Central Europeo', 
     'https://www.ecb.europa.eu', 
     'Open Data', 'EU', 1, 'alta'),
    
    ('LBMA', 
     'London Bullion Market Association', 
     'https://www.lbma.org.uk', 
     'Public', 'GB', 1, 'alta'),
    
    ('BME', 
     'Bolsas y Mercados Españoles', 
     'https://www.bolsasymercados.es', 
     'Uso académico', 'ES', 1, 'alta'),
    
    ('YAHOO_FINANCE', 
     'Yahoo Finance', 
     'https://finance.yahoo.com', 
     'Fair Use', 'US', 1, 'media'),
    
    ('OANDA', 
     'OANDA Currency Data', 
     'https://www.oanda.com', 
     'Open Data', 'US', 1, 'alta'),
    
    ('KITCO', 
     'Kitco Metals', 
     'https://www.kitco.com', 
     'Public', 'CA', 1, 'media'),
    
    ('BANCO_ESPANA', 
     'Banco de España', 
     'https://www.bde.es', 
     'Open Data', 'ES', 90, 'alta'),
    
    ('OCDE', 
     'Organización para la Cooperación y el Desarrollo Económicos', 
     'https://www.oecd.org', 
     'CC-BY-4.0', 'FR', 90, 'alta');

SELECT 
    'dim_fuente poblada' as tabla,
    COUNT(*) as total_registros,
    COUNT(*) FILTER (WHERE confiabilidad = 'alta') as fuentes_alta_confiabilidad,
    COUNT(*) FILTER (WHERE frecuencia_actualizacion = 1) as fuentes_diarias,
    COUNT(*) FILTER (WHERE pais_origen = 'ES') as fuentes_españolas
FROM dim_fuente;

-- ============================================================================
-- RESUMEN FINAL DEL POBLADO
-- ============================================================================

SELECT 
    'RESUMEN: Dimensiones pobladas correctamente' as estado,
    (SELECT COUNT(*) FROM dim_tiempo) as dim_tiempo,
    (SELECT COUNT(*) FROM dim_indicador) as dim_indicador,
    (SELECT COUNT(*) FROM dim_geografia) as dim_geografia,
    (SELECT COUNT(*) FROM dim_unidad) as dim_unidad,
    (SELECT COUNT(*) FROM dim_fuente) as dim_fuente;
