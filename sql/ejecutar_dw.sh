#!/bin/bash
# ============================================================================
# Script de Demostración y Ejecución del Data Warehouse
# ============================================================================
# Este script verifica el entorno y ejecuta los scripts SQL
# ============================================================================

set -e  # Salir si hay algún error

echo "============================================================================"
echo "Data Warehouse - Depreciación del Euro"
echo "Script de Demostración y Ejecución"
echo "============================================================================"
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# PASO 1: Verificar PostgreSQL
# ============================================================================
echo "📋 Verificando requisitos previos..."
echo ""

if command -v psql &> /dev/null; then
    echo -e "${GREEN}✓${NC} PostgreSQL encontrado"
    PSQL_VERSION=$(psql --version)
    echo "  Versión: $PSQL_VERSION"
    HAS_POSTGRES=true
else
    echo -e "${RED}✗${NC} PostgreSQL no encontrado"
    echo ""
    echo "Para instalar PostgreSQL:"
    echo "  macOS:   brew install postgresql@14"
    echo "  Ubuntu:  sudo apt-get install postgresql-14"
    echo "  Docker:  docker run -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:14"
    echo ""
    HAS_POSTGRES=false
fi

# ============================================================================
# PASO 2: Verificar Python (para demostración alternativa)
# ============================================================================
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓${NC} Python3 encontrado"
    PYTHON_VERSION=$(python3 --version)
    echo "  Versión: $PYTHON_VERSION"
    HAS_PYTHON=true
else
    echo -e "${RED}✗${NC} Python3 no encontrado"
    HAS_PYTHON=false
fi

echo ""
echo "============================================================================"

# ============================================================================
# OPCIÓN A: Ejecutar con PostgreSQL (si está disponible)
# ============================================================================
if [ "$HAS_POSTGRES" = true ]; then
    echo ""
    echo "🚀 PostgreSQL detectado. Opciones de ejecución:"
    echo ""
    echo "  1) Crear base de datos y ejecutar todo el DW"
    echo "  2) Solo ejecutar scripts (asume que la BD ya existe)"
    echo "  3) Ejecutar tests de validación"
    echo "  4) Salir"
    echo ""
    read -p "Selecciona una opción (1-4): " option
    
    case $option in
        1)
            echo ""
            echo "📦 Creando base de datos..."
            read -p "Nombre de la base de datos [fiat_depreciacion_dw]: " DB_NAME
            DB_NAME=${DB_NAME:-fiat_depreciacion_dw}
            
            read -p "Usuario PostgreSQL [postgres]: " DB_USER
            DB_USER=${DB_USER:-postgres}
            
            read -p "Host [localhost]: " DB_HOST
            DB_HOST=${DB_HOST:-localhost}
            
            read -p "Puerto [5432]: " DB_PORT
            DB_PORT=${DB_PORT:-5432}
            
            echo ""
            echo "Creando base de datos $DB_NAME..."
            createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME 2>/dev/null || echo "Base de datos ya existe, continuando..."
            
            echo ""
            echo "🔨 Ejecutando scripts SQL..."
            psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 00_crear_dw_completo.sql
            
            echo ""
            echo -e "${GREEN}✓${NC} Data Warehouse creado exitosamente"
            echo ""
            echo "🧪 ¿Deseas ejecutar los tests de validación? (s/n)"
            read -p "> " run_tests
            
            if [ "$run_tests" = "s" ] || [ "$run_tests" = "S" ]; then
                echo ""
                echo "Ejecutando tests..."
                psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f 99_tests_validacion.sql
            fi
            ;;
        2)
            echo ""
            read -p "Nombre de la base de datos: " DB_NAME
            read -p "Usuario PostgreSQL [postgres]: " DB_USER
            DB_USER=${DB_USER:-postgres}
            
            echo ""
            echo "🔨 Ejecutando scripts SQL..."
            psql -U $DB_USER -d $DB_NAME -f 00_crear_dw_completo.sql
            
            echo ""
            echo -e "${GREEN}✓${NC} Scripts ejecutados"
            ;;
        3)
            echo ""
            read -p "Nombre de la base de datos: " DB_NAME
            read -p "Usuario PostgreSQL [postgres]: " DB_USER
            DB_USER=${DB_USER:-postgres}
            
            echo ""
            echo "🧪 Ejecutando tests de validación..."
            psql -U $DB_USER -d $DB_NAME -f 99_tests_validacion.sql
            ;;
        4)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida"
            exit 1
            ;;
    esac

