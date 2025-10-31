-- ============================================================================
-- Script 02: Creación de Tablas de Dimensión (Esquema Estrella)
-- ============================================================================
-- Diseño basado en metodología Kimball
-- Esquema Estrella: 5 dimensiones + 1 tabla de hechos
-- ============================================================================

-- ============================================================================
-- DIMENSIÓN: TIEMPO
-- ============================================================================
-- Tabla de dimensión temporal con granularidad diaria
-- Cubre período completo del análisis: 2010-01-01 hasta 2025-12-31

DROP TABLE IF EXISTS dim_tiempo CASCADE;

CREATE TABLE dim_tiempo (
    tiempo_key INTEGER PRIMARY KEY DEFAULT nextval('seq_tiempo_key'),
    fecha DATE NOT NULL UNIQUE,
    año SMALLINT NOT NULL,
    mes SMALLINT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    trimestre SMALLINT NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    semana SMALLINT NOT NULL CHECK (semana BETWEEN 1 AND 53),
    dia_semana SMALLINT NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    nombre_mes VARCHAR(20) NOT NULL,
    nombre_dia VARCHAR(20) NOT NULL,
    es_festivo BOOLEAN DEFAULT FALSE,
    periodo_fiscal VARCHAR(10),
    año_mes VARCHAR(7) NOT NULL, -- Formato: YYYY-MM
    año_trimestre VARCHAR(7) NOT NULL, -- Formato: YYYY-Q1
    CONSTRAINT chk_fecha_rango CHECK (fecha BETWEEN '2010-01-01' AND '2025-12-31')
);

-- Índices para optimizar consultas temporales
CREATE INDEX idx_tiempo_fecha ON dim_tiempo(fecha);
CREATE INDEX idx_tiempo_año_mes ON dim_tiempo(año, mes);
CREATE INDEX idx_tiempo_año_trimestre ON dim_tiempo(año, trimestre);

-- Comentarios de documentación
COMMENT ON TABLE dim_tiempo IS 
    'Dimensión temporal con granularidad diaria (2010-2025). Permite análisis por día, mes, trimestre y año.';
COMMENT ON COLUMN dim_tiempo.dia_semana IS 
    '1=Lunes, 2=Martes, 3=Miércoles, 4=Jueves, 5=Viernes, 6=Sábado, 7=Domingo';
COMMENT ON COLUMN dim_tiempo.es_festivo IS 
    'TRUE si la fecha es festivo nacional en España';

-- ============================================================================
-- DIMENSIÓN: INDICADOR
-- ============================================================================
-- Tabla de dimensión para indicadores macroeconómicos

DROP TABLE IF EXISTS dim_indicador CASCADE;

CREATE TABLE dim_indicador (
    indicador_key INTEGER PRIMARY KEY DEFAULT nextval('seq_indicador_key'),
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    formula_calculo VARCHAR(500),
    categoria VARCHAR(50) NOT NULL,
    subcategoria VARCHAR(100),
    es_agregable BOOLEAN DEFAULT TRUE,
    unidad_base VARCHAR(20) NOT NULL,
    periodo_base VARCHAR(20), -- Ej: "2010-01-01" para índices base 100
    frecuencia_actualizacion VARCHAR(20), -- Diaria, Mensual, Trimestral
    CONSTRAINT chk_categoria CHECK (categoria IN (
        'inflacion', 'salarios', 'activos_financieros', 
        'tipo_cambio', 'empleo', 'otros'
    ))
);

-- Índices
CREATE INDEX idx_indicador_codigo ON dim_indicador(codigo);
CREATE INDEX idx_indicador_categoria ON dim_indicador(categoria);
CREATE INDEX idx_indicador_nombre ON dim_indicador(nombre);

COMMENT ON TABLE dim_indicador IS 
    'Dimensión de indicadores macroeconómicos: IPC, salarios, IBEX-35, oro, EUR/USD, etc.';
COMMENT ON COLUMN dim_indicador.es_agregable IS 
    'TRUE si el indicador se puede agregar mediante suma o promedio';
COMMENT ON COLUMN dim_indicador.formula_calculo IS 
    'Fórmula matemática para calcular el indicador (ej: W_real = W_nominal / (CPI_t / 100))';

-- ============================================================================
-- DIMENSIÓN: GEOGRAFÍA
-- ============================================================================
-- Tabla de dimensión geográfica jerárquica

DROP TABLE IF EXISTS dim_geografia CASCADE;

