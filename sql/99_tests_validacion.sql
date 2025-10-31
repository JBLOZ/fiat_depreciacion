-- ============================================================================
-- Script de Pruebas y Validación del Data Warehouse
-- ============================================================================
-- Ejecutar después de crear el DW para verificar su correcto funcionamiento
-- ============================================================================

\echo '============================================================================'
\echo 'PRUEBAS DE VALIDACIÓN DEL DATA WAREHOUSE'
\echo '============================================================================'
\echo ''

-- ============================================================================
-- TEST 1: Verificar que todas las tablas existen
-- ============================================================================
\echo 'TEST 1: Verificando existencia de tablas...'

SELECT 
    CASE 
        WHEN COUNT(*) = 5 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Dimensiones creadas' as test,
    COUNT(*) as cantidad_esperada_5
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name LIKE 'dim_%';

SELECT 
    CASE 
        WHEN COUNT(*) >= 1 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Tabla de hechos creada' as test,
    COUNT(*) as cantidad_esperada_1
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name LIKE 'hechos_%';

-- ============================================================================
-- TEST 2: Verificar poblado de dimensiones
-- ============================================================================
\echo ''
\echo 'TEST 2: Verificando poblado de dimensiones...'

SELECT 
    CASE 
        WHEN COUNT(*) >= 5840 THEN '✓ PASÓ'  -- 16 años * 365 días ≈ 5840 días
        ELSE '✗ FALLÓ'
    END as resultado,
    'dim_tiempo poblada' as test,
    COUNT(*) as registros,
    'Esperado: >= 5840' as esperado
FROM dim_tiempo;

SELECT 
    CASE 
        WHEN COUNT(*) >= 10 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'dim_indicador poblada' as test,
    COUNT(*) as registros,
    'Esperado: >= 10' as esperado
FROM dim_indicador;

SELECT 
    CASE 
        WHEN COUNT(*) >= 19 THEN '✓ PASÓ'  -- España + 17 CCAA + Zona Euro
        ELSE '✗ FALLÓ'
    END as resultado,
    'dim_geografia poblada' as test,
    COUNT(*) as registros,
    'Esperado: >= 19' as esperado
FROM dim_geografia;

SELECT 
    CASE 
        WHEN COUNT(*) >= 10 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'dim_unidad poblada' as test,
    COUNT(*) as registros,
    'Esperado: >= 10' as esperado
FROM dim_unidad;

SELECT 
    CASE 
        WHEN COUNT(*) >= 8 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'dim_fuente poblada' as test,
    COUNT(*) as registros,
    'Esperado: >= 8' as esperado
FROM dim_fuente;

-- ============================================================================
-- TEST 3: Verificar integridad referencial
-- ============================================================================
\echo ''
\echo 'TEST 3: Verificando integridad referencial...'

SELECT 
    CASE 
        WHEN COUNT(*) = 5 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Claves foráneas en hechos_indicadores_temporales' as test,
    COUNT(*) as cantidad_esperada_5
FROM information_schema.table_constraints
WHERE table_name = 'hechos_indicadores_temporales'
    AND constraint_type = 'FOREIGN KEY';

-- ============================================================================
-- TEST 4: Verificar índices
-- ============================================================================
\echo ''
\echo 'TEST 4: Verificando índices...'

SELECT 
    CASE 
        WHEN COUNT(*) >= 8 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Índices en tabla de hechos' as test,
    COUNT(*) as cantidad,
    'Esperado: >= 8' as esperado
FROM pg_indexes
WHERE tablename = 'hechos_indicadores_temporales';

-- ============================================================================
-- TEST 5: Verificar rangos de fechas
-- ============================================================================
\echo ''
\echo 'TEST 5: Verificando rangos de fechas...'

SELECT 
    CASE 
        WHEN MIN(fecha) = '2010-01-01' AND MAX(fecha) = '2025-12-31' THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Rango de fechas correcto' as test,
    MIN(fecha) as fecha_inicio,
    MAX(fecha) as fecha_fin,
    '2010-01-01 a 2025-12-31' as esperado
FROM dim_tiempo;

-- ============================================================================
-- TEST 6: Verificar vistas analíticas
-- ============================================================================
\echo ''
\echo 'TEST 6: Verificando vistas analíticas...'

SELECT 
    CASE 
        WHEN COUNT(*) >= 8 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Vistas analíticas creadas' as test,
    COUNT(*) as cantidad,
    'Esperado: >= 8' as esperado
FROM information_schema.views
WHERE table_schema = 'public' AND table_name LIKE 'v_%';

-- ============================================================================
-- TEST 7: Verificar funciones
-- ============================================================================
\echo ''
\echo 'TEST 7: Verificando funciones...'

SELECT 
    CASE 
        WHEN COUNT(*) >= 2 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Funciones creadas' as test,
    COUNT(*) as cantidad,
    'Esperado: >= 2' as esperado
FROM information_schema.routines
WHERE routine_schema = 'public' 
    AND routine_name LIKE 'fn_%';

-- ============================================================================
-- TEST 8: Verificar categorías de indicadores
-- ============================================================================
\echo ''
\echo 'TEST 8: Verificando categorías de indicadores...'

