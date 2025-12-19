# Proyecto: Depreciación del euro y erosión del poder adquisitivo en España

## 1. Introducción y contexto

Durante el período 2010–2025, la economía española ha estado marcada por una combinación de crisis financieras, políticas monetarias expansivas, shocks externos (crisis de deuda europea, pandemia de la COVID‑19, tensiones geopolíticas) y un repunte inflacionario significativo en los últimos años. En este contexto, uno de los fenómenos más relevantes desde el punto de vista social y económico es la pérdida progresiva de poder adquisitivo de los hogares.

Este proyecto aborda dicho problema desde una perspectiva de **adquisición, preparación y análisis de datos**, integrando múltiples fuentes económicas y financieras para estudiar la relación entre inflación, salarios, depreciación del euro y activos financieros como el IBEX‑35 y el oro.

El trabajo se desarrolla como un proyecto **grupal**, con un enfoque mixto **académico y técnico‑práctico**, alineado con los objetivos de la asignatura *Adquisición y Preparación de Datos*.

---

## 2. Objetivos del proyecto

### Objetivo general

Diseñar y construir un pipeline completo de datos que permita analizar la evolución del poder adquisitivo en España entre 2010 y 2025, integrando indicadores macroeconómicos, transformándolos en un almacén de datos analítico y generando visualizaciones que faciliten su interpretación económica.

### Objetivos específicos

- Seleccionar y justificar conjuntos de datos económicos relevantes.
- Limpiar, normalizar y enriquecer datos heterogéneos mediante Python y Pentaho Data Integration.
- Diseñar un modelo de datos orientado al análisis (hechos y dimensiones).
- Implementar un proceso ETL reproducible.
- Realizar análisis y visualizaciones que respondan a preguntas económicas concretas.
- Transformar parte de los datos a formato semántico usando `schema.org`.

---

## 3. Fuentes de datos

El proyecto integra datos procedentes de fuentes públicas y abiertas, principalmente:

- Instituto Nacional de Estadística (INE): IPC, salarios, empleo y desempleo.
- Banco Central Europeo (BCE): tipo de cambio EUR/USD.
- Mercados financieros y proveedores abiertos: IBEX‑35 y precio del oro.

Los datos originales se almacenan en formato CSV y cubren, según el indicador, periodos anuales, trimestrales o diarios. Todos los conjuntos de datos han sido revisados para garantizar consistencia temporal y coherencia de unidades.

---

## 4. Arquitectura del proyecto

El repositorio se estructura de forma modular para reflejar el flujo completo del proyecto:

- `datos/`: datos procesados listos para análisis y carga.
- `scripts/`: scripts Python para descarga, limpieza y generación de indicadores.
- `pentajo/`: transformaciones ETL implementadas con Pentaho.
- `sql/`: esquema del almacén de datos y backups.
- `notebooks/`: análisis exploratorio, visualizaciones y transformación semántica.
- `docs/`: material gráfico y documentación de apoyo.

Esta estructura permite separar claramente las fases de adquisición, preparación, análisis y documentación.

---

## 5. Preparación de datos y ETL

La preparación de datos se ha realizado combinando **scripts en Python** y **procesos ETL en Pentaho Data Integration**.

### Limpieza y normalización

Las tareas principales incluyen:

- Corrección de formatos de fecha y valores numéricos.
- Gestión de valores faltantes mediante imputación simple o arrastre temporal.
- Eliminación de duplicados y validación de rangos plausibles.
- Homogeneización de unidades y frecuencias temporales.

### Generación de indicadores

A partir de los datos base se han generado indicadores derivados, como:

- Salarios reales (deflactados por IPC).
- Índices base 100.
- Rentabilidades reales del IBEX‑35.
- Conversión del precio del oro de USD a EUR usando el tipo de cambio diario.

### Carga en el almacén de datos

Los datos transformados se cargan en un modelo analítico mediante Pentaho, quedando listos para su explotación y análisis posterior.

---

## 6. Modelo de datos

Se ha diseñado un modelo orientado al análisis temporal, con:

- **Tabla de hechos**: observaciones económicas (valor del indicador en una fecha).
- **Dimensiones**: tiempo, indicador, geografía, fuente y unidad.

Este enfoque facilita consultas analíticas, agregaciones temporales y comparaciones entre indicadores.

---

## 7. Análisis y visualizaciones

El análisis final se realiza en notebooks de Python, utilizando los datos ya procesados. Entre los resultados principales destacan:

- Evolución del poder adquisitivo real frente a la inflación.
- Comparación entre salarios reales y rendimientos financieros.
- Análisis del comportamiento del oro como activo refugio.

Las visualizaciones generadas permiten identificar periodos de mayor pérdida de poder adquisitivo y relacionarlos con eventos macroeconómicos relevantes.

---

## 8. Transformación semántica

Como parte del proyecto, se ha realizado una transformación de los datos a formato semántico utilizando `schema.org`. Esta fase incluye:

- Definición de clases como `Dataset`, `Observation`, `Organization` y `Place`.
- Generación de un archivo JSON‑LD (`output_schema.jsonld`).
- Validación básica de la estructura semántica.

Este apartado cumple el requisito académico de reutilización y estandarización de datos.

---

## 9. Resultados y conclusiones

El análisis muestra una pérdida acumulada de poder adquisitivo en España a lo largo del período estudiado, especialmente acentuada en los años de alta inflación reciente. Los salarios nominales no han compensado completamente el aumento de precios, mientras que ciertos activos financieros han ofrecido protección parcial frente a la inflación.

El proyecto demuestra la utilidad de integrar múltiples fuentes de datos y aplicar técnicas de preparación rigurosas para obtener conclusiones económicas fundamentadas.

---

## 10. Limitaciones y trabajo futuro

Entre las principales limitaciones se encuentran:

- Diferencias de frecuencia temporal entre indicadores.
- Dependencia de revisiones estadísticas oficiales.
- Simplificación en algunos procesos de imputación.

Como trabajo futuro, el proyecto podría ampliarse con modelos predictivos, mayor desagregación geográfica o integración de nuevas fuentes de datos.

---

## 11. Conclusión final

Este proyecto refleja un flujo completo de adquisición, preparación y análisis de datos aplicado a un problema económico real, combinando rigor académico con una implementación técnica reproducible y bien estructurada.