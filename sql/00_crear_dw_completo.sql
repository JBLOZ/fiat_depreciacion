-- ============================================================================
-- SCRIPT MAESTRO: Creación Completa del Data Warehouse
-- ============================================================================
-- Ejecuta todos los scripts en orden para crear el DW completo
-- Base de Datos: PostgreSQL 12+
-- ============================================================================

-- ============================================================================
-- INFORMACIÓN DEL PROYECTO
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '============================================================================';
    RAISE NOTICE 'Data Warehouse: Depreciación del Euro y Erosión del Poder Adquisitivo';
    RAISE NOTICE 'Proyecto: Adquisición y Preparación de Datos';
    RAISE NOTICE 'Autor: Jordi Blasco Lozano';
    RAISE NOTICE 'Universidad de Alicante - Escuela Politécnica Superior';
    RAISE NOTICE 'Fecha: 31 de octubre de 2025';
    RAISE NOTICE '============================================================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Iniciando creación del Data Warehouse...';
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- PASO 1: Crear Secuencias
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '[1/6] Creando secuencias para claves sustitutas...';
END $$;

\i 01_crear_secuencias.sql

-- ============================================================================
-- PASO 2: Crear Tablas de Dimensión
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '[2/6] Creando tablas de dimensión...';
END $$;

\i 02_crear_dimensiones.sql

-- ============================================================================
-- PASO 3: Crear Tabla de Hechos
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '[3/6] Creando tabla de hechos...';
END $$;

\i 03_crear_tabla_hechos.sql

-- ============================================================================
-- PASO 4: Crear Tablas de Auditoría
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '[4/6] Creando tablas de auditoría y validación...';
END $$;

\i 04_crear_tablas_auditoria.sql

-- ============================================================================
-- PASO 5: Poblar Dimensiones Maestras
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '[5/6] Poblando dimensiones maestras...';
END $$;

\i 05_poblar_dimensiones.sql

-- ============================================================================
-- PASO 6: Crear Vistas Analíticas
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '[6/6] Creando vistas analíticas y funciones...';
END $$;

\i 06_crear_vistas_analiticas.sql

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================
DO $$
DECLARE
    v_num_secuencias INTEGER;
    v_num_dimensiones INTEGER;
    v_num_hechos INTEGER;
    v_num_auditoria INTEGER;
    v_num_vistas INTEGER;
    v_total_registros_dimensiones INTEGER;
BEGIN
    -- Contar objetos creados
    SELECT COUNT(*) INTO v_num_secuencias 
    FROM information_schema.sequences 
    WHERE sequence_schema = 'public' AND sequence_name LIKE 'seq_%_key';
    
    SELECT COUNT(*) INTO v_num_dimensiones 
    FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name LIKE 'dim_%';
    
    SELECT COUNT(*) INTO v_num_hechos 
    FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name LIKE 'hechos_%';
    
    SELECT COUNT(*) INTO v_num_auditoria 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
        AND table_name IN ('etl_logs', 'validacion_calidad', 'trazabilidad_transformacion', 
                          'datos_rechazados', 'metadata_dw');
    
    SELECT COUNT(*) INTO v_num_vistas 
    FROM information_schema.views 
    WHERE table_schema = 'public' AND table_name LIKE 'v_%';
    
    -- Contar registros en dimensiones
    SELECT 
        (SELECT COUNT(*) FROM dim_tiempo) +
        (SELECT COUNT(*) FROM dim_indicador) +
        (SELECT COUNT(*) FROM dim_geografia) +
        (SELECT COUNT(*) FROM dim_unidad) +
        (SELECT COUNT(*) FROM dim_fuente)
    INTO v_total_registros_dimensiones;
    
    -- Imprimir resumen
    RAISE NOTICE '';
    RAISE NOTICE '============================================================================';
    RAISE NOTICE 'RESUMEN DE CREACIÓN DEL DATA WAREHOUSE';
    RAISE NOTICE '============================================================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Objetos creados exitosamente:';
    RAISE NOTICE '  - Secuencias: %', v_num_secuencias;
    RAISE NOTICE '  - Tablas de Dimensión: %', v_num_dimensiones;
    RAISE NOTICE '  - Tablas de Hechos: %', v_num_hechos;
    RAISE NOTICE '  - Tablas de Auditoría: %', v_num_auditoria;
    RAISE NOTICE '  - Vistas Analíticas: %', v_num_vistas;
    RAISE NOTICE '';
    RAISE NOTICE 'Registros en dimensiones: %', v_total_registros_dimensiones;
    RAISE NOTICE '';
    RAISE NOTICE 'Detalle por dimensión:';
    RAISE NOTICE '  - dim_tiempo: % registros (2010-2025)', (SELECT COUNT(*) FROM dim_tiempo);
    RAISE NOTICE '  - dim_indicador: % registros', (SELECT COUNT(*) FROM dim_indicador);
    RAISE NOTICE '  - dim_geografia: % registros', (SELECT COUNT(*) FROM dim_geografia);
    RAISE NOTICE '  - dim_unidad: % registros', (SELECT COUNT(*) FROM dim_unidad);
    RAISE NOTICE '  - dim_fuente: % registros', (SELECT COUNT(*) FROM dim_fuente);
    RAISE NOTICE '';
    RAISE NOTICE '============================================================================';
    RAISE NOTICE 'Data Warehouse creado exitosamente';
    RAISE NOTICE '============================================================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Próximos pasos:';
    RAISE NOTICE '  1. Ejecutar pipeline ETL (Pentaho) para cargar datos';
    RAISE NOTICE '  2. Validar calidad de datos cargados';
    RAISE NOTICE '  3. Generar visualizaciones';
    RAISE NOTICE '';
END $$;

-- Verificación final: Mostrar estructura del esquema estrella
\echo ''
\echo '============================================================================'
\echo 'ESTRUCTURA DEL ESQUEMA ESTRELLA'
\echo '============================================================================'

SELECT 
    'DIMENSIONES' as tipo,
    table_name as nombre,
    (SELECT count(*) FROM information_schema.columns WHERE table_name = t.table_name) as num_columnas,
    pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) as tamaño
FROM information_schema.tables t
WHERE table_schema = 'public' AND table_name LIKE 'dim_%'
UNION ALL
SELECT 
    'HECHOS' as tipo,
    table_name,
    (SELECT count(*) FROM information_schema.columns WHERE table_name = t.table_name),
    pg_size_pretty(pg_total_relation_size(quote_ident(table_name)))
FROM information_schema.tables t
WHERE table_schema = 'public' AND table_name LIKE 'hechos_%'
ORDER BY tipo, nombre;
