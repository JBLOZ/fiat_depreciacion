# Macroeconomic Indicators for Spain: Power of Acquisition Analysis (2010-2025)



## Descripción



Almacén de datos integrado que analiza la erosión del poder adquisitivo de las familias 
españolas vinculándolo con depreciación de las monedas fiat (el euro en este caso), 
a partir de datos como la inflación (HICP/IPC), salarios nominales y reales, 
evolución de índices bursátiles (IBEX-35), tipos de cambio EUR/USD y precio del oro.



**Preguntas de investigación:**

- P1: ¿Cómo ha evolucionado el poder adquisitivo real en España (2010-2025)?

- P2: ¿Qué relación existe entre inflación y salarios reales?

- P3: ¿Cómo se correlaciona el oro en EUR con la pérdida de poder adquisitivo?

- P4: ¿Es el IBEX-35 cobertura efectiva contra inflación?

- P5: ¿Cuál ha sido el impacto de depreciación del euro?



## Estructura del Proyecto



Ver archivo `docs/ESTRUCTURA_PROYECTO.md` para detalle completo.



Directorios principales:

- `data/` - Datos raw, processed, e intermedios

- `etl/` - Pipelines Pentaho + Python

- `src/` - Scripts SQL, Python de configuración

- `viz/` - Visualizaciones HTML interactivas

- `schemaorg/` - Transformaciones RDF/JSON-LD

- `docs/` - Documentación completa



## Requisitos y Preparación del Entorno



### Requisitos Previos

- Python 3.9+

- PostgreSQL 12+

- Pentaho Data Integration (Community Edition) 9.0+

- Git





