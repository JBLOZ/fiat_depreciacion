# Enunciado de la práctica a realizar durante el curso

**Asignatura:** Adquisición y preparación de datos  
**Grado:** Ingeniería en Inteligencia Artificial  
**Universidad de Alicante - Escuela Politécnica Superior**  
[Descarga del enunciado en PDF](https://moodle2025-26.ua.es/moodle/pluginfile.php/113944/mod_page/content/9/apd-enunciado-practica.pdf)

## Introducción

Esta práctica tiene como objetivo la reutilización de contenidos en forma de datos por parte de instituciones públicas, organismos de patrimonio cultural, asociaciones o infraestructuras europeas. Los contenidos y datos proporcionados son de diferente tipo y formato, e incluyen información relacionada con la movilidad, patrimonio cultural o turismo. En algunos casos, los datos están disponibles en forma de carpeta comprimida (p.ej., zip) mientras que en otros pueden estar disponibles a través de un API.

## Resumen de los apartados

1. **Selecciona una temática:** patrimonio cultural, turismo, movilidad, medio ambiente, etc.  
   Identifica preguntas para solucionar un problema concreto.  
   Ejemplo: ¿en qué medida ha mejorado Alicante en materia de movilidad en los últimos años?  
2. **Selecciona conjuntos de datos** relevantes para aportar respuesta. Si se modifica la pregunta, describir los cambios.
3. **Diseña el almacén de datos:** diseño conceptual, lógico y físico según la temática.
4. **Extrae y prepara los datos:** limpieza e integración, enriquecimiento con repositorios externos (ej: latitud/longitud). Usa herramientas o código.
5. **Transforma los datos** (o parte) a tripletas usando [schema.org](http://schema.org/). Valida y justifica las clases y propiedades usadas.
6. **Implementa dos visualizaciones** que respondan a las preguntas del punto 1 (mapas, gráficas, líneas de tiempo, etc).
7. **Crea una memoria** (Word/PDF) resumen y presentación final grupal.
8. **Repositorio GitHub:** incluye conjunto de datos, código, README.md y visualizaciones.

---

## Evaluación

- Apartado 1: 10%  
- Apartado 2: 10%  
- Apartado 3: 15%  
- Apartado 4: 20%  
- Apartado 5: 10%  
- Apartado 6: 10%  
- Apartado 7: 10%  
- Apartado 8: 5%

## Entrega

La entrega debe incluir los datos, el código generado y la memoria. Entrega vía Moodle UAcloud.  
**Fecha límite: 22 de diciembre de 2025**

## Notas adicionales

El enunciado puede ser modificado durante el curso. Descarga la versión actualizada regularmente. El profesor avisará en clase de cualquier cambio.

---

# Apartado 1: Definición del proyecto centrado en los datos (10%)

**Descripción:**  
Selecciona una temática (patrimonio cultural, turismo, movilidad, medio ambiente, etc) y plantea preguntas concretas sobre un problema. Ejemplo: ¿Cómo ha evolucionado Alicante en movilidad?  
**Tareas:**  
- Selección de temática/domino del proyecto  
- Identificación del problema a resolver (4W: Who, What, Where, Why)  
- Objetivos del proyecto  
- Casos de uso  
- Métricas clave según objetivos/casos de uso

# Apartado 2: Analizar y evaluar necesidades de datos (10%)

**Descripción:**  
Selecciona varios conjuntos de datos alineados con la temática y preguntas. Redefinir preguntas si los datos lo exigen y describe cambios.  
**Tareas:**  
- Analizar necesidades de datos (tipo, formato, fuentes)  
- Justificar uso de datos ficticios si es necesario  
- Selección de los conjuntos de datos más adecuados

# Apartado 3: Diseño conceptual, lógico y físico del almacén de datos (15%)

**Descripción:**  
Elabora el diseño conceptual, lógico y físico del almacén de datos de la temática elegida.  
**Tareas:**  
- Diseño conceptual  
- Diseño lógico  
- Diseño físico  
Incluye documentación y esquemas, junto con el script de creación.

# Apartado 4: Limpieza, transformación y normalización de datos (20%)

**Descripción:**  
Extrae y prepara los datos para su reutilización, integrando conjuntos y enriqueciendo con información externa.  
**Tareas:**  
1. Usar Pentaho Data Integration para extracción, limpieza, transformación y normalización, incluyendo:
   - Conexión con fuentes de datos (BD, fichero, web)
   - Fusión y filtrado de fuentes de datos
2. Tareas obligatorias:
   - Corregir errores
   - Gestionar valores faltantes
   - Reducir redundancia
   - Feature Engineering (creación/codificación de nuevas características, binning, one-hot encoding)
   - Enriquecimiento
   - Tratamiento de outliers
   - Validación
3. Diseñar el workflow (job) con Pentaho para gestionar transformaciones  
*Código adicional en Python permitido según necesidad*

# Apartado 5: Transformación según schema.org (10%)

**Descripción:**  
Transforma los datos a tripletas usando [schema.org](http://schema.org/), diseña clases y propiedades acordes, valida y justifica.  
- Consulta clases/propiedades como: [Person](https://schema.org/Person), [Event](https://schema.org/Event), [Place](https://schema.org/Place), etc.
- Posible uso de Java, Python, OpenRefine
- Valora el enriquecimiento con repositorios externos (Wikidata, vocabularios controlados)
- Verifica la calidad (registros, clases, propiedades)

# Apartado 6: Visualización (10%)

**Descripción y tareas:**  
Implementa dos visualizaciones que respondan a las preguntas iniciales.  
Opciones: mapas, gráficas, líneas de tiempo.  
Puedes usar código propio o servicios/aplicaciones externas.

# Apartado 7: Memoria y presentación (10%)

**Descripción y tareas:**  
Resume en un documento (máx. 8 páginas) con portada de autores y resumen de cada apartado.  
Presentación en clase de todo el grupo.

# Apartado 8: Repositorio de código (5%)

**Descripción y tareas:**  
Repositorio GitHub con:
- Datos y transformaciones
- README.md (descripción del trabajo)
- Visualizaciones y código
- Licencia de uso y referencias empleadas

---

**Última modificación:** jueves, 23 de octubre de 2025, 19:19