# ============================================================================
# OPCIÓN B: Demostración sin PostgreSQL
# ============================================================================
else
    echo ""
    echo -e "${YELLOW}⚠${NC}  PostgreSQL no está instalado"
    echo ""
    echo "📖 Mostrando estructura del Data Warehouse..."
    echo ""
    echo "El Data Warehouse incluye:"
    echo ""
    echo "  📊 5 Dimensiones:"
    echo "     - dim_tiempo (5,840+ registros: 2010-2025)"
    echo "     - dim_indicador (17+ indicadores macroeconómicos)"
    echo "     - dim_geografia (20+ geografías: España + CC.AA.)"
    echo "     - dim_unidad (12+ unidades de medida)"
    echo "     - dim_fuente (10+ fuentes de datos)"
    echo ""
    echo "  📈 1 Tabla de Hechos:"
    echo "     - hechos_indicadores_temporales (datos medidos)"
    echo ""
    echo "  🔍 5 Tablas de Auditoría:"
    echo "     - etl_logs"
    echo "     - validacion_calidad"
    echo "     - trazabilidad_transformacion"
    echo "     - datos_rechazados"
    echo "     - metadata_dw"
    echo ""
    echo "  📋 9 Vistas Analíticas predefinidas"
    echo "  ⚙️  2 Funciones SQL personalizadas"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "Para ejecutar el DW, instala PostgreSQL:"
    echo ""
    echo "  🍺 macOS (Homebrew):"
    echo "     brew install postgresql@14"
    echo "     brew services start postgresql@14"
    echo ""
    echo "  🐧 Ubuntu/Debian:"
    echo "     sudo apt-get update"
    echo "     sudo apt-get install postgresql-14"
    echo "     sudo systemctl start postgresql"
    echo ""
    echo "  🐳 Docker (opción rápida):"
    echo "     docker run --name fiat-postgres \\"
    echo "       -e POSTGRES_PASSWORD=postgres \\"
    echo "       -e POSTGRES_DB=fiat_depreciacion_dw \\"
    echo "       -p 5432:5432 -d postgres:14"
    echo ""
    echo "     docker exec -i fiat-postgres \\"
    echo "       psql -U postgres -d fiat_depreciacion_dw \\"
    echo "       < 00_crear_dw_completo.sql"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    # Mostrar contenido de un script de ejemplo
    echo "📄 Vista previa del script de creación de dimensiones:"
    echo ""
    echo "─────────────────────────────────────────────────────────────"
    head -n 30 02_crear_dimensiones.sql | sed 's/^/  /'
    echo "  ..."
    echo "  [Ver archivo completo: 02_crear_dimensiones.sql]"
    echo "─────────────────────────────────────────────────────────────"
    echo ""
    
    # Mostrar esquema estrella en ASCII
    echo "🌟 Esquema Estrella (Diseño Kimball):"
    echo ""
    cat << 'EOF'
                    ┌─────────────────┐
                    │   DIM_TIEMPO    │
                    │  (5,840 días)   │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼─────┐        ┌─────▼──────┐      ┌─────▼─────┐
   │DIM_INDIC │        │DIM_GEOGRA  │      │DIM_UNIDAD │
   │(17 indic)│        │ FIA (20+)  │      │  (12+)    │
   └────┬─────┘        └─────┬──────┘      └─────┬─────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                  ┌──────────▼──────────┐
                  │    HECHOS_          │
                  │   INDICADORES_      │
                  │   TEMPORALES        │
                  │  (Fact Table)       │
                  └──────────┬──────────┘
                             │
                       ┌─────▼─────┐
                       │DIM_FUENTE │
                       │  (10+)    │
                       └───────────┘

  Métricas en Hechos:
    - valor
    - valor_anterior
    - variacion_absoluta
    - variacion_pct
    - calidad_dato
    - probabilidad_imputacion
EOF
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
fi

echo ""
echo "✅ Proceso completado"
echo ""
echo "📚 Archivos SQL disponibles:"
ls -1 *.sql | while read file; do
    size=$(wc -l < "$file")
    echo "   • $file ($size líneas)"
done

echo ""
echo "============================================================================"
echo "Para más información, consulta:"
echo "  - README.md en este directorio"
echo "  - ../PROYECTO.md para especificaciones completas"
echo "============================================================================"
