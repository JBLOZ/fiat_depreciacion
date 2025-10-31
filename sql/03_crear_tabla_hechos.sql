-- ============================================================================
-- Script 03: Creación de Tabla de Hechos (Fact Table)
-- ============================================================================
-- Tabla central del esquema estrella: hechos_indicadores_temporales
-- Granularidad: Una fila por (fecha, indicador, geografía, unidad, fuente)
-- ============================================================================

DROP TABLE IF EXISTS hechos_indicadores_temporales CASCADE;

CREATE TABLE hechos_indicadores_temporales (
    -- Claves foráneas a dimensiones (componen la clave primaria compuesta)
    tiempo_key INTEGER NOT NULL,
    indicador_key INTEGER NOT NULL,
    geo_key INTEGER NOT NULL,
    unit_key INTEGER NOT NULL,
    fuente_key INTEGER NOT NULL,
    
    -- Métricas/hechos (valores medidos)
    valor DECIMAL(15,4) NOT NULL,
    valor_anterior DECIMAL(15,4), -- Valor del período anterior (para calcular variaciones)
    variacion_absoluta DECIMAL(15,4), -- valor - valor_anterior
    variacion_pct DECIMAL(8,4), -- ((valor - valor_anterior) / valor_anterior) * 100
    
    -- Calidad y trazabilidad de datos
    calidad_dato VARCHAR(20) DEFAULT 'real' CHECK (calidad_dato IN ('real', 'interpolado', 'imputado', 'estimado')),
    probabilidad_imputacion DECIMAL(5,4) CHECK (probabilidad_imputacion BETWEEN 0 AND 1),
    metodo_imputacion VARCHAR(100), -- Descripción del método si aplica
    
    -- Metadatos de auditoría
    ts_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ts_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_carga VARCHAR(50) DEFAULT CURRENT_USER,
    
    -- Clave primaria compuesta
    PRIMARY KEY (tiempo_key, indicador_key, geo_key, unit_key, fuente_key),
    
    -- Restricciones de integridad referencial
    CONSTRAINT fk_tiempo FOREIGN KEY (tiempo_key) 
        REFERENCES dim_tiempo(tiempo_key) ON DELETE RESTRICT,
    CONSTRAINT fk_indicador FOREIGN KEY (indicador_key) 
        REFERENCES dim_indicador(indicador_key) ON DELETE RESTRICT,
    CONSTRAINT fk_geografia FOREIGN KEY (geo_key) 
        REFERENCES dim_geografia(geo_key) ON DELETE RESTRICT,
    CONSTRAINT fk_unidad FOREIGN KEY (unit_key) 
        REFERENCES dim_unidad(unit_key) ON DELETE RESTRICT,
    CONSTRAINT fk_fuente FOREIGN KEY (fuente_key) 
        REFERENCES dim_fuente(fuente_key) ON DELETE RESTRICT,
    
    -- Restricciones de validación de datos
    CONSTRAINT chk_variacion_consistente CHECK (
        (valor_anterior IS NULL) OR 
        (variacion_absoluta = valor - valor_anterior)
    ),
    CONSTRAINT chk_probabilidad_imputacion CHECK (
        (calidad_dato != 'imputado') OR 
        (probabilidad_imputacion IS NOT NULL AND probabilidad_imputacion > 0)
    )
);

-- ============================================================================
-- ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS OLAP
-- ============================================================================

-- Índice principal por tiempo (consultas más comunes: análisis temporal)
CREATE INDEX idx_hechos_tiempo ON hechos_indicadores_temporales(tiempo_key DESC);

-- Índice compuesto para drill-down temporal + indicador
CREATE INDEX idx_hechos_tiempo_indicador ON hechos_indicadores_temporales(tiempo_key DESC, indicador_key);

-- Índice para filtrado por indicador específico
CREATE INDEX idx_hechos_indicador ON hechos_indicadores_temporales(indicador_key);

