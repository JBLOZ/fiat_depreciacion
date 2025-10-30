macroeconomia-españa-2024/

│

├── README.md                          # Portada, instrucciones reproducibilidad

├── LICENSE                            # CC-BY-4.0

├── CITATION.cff                       # Cita académica BibTeX

├── requirements.txt                   # Dependencias Python

├── environment.yml                    # Conda environment

├── Makefile                          # Orquestación automática

│

├── data/

│   ├── raw/                          # Datos originales descargados

│   │   ├── ipc\_es\_ine\_2010\_2025.csv

│   │   ├── salarios\_ine\_2010\_2025.csv

│   │   ├── hicp\_eurostat\_2010\_2025.csv

│   │   ├── oro\_usd\_2010\_2025.csv

│   │   ├── eurusd\_2010\_2025.csv

│   │   └── ibex35\_bme\_2010\_2025.csv

│   ├── processed/                     # Datos tras ETL

│   │   ├── ipc\_limpio.csv

│   │   ├── salarios\_deflactados.csv

│   │   ├── oro\_eur\_convertido.csv

│   │   ├── poder\_adquisitivo\_idx.csv

│   │   └── hechos\_indicadores\_temporales.csv

│   └── intermediate/                  # Pasos intermedios ETL

│       ├── paso2\_limpieza.csv

│       ├── paso3\_normalizacion.csv

│       └── validacion\_calidad.log

│

├── etl/

│   ├── pdi/                          # Pentaho Data Integration

│   │   ├── ETL\_MACROECONOMIA\_PIPELINE.kjb  # Job maestro

│   │   ├── 01\_extraccion\_bruto.ktr        # Transformación 1

│   │   ├── 02\_limpieza\_validacion.ktr      # Transformación 2

│   │   ├── 03\_transformacion\_enriquecimiento.ktr

│   │   ├── 04\_deflactacion\_derivados.ktr

│   │   ├── 05\_validacion\_calidad.ktr

│   │   └── 06\_carga\_dw.ktr

│   └── python/                        # Scripts Python complementarios

│       ├── extraccion\_apis.py

│       ├── imputacion\_outliers.py

│       ├── validacion\_estadistica.py

│       └── transformacion\_rdf.py

│

├── src/

│   ├── create\_dw\_schema.sql          # Script DDL Data Warehouse

│   ├── conexiones\_bd.config          # Config BD (gitignored para prod)

│   └── constantes.py                  # Variables globales, configuración

│

├── notebooks/

│   ├── 01\_exploracion\_datos.ipynb    # EDA inicial

│   ├── 02\_análisis\_correlación.ipynb # Análisis estadístico

│   └── 03\_validacion\_dw.ipynb        # Queries al DW

│

├── viz/

│   ├── 01\_poder\_adquisitivo\_lineal.html   # Visualización 1 (Plotly)

│   ├── 02\_correlacion\_oro\_pa.html          # Visualización 2 (Altair)

│   ├── especificaciones/

│   │   ├── viz1\_spec.json

│   │   └── viz2\_spec.json

│   └── data\_for\_viz/

│       ├── poder\_adquisitivo\_ibex\_inflacion.csv

│       └── poder\_adquisitivo\_oro.csv

│

├── schemaorg/

│   ├── observations\_rdf.ttl           # RDF Turtle

│   ├── observations\_rdf.xml           # RDF/XML

│   ├── observations.jsonld            # JSON-LD

│   ├── dataset\_metadata.jsonld        # Metadatos Dataset

│   └── validacion\_grafo.sparql        # Queries SPARQL validación

│

├── docs/

│   ├── MEMORIA\_PRÁCTICA.pdf           # Memoria 8 páginas

│   ├── APARTADO\_1\_definicion.md

│   ├── APARTADO\_2\_datasets.md

│   ├── APARTADO\_3\_diseño\_dw.md

│   ├── APARTADO\_4\_etl\_pentaho.md

│   ├── APARTADO\_5\_schemaorg.md

│   ├── APARTADO\_6\_visualizaciones.md

│   ├── APARTADO\_8\_github.md

│   ├── CAMBIOS.md                    # Redefiniciones de preguntas

│   ├── LIMITACIONES.md               # Limitaciones metodológicas

│   ├── TRABAJO\_FUTURO.md             # Sugerencias mejoras

│   └── REFERENCIAS.bib               # Bibliografía BibTeX

│

├── tests/

│   ├── test\_calidad\_datos.py         # Tests unitarios validación

│   ├── test\_transformaciones.py       # Tests ETL

│   └── test\_dw\_integridad.sql        # Tests BD integridad

│

├── outputs/

│   ├── logs/

│   │   ├── etl\_execution\_2024\_12\_15.log

│   │   └── validation\_report\_2024\_12\_15.csv

│   ├── reports/

│   │   ├── calidad\_datos\_resumen.xlsx

│   │   ├── duplicados\_conflictivos.csv

│   │   └── outliers\_detectados.csv

│   └── artifacts/

│       ├── dw\_schema\_diagram.png

│       └── pipeline\_flujo.png

│

├── .github/

│   └── workflows/

│       └── etl\_pipeline.yml          # CI/CD (ejecutar ETL automático)

│

├── .gitignore                         # Excluir datos sensibles, config local

└── Dockerfile                         # Reproducibilidad en contenedor





