-- ============================================================================
-- APARTADO 3: DISEÑO FÍSICO DEL DATA WAREHOUSE
-- Script 01: Creación de Secuencias para Claves Sustitutas
-- ============================================================================
-- Proyecto: Depreciación del Euro y Erosión del Poder Adquisitivo en España
-- Autor: Jordi Blasco Lozano
-- Fecha: 31 de octubre de 2025
-- Base de Datos: PostgreSQL
-- ============================================================================

-- Eliminar secuencias existentes si es necesario (para re-ejecución)
DROP SEQUENCE IF EXISTS seq_tiempo_key CASCADE;
DROP SEQUENCE IF EXISTS seq_indicador_key CASCADE;
DROP SEQUENCE IF EXISTS seq_geografia_key CASCADE;
DROP SEQUENCE IF EXISTS seq_unidad_key CASCADE;
DROP SEQUENCE IF EXISTS seq_fuente_key CASCADE;

-- Secuencia para claves de dimensión TIEMPO
CREATE SEQUENCE seq_tiempo_key 
    START WITH 1 
    INCREMENT BY 1
    NO CYCLE
    CACHE 100;

COMMENT ON SEQUENCE seq_tiempo_key IS 
    'Secuencia para generar claves sustitutas en dim_tiempo';

-- Secuencia para claves de dimensión INDICADOR
CREATE SEQUENCE seq_indicador_key 
    START WITH 1 
    INCREMENT BY 1
    NO CYCLE
    CACHE 50;

COMMENT ON SEQUENCE seq_indicador_key IS 
    'Secuencia para generar claves sustitutas en dim_indicador';

-- Secuencia para claves de dimensión GEOGRAFÍA
CREATE SEQUENCE seq_geografia_key 
    START WITH 1 
    INCREMENT BY 1
    NO CYCLE
    CACHE 50;

COMMENT ON SEQUENCE seq_geografia_key IS 
    'Secuencia para generar claves sustitutas en dim_geografia';

-- Secuencia para claves de dimensión UNIDAD
CREATE SEQUENCE seq_unidad_key 
    START WITH 1 
    INCREMENT BY 1
    NO CYCLE
    CACHE 20;

COMMENT ON SEQUENCE seq_unidad_key IS 
    'Secuencia para generar claves sustitutas en dim_unidad';

-- Secuencia para claves de dimensión FUENTE
CREATE SEQUENCE seq_fuente_key 
    START WITH 1 
    INCREMENT BY 1
    NO CYCLE
    CACHE 20;

COMMENT ON SEQUENCE seq_fuente_key IS 
    'Secuencia para generar claves sustitutas en dim_fuente';

-- Verificación de secuencias creadas
SELECT 
    sequence_name,
    start_value,
    increment_by,
    last_value
FROM information_schema.sequences
WHERE sequence_schema = 'public'
    AND sequence_name LIKE 'seq_%_key'
ORDER BY sequence_name;