CREATE TABLE dim_geografia (
    geo_key INTEGER PRIMARY KEY DEFAULT nextval('seq_geografia_key'),
    codigo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    codigo_iso VARCHAR(5),
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('pais', 'region', 'ciudad', 'zona_economica')),
    geo_padre_key INTEGER REFERENCES dim_geografia(geo_key),
    nivel_jerarquia SMALLINT CHECK (nivel_jerarquia BETWEEN 0 AND 5),
    poblacion BIGINT,
    CONSTRAINT chk_jerarquia_consistente CHECK (
        (tipo = 'pais' AND nivel_jerarquia = 0) OR
        (tipo = 'region' AND nivel_jerarquia = 1) OR
        (tipo IN ('ciudad', 'zona_economica'))
    )
);

-- Índices
CREATE INDEX idx_geografia_codigo ON dim_geografia(codigo);
CREATE INDEX idx_geografia_nombre ON dim_geografia(nombre);
CREATE INDEX idx_geografia_tipo ON dim_geografia(tipo);
CREATE INDEX idx_geografia_padre ON dim_geografia(geo_padre_key);

COMMENT ON TABLE dim_geografia IS 
    'Dimensión geográfica jerárquica: España, CC.AA., ciudades, zona euro';
COMMENT ON COLUMN dim_geografia.geo_padre_key IS 
    'Clave foránea a geografía padre en jerarquía (ej: Madrid región → España país)';
COMMENT ON COLUMN dim_geografia.nivel_jerarquia IS 
    '0=País, 1=Región/CC.AA., 2=Ciudad';

-- ============================================================================
-- DIMENSIÓN: UNIDAD
-- ============================================================================
-- Tabla de dimensión para unidades de medida

DROP TABLE IF EXISTS dim_unidad CASCADE;

CREATE TABLE dim_unidad (
    unit_key INTEGER PRIMARY KEY DEFAULT nextval('seq_unidad_key'),
    simbolo VARCHAR(20) NOT NULL UNIQUE,
    descripcion VARCHAR(100),
    tipo_medida VARCHAR(20) NOT NULL CHECK (tipo_medida IN ('moneda', 'indice', 'porcentaje', 'cantidad')),
    decimales SMALLINT DEFAULT 2 CHECK (decimales BETWEEN 0 AND 10),
    factor_conversion DECIMAL(15,6) DEFAULT 1.0
);

-- Índices
CREATE INDEX idx_unidad_simbolo ON dim_unidad(simbolo);
CREATE INDEX idx_unidad_tipo ON dim_unidad(tipo_medida);

COMMENT ON TABLE dim_unidad IS 
    'Dimensión de unidades de medida: EUR, USD, %, Índice base 100, etc.';
COMMENT ON COLUMN dim_unidad.factor_conversion IS 
    'Factor para convertir a unidad base (ej: 1000 para convertir miles de EUR a EUR)';

-- ============================================================================
-- DIMENSIÓN: FUENTE
-- ============================================================================
-- Tabla de dimensión para fuentes de datos

DROP TABLE IF EXISTS dim_fuente CASCADE;

CREATE TABLE dim_fuente (
    fuente_key INTEGER PRIMARY KEY DEFAULT nextval('seq_fuente_key'),
    codigo VARCHAR(20) NOT NULL UNIQUE,
    institucion VARCHAR(150) NOT NULL,
    url_base VARCHAR(500),
    licencia VARCHAR(50),
    pais_origen VARCHAR(3),
    frecuencia_actualizacion INTEGER, -- días entre actualizaciones
    contacto_responsable VARCHAR(100),
    fecha_ultima_actualizacion DATE,
    confiabilidad VARCHAR(10) CHECK (confiabilidad IN ('alta', 'media', 'baja')),
    CONSTRAINT chk_frecuencia_positiva CHECK (frecuencia_actualizacion > 0)
);

-- Índices
CREATE INDEX idx_fuente_codigo ON dim_fuente(codigo);
CREATE INDEX idx_fuente_institucion ON dim_fuente(institucion);

COMMENT ON TABLE dim_fuente IS 
    'Dimensión de fuentes de datos: INE, Eurostat, BCE, LBMA, BME, etc.';
COMMENT ON COLUMN dim_fuente.frecuencia_actualizacion IS 
    'Días entre actualizaciones típicas de la fuente';
COMMENT ON COLUMN dim_fuente.confiabilidad IS 
    'Evaluación cualitativa de confiabilidad de la fuente: alta, media, baja';

-- Verificación de tablas creadas
SELECT 
    table_name,
    (SELECT count(*) FROM information_schema.columns WHERE table_name = t.table_name) as num_columnas
FROM information_schema.tables t
WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
    AND table_name LIKE 'dim_%'
ORDER BY table_name;
