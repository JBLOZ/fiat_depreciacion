-- ============================================================================
-- Script 04: Tablas de Auditoría y Validación
-- ============================================================================
-- Tablas para trazabilidad, logs de ETL y validación de calidad
-- ============================================================================

-- ============================================================================
-- TABLA: ETL_LOGS (Auditoría de ejecuciones ETL)
-- ============================================================================

DROP TABLE IF EXISTS etl_logs CASCADE;

CREATE TABLE etl_logs (
    log_id SERIAL PRIMARY KEY,
    nombre_job VARCHAR(100) NOT NULL,
    timestamp_inicio TIMESTAMP NOT NULL,
    timestamp_fin TIMESTAMP,
    duracion_segundos INTEGER GENERATED ALWAYS AS 
        (EXTRACT(EPOCH FROM (timestamp_fin - timestamp_inicio))::INTEGER) STORED,
    estado VARCHAR(20) DEFAULT 'iniciado' CHECK (estado IN ('iniciado', 'completado', 'error', 'advertencia')),
    registros_procesados INTEGER DEFAULT 0,
    registros_insertados INTEGER DEFAULT 0,
    registros_actualizados INTEGER DEFAULT 0,
    registros_errores INTEGER DEFAULT 0,
    descripcion_error TEXT,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    servidor VARCHAR(100) DEFAULT inet_server_addr()::TEXT,
    CONSTRAINT chk_timestamps CHECK (timestamp_fin IS NULL OR timestamp_fin >= timestamp_inicio),
    CONSTRAINT chk_registros_positivos CHECK (
        registros_procesados >= 0 AND 
        registros_insertados >= 0 AND 
        registros_actualizados >= 0 AND 
        registros_errores >= 0
    )
);

CREATE INDEX idx_etl_logs_fecha ON etl_logs(timestamp_inicio DESC);
CREATE INDEX idx_etl_logs_estado ON etl_logs(estado);
CREATE INDEX idx_etl_logs_job ON etl_logs(nombre_job);

COMMENT ON TABLE etl_logs IS 
    'Registro de auditoría de todas las ejecuciones del pipeline ETL';
COMMENT ON COLUMN etl_logs.duracion_segundos IS 
    'Duración de la ejecución calculada automáticamente en segundos';

-- ============================================================================
-- TABLA: VALIDACION_CALIDAD (Resultados de validaciones)
-- ============================================================================

DROP TABLE IF EXISTS validacion_calidad CASCADE;

CREATE TABLE validacion_calidad (
    validacion_id SERIAL PRIMARY KEY,
    fecha_validacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    indicador_key INTEGER,
    geo_key INTEGER,
    fuente_key INTEGER,
    tipo_validacion VARCHAR(100) NOT NULL,
    resultado BOOLEAN NOT NULL,
    num_registros_afectados INTEGER DEFAULT 0,
    descripcion TEXT,
    valores_esperados VARCHAR(200), -- Ej: "min: 80, max: 150"
    valores_observados VARCHAR(200), -- Ej: "min: 78.5, max: 156.2"
    acciones_tomadas TEXT,
    severidad VARCHAR(10) CHECK (severidad IN ('info', 'warning', 'error', 'critico')),
    FOREIGN KEY (indicador_key) REFERENCES dim_indicador(indicador_key),
    FOREIGN KEY (geo_key) REFERENCES dim_geografia(geo_key),
    FOREIGN KEY (fuente_key) REFERENCES dim_fuente(fuente_key),
    CONSTRAINT chk_num_registros_positivo CHECK (num_registros_afectados >= 0)
);

CREATE INDEX idx_validacion_fecha ON validacion_calidad(fecha_validacion DESC);
CREATE INDEX idx_validacion_tipo ON validacion_calidad(tipo_validacion);
CREATE INDEX idx_validacion_resultado ON validacion_calidad(resultado);
CREATE INDEX idx_validacion_indicador ON validacion_calidad(indicador_key);

COMMENT ON TABLE validacion_calidad IS 
    'Registro de todas las validaciones de calidad ejecutadas sobre los datos';