-- Índice para análisis geográfico
CREATE INDEX idx_hechos_geografia ON hechos_indicadores_temporales(geo_key);

-- Índice para análisis por fuente (comparación entre fuentes)
CREATE INDEX idx_hechos_fuente ON hechos_indicadores_temporales(fuente_key);

-- Índice compuesto para drill-down geográfico + temporal
CREATE INDEX idx_hechos_geo_tiempo ON hechos_indicadores_temporales(geo_key, tiempo_key DESC);

-- Índice para filtrar por calidad de datos
CREATE INDEX idx_hechos_calidad ON hechos_indicadores_temporales(calidad_dato);

-- Índice de cobertura para consultas frecuentes (incluye columnas adicionales)
CREATE INDEX idx_hechos_cobertura ON hechos_indicadores_temporales(
    tiempo_key, indicador_key, geo_key, valor
) INCLUDE (calidad_dato, variacion_pct);

-- Índice para búsqueda de valores en rango
CREATE INDEX idx_hechos_valor_rango ON hechos_indicadores_temporales(valor);

-- ============================================================================
-- PARTICIONAMIENTO POR AÑO (Optimización para tablas grandes)
-- ============================================================================
-- Opcional: Si la tabla de hechos crece mucho, particionar por año

-- Ejemplo de partición declarativa (PostgreSQL 10+):
/*
-- Convertir tabla a particionada
ALTER TABLE hechos_indicadores_temporales 
    ADD CONSTRAINT fk_tiempo_for_partition 
    FOREIGN KEY (tiempo_key) REFERENCES dim_tiempo(tiempo_key);

-- Crear particiones por año
CREATE TABLE hechos_2010 PARTITION OF hechos_indicadores_temporales
    FOR VALUES FROM (tiempo_key correspondiente a 2010-01-01) 
    TO (tiempo_key correspondiente a 2011-01-01);
-- Repetir para 2011, 2012, ..., 2025
*/

-- ============================================================================
-- ESTADÍSTICAS Y COMENTARIOS
-- ============================================================================

COMMENT ON TABLE hechos_indicadores_temporales IS 
    'Tabla de hechos central del DW. Almacena observaciones de indicadores macroeconómicos por tiempo, geografía y fuente.';

COMMENT ON COLUMN hechos_indicadores_temporales.valor IS 
    'Valor medido del indicador en la unidad especificada';

COMMENT ON COLUMN hechos_indicadores_temporales.valor_anterior IS 
    'Valor del mismo indicador en el período anterior (para calcular variaciones)';

COMMENT ON COLUMN hechos_indicadores_temporales.variacion_pct IS 
    'Variación porcentual respecto al período anterior: ((valor - valor_anterior) / valor_anterior) * 100';

COMMENT ON COLUMN hechos_indicadores_temporales.calidad_dato IS 
    'Calidad del dato: real (medido), interpolado (calculado entre dos valores), imputado (estimado por modelo), estimado (provisional)';

COMMENT ON COLUMN hechos_indicadores_temporales.probabilidad_imputacion IS 
    'Probabilidad de confianza de la imputación (0-1). Solo aplica si calidad_dato = imputado';

COMMENT ON COLUMN hechos_indicadores_temporales.ts_actualizacion IS 
    'Timestamp de última actualización del registro';

COMMENT ON COLUMN hechos_indicadores_temporales.ts_carga IS 
    'Timestamp de carga inicial del registro en el DW';

-- Forzar recálculo de estadísticas para el optimizador de consultas
ANALYZE hechos_indicadores_temporales;

-- Verificación de creación
SELECT 
    'Tabla de hechos creada' as estado,
    (SELECT count(*) FROM information_schema.columns 
     WHERE table_name = 'hechos_indicadores_temporales') as num_columnas,
    (SELECT count(*) FROM information_schema.table_constraints 
     WHERE table_name = 'hechos_indicadores_temporales') as num_constraints;