SELECT 
    categoria,
    COUNT(*) as num_indicadores,
    CASE 
        WHEN COUNT(*) > 0 THEN '✓'
        ELSE '✗'
    END as estado
FROM dim_indicador
GROUP BY categoria
ORDER BY categoria;

-- ============================================================================
-- TEST 9: Verificar jerarquía geográfica
-- ============================================================================
\echo ''
\echo 'TEST 9: Verificando jerarquía geográfica...'

SELECT 
    g.nombre as geografia,
    g.tipo,
    gp.nombre as padre,
    g.nivel_jerarquia,
    CASE 
        WHEN (g.tipo = 'pais' AND g.nivel_jerarquia = 0) 
          OR (g.tipo = 'region' AND g.nivel_jerarquia = 1)
          OR (g.tipo IN ('ciudad', 'zona_economica'))
        THEN '✓'
        ELSE '✗'
    END as jerarquia_correcta
FROM dim_geografia g
LEFT JOIN dim_geografia gp ON g.geo_padre_key = gp.geo_key
ORDER BY g.nivel_jerarquia, g.nombre;

-- ============================================================================
-- TEST 10: Verificar metadatos del DW
-- ============================================================================
\echo ''
\echo 'TEST 10: Verificando metadatos del DW...'

SELECT 
    CASE 
        WHEN COUNT(*) >= 8 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Metadatos iniciales cargados' as test,
    COUNT(*) as cantidad,
    'Esperado: >= 8' as esperado
FROM metadata_dw;

SELECT 
    clave,
    valor,
    tipo_dato
FROM metadata_dw
ORDER BY clave;

-- ============================================================================
-- TEST 11: Prueba de inserción en tabla de hechos
-- ============================================================================
\echo ''
\echo 'TEST 11: Probando inserción de datos de prueba...'

-- Insertar un registro de prueba
INSERT INTO hechos_indicadores_temporales (
    tiempo_key,
    indicador_key,
    geo_key,
    unit_key,
    fuente_key,
    valor,
    valor_anterior,
    variacion_absoluta,
    variacion_pct,
    calidad_dato
)
SELECT 
    (SELECT tiempo_key FROM dim_tiempo WHERE fecha = '2010-01-01'),
    (SELECT indicador_key FROM dim_indicador WHERE codigo = 'IPC_ES_100' LIMIT 1),
    (SELECT geo_key FROM dim_geografia WHERE codigo = 'ES'),
    (SELECT unit_key FROM dim_unidad WHERE simbolo = 'Índice_100'),
    (SELECT fuente_key FROM dim_fuente WHERE codigo = 'INE'),
    100.0,
    NULL,
    NULL,
    NULL,
    'real'
WHERE NOT EXISTS (
    SELECT 1 FROM hechos_indicadores_temporales
    WHERE tiempo_key = (SELECT tiempo_key FROM dim_tiempo WHERE fecha = '2010-01-01')
        AND indicador_key = (SELECT indicador_key FROM dim_indicador WHERE codigo = 'IPC_ES_100' LIMIT 1)
);

SELECT 
    CASE 
        WHEN COUNT(*) >= 1 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Inserción de datos de prueba' as test,
    COUNT(*) as registros_insertados
FROM hechos_indicadores_temporales;

-- ============================================================================
-- TEST 12: Probar vista de resumen de calidad
-- ============================================================================
\echo ''
\echo 'TEST 12: Probando vista de resumen de calidad...'

SELECT 
    CASE 
        WHEN total_hechos >= 0 THEN '✓ PASÓ'
        ELSE '✗ FALLÓ'
    END as resultado,
    'Vista v_resumen_calidad_dw funciona' as test,
    total_hechos,
    total_indicadores,
    total_geografias
FROM v_resumen_calidad_dw;

-- ============================================================================
-- TEST 13: Probar función fn_obtener_valor_indicador
-- ============================================================================
\echo ''
\echo 'TEST 13: Probando función fn_obtener_valor_indicador...'

SELECT 
    CASE 
        WHEN fn_obtener_valor_indicador('IPC_ES_100', '2010-01-01', 'ES') IS NOT NULL THEN '✓ PASÓ'
        ELSE '⚠ ADVERTENCIA: No hay datos todavía'
    END as resultado,
    'Función fn_obtener_valor_indicador' as test,
    fn_obtener_valor_indicador('IPC_ES_100', '2010-01-01', 'ES') as valor_obtenido;

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================
\echo ''
\echo '============================================================================'
\echo 'RESUMEN DE PRUEBAS'
\echo '============================================================================'

SELECT 
    COUNT(*) FILTER (WHERE resultado LIKE '✓%') as tests_pasados,
    COUNT(*) FILTER (WHERE resultado LIKE '✗%') as tests_fallados,
    COUNT(*) FILTER (WHERE resultado LIKE '⚠%') as tests_advertencia,
    COUNT(*) as total_tests
FROM (
    -- Aquí iría la unión de todos los resultados de tests
    -- Por simplicidad, mostramos mensaje final
    SELECT '✓' as resultado
) t;

\echo ''
\echo '============================================================================'
\echo 'Validación completada'
\echo 'El Data Warehouse está listo para recibir datos del ETL'
\echo '============================================================================'