COMMENT ON COLUMN validacion_calidad.tipo_validacion IS 
    'Tipo de validación: rango, monotonicidad, unicidad, consistencia_fuentes, outliers, etc.';
COMMENT ON COLUMN validacion_calidad.resultado IS 
    'TRUE si la validación pasó correctamente, FALSE si se detectaron problemas';

-- ============================================================================
-- TABLA: TRAZABILIDAD_TRANSFORMACION (Linaje de datos)
-- ============================================================================

DROP TABLE IF EXISTS trazabilidad_transformacion CASCADE;

CREATE TABLE trazabilidad_transformacion (
    transformacion_id SERIAL PRIMARY KEY,
    nombre_transformacion VARCHAR(100) NOT NULL,
    descripcion TEXT,
    entrada_dataset VARCHAR(100),
    salida_dataset VARCHAR(100),
    formula_aplicada TEXT,
    parametros JSONB, -- Almacenar parámetros en formato JSON
    num_registros_entrada INTEGER,
    num_registros_salida INTEGER,
    resultado_validacion BOOLEAN,
    timestamp_ejecucion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duracion_milisegundos INTEGER,
    etl_log_id INTEGER REFERENCES etl_logs(log_id),
    CONSTRAINT chk_num_registros_positivos CHECK (
        num_registros_entrada >= 0 AND 
        num_registros_salida >= 0
    )
);

CREATE INDEX idx_trazabilidad_fecha ON trazabilidad_transformacion(timestamp_ejecucion DESC);
CREATE INDEX idx_trazabilidad_nombre ON trazabilidad_transformacion(nombre_transformacion);
CREATE INDEX idx_trazabilidad_etl_log ON trazabilidad_transformacion(etl_log_id);

COMMENT ON TABLE trazabilidad_transformacion IS 
    'Registro de linaje de datos: qué transformaciones se aplicaron, con qué parámetros y resultados';
COMMENT ON COLUMN trazabilidad_transformacion.parametros IS 
    'Parámetros de la transformación en formato JSON. Ej: {"base_año": 2010, "método": "CPI_INE"}';

-- ============================================================================
-- TABLA: DATOS_RECHAZADOS (Registros que fallaron validación)
-- ============================================================================

DROP TABLE IF EXISTS datos_rechazados CASCADE;

CREATE TABLE datos_rechazados (
    rechazo_id SERIAL PRIMARY KEY,
    fecha_rechazo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    etl_log_id INTEGER REFERENCES etl_logs(log_id),
    dataset_origen VARCHAR(100),
    fila_numero INTEGER,
    datos_originales JSONB, -- Almacenar fila completa en JSON
    motivo_rechazo TEXT NOT NULL,
    regla_validacion_fallida VARCHAR(100),
    valor_problematico VARCHAR(200),
    accion_tomada VARCHAR(20) CHECK (accion_tomada IN ('rechazado', 'corregido', 'marcado_para_revision')),
    fue_reprocesado BOOLEAN DEFAULT FALSE,
    fecha_reprocesamiento TIMESTAMP
);

CREATE INDEX idx_rechazados_fecha ON datos_rechazados(fecha_rechazo DESC);
CREATE INDEX idx_rechazados_dataset ON datos_rechazados(dataset_origen);
CREATE INDEX idx_rechazados_motivo ON datos_rechazados(motivo_rechazo);
CREATE INDEX idx_rechazados_etl_log ON datos_rechazados(etl_log_id);

COMMENT ON TABLE datos_rechazados IS 
    'Registro de todos los datos que fueron rechazados durante el ETL por no pasar validaciones';
COMMENT ON COLUMN datos_rechazados.datos_originales IS 
    'Fila completa de datos originales en formato JSON para análisis posterior';

-- ============================================================================
-- TABLA: METADATA_DW (Metadatos del Data Warehouse)
-- ============================================================================

DROP TABLE IF EXISTS metadata_dw CASCADE;

CREATE TABLE metadata_dw (
    metadata_id SERIAL PRIMARY KEY,
    clave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT,
    descripcion TEXT,
    tipo_dato VARCHAR(20) CHECK (tipo_dato IN ('string', 'integer', 'decimal', 'date', 'boolean', 'json')),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_actualizacion VARCHAR(50) DEFAULT CURRENT_USER
);

CREATE INDEX idx_metadata_clave ON metadata_dw(clave);

COMMENT ON TABLE metadata_dw IS 
    'Metadatos generales del Data Warehouse: versión, última carga, configuración, etc.';

-- Insertar metadatos iniciales
INSERT INTO metadata_dw (clave, valor, descripcion, tipo_dato) VALUES
    ('version_dw', '1.0.0', 'Versión del esquema del Data Warehouse', 'string'),
    ('fecha_creacion_dw', CURRENT_TIMESTAMP::TEXT, 'Fecha de creación del DW', 'date'),
    ('periodo_inicio', '2010-01-01', 'Fecha de inicio del período de análisis', 'date'),
    ('periodo_fin', '2025-12-31', 'Fecha de fin del período de análisis', 'date'),
    ('base_indice_año', '2010', 'Año base para índices normalizados (base 100)', 'integer'),
    ('autor', 'Jordi Blasco Lozano', 'Autor del proyecto', 'string'),
    ('proyecto', 'Depreciación del Euro y Erosión del Poder Adquisitivo en España', 'Nombre del proyecto', 'string'),
    ('institucion', 'Universidad de Alicante - Escuela Politécnica Superior', 'Institución', 'string');

-- ============================================================================
-- VISTA: RESUMEN_CALIDAD_DW
-- ============================================================================
-- Vista para monitorear estado general de calidad del DW

CREATE OR REPLACE VIEW v_resumen_calidad_dw AS
SELECT 
    -- Totales generales
    (SELECT COUNT(*) FROM hechos_indicadores_temporales) as total_hechos,
    (SELECT COUNT(*) FROM dim_tiempo) as total_fechas,
    (SELECT COUNT(*) FROM dim_indicador) as total_indicadores,
    (SELECT COUNT(*) FROM dim_geografia) as total_geografias,
    (SELECT COUNT(*) FROM dim_fuente) as total_fuentes,
    
    -- Calidad de datos
    (SELECT COUNT(*) FROM hechos_indicadores_temporales WHERE calidad_dato = 'real') as datos_reales,
    (SELECT COUNT(*) FROM hechos_indicadores_temporales WHERE calidad_dato = 'imputado') as datos_imputados,
    (SELECT COUNT(*) FROM hechos_indicadores_temporales WHERE calidad_dato = 'interpolado') as datos_interpolados,
    (SELECT COUNT(*) FROM hechos_indicadores_temporales WHERE calidad_dato = 'estimado') as datos_estimados,
    
    -- Porcentajes de calidad
    ROUND(100.0 * (SELECT COUNT(*) FROM hechos_indicadores_temporales WHERE calidad_dato = 'real') / 
          NULLIF((SELECT COUNT(*) FROM hechos_indicadores_temporales), 0), 2) as pct_datos_reales,
    
    -- Última actualización
    (SELECT MAX(ts_actualizacion) FROM hechos_indicadores_temporales) as ultima_actualizacion_hechos,
    (SELECT MAX(timestamp_fin) FROM etl_logs WHERE estado = 'completado') as ultima_ejecucion_etl_exitosa,
    
    -- Estado de validaciones
    (SELECT COUNT(*) FROM validacion_calidad WHERE resultado = TRUE) as validaciones_exitosas,
    (SELECT COUNT(*) FROM validacion_calidad WHERE resultado = FALSE) as validaciones_fallidas,
    
    -- Datos rechazados
    (SELECT COUNT(*) FROM datos_rechazados WHERE NOT fue_reprocesado) as datos_rechazados_pendientes;

COMMENT ON VIEW v_resumen_calidad_dw IS 
    'Vista de resumen del estado de calidad del Data Warehouse';

-- Verificación de creación de tablas de auditoría
SELECT 
    table_name,
    (SELECT count(*) FROM information_schema.columns WHERE table_name = t.table_name) as num_columnas
FROM information_schema.tables t
WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
    AND table_name IN ('etl_logs', 'validacion_calidad', 'trazabilidad_transformacion', 'datos_rechazados', 'metadata_dw')
ORDER BY table_name;
