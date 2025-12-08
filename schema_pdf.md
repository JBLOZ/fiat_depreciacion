Aquí tienes el texto del PDF "apd-25-26-tema8_moodle.pdf" para copiar y pegar:

***

APD-IA-datos-2  
Transformación y enriquecimiento de datos  
Adquisición y preparación de datos  
Contenido  
Web Semántica y Linked Open Data  
Wikidata  
Consultas con SPARQL  
Ontologías y vocabularios/taxonomías  
Schema.org  
Otros ejemplos  
Transformación de datos  
Tecnologías  
Ejemplos  
Reutilización  
Calidad de datos  
Visualización  
Retrieval-Augmented Generation

Web semántica y Linked Open Data  
W3C Slide1  
Source of slides  
The Semantic Web DAML 2000 August 15  
Tim Berners-Lee, Dan Connolly, Lynn Andrea Stein, Ralph Swick  
http://www.w3.org/2000/Talks/0815-daml-sweb-tbl  
This text corresponds approximately to the intent of the slides.

Semantic Web  
Extensión de la Web tradicional para dotarla de significado y pueda ser entendida por máquinas y humanos  
http://www.w3.org/2000/Talks/0906-xmlweb-tbl/text.htm

The essential property of the World Wide Web is its universality.  
The power of a hypertext link is that anything must be able to link to anything.  
This requires that anything must be able to be put on the web.  
The web technology, then, must not discriminate between cultures, between media, between the scribbled draft and the polished performance, between commercial and academic information, and so on.

Information varies along many axes.  
One of these is the difference between information produced primarily for human consumption, and that produced primarily for machines.  
At one end of the scale we have the 5 second TV commercial and poetry.  
At the other end we have the database.

To date, the web has developed most rapidly as a medium of documents for people rather than data which can be processes automatically.

In this article we look toward the Semantic Web, in which data with well defined meaning is exchanged, and computers and people work side by side in cooperation.

Weblike  
We are looking for a web in which data has processable qualities typical of databases and mathematical formulae, but which is still weblike.

Weblike things are, like the Internet, decentralized.  
They typically involve a lot of fun at every level, and provide benefits on a macroscopic scale which are hard or impossible to predict in advance.

To actually build such systems typically requires some compromises, just as the Web initially had to throw away the ideal of total consistency, thus ushering the infamous Error 404 not found message but allowing unchecked exponential uncontrolled growth.

The semantic web must be weblike in that, to be universal -- to ask any information which may be useful to be easily available -- it must be minimally constraining.  
Like good government, it must require only that which is essential for everything to work.

If you think of the web today as turning all the documents in the world into one big book, then think of the Semantic Web as turning all the data into one big database, or one big mathematical formula.

The semantic web is not a separate web; it is a new form of information adding one more dimension to the diversity of the one web we have today.

First level RDF  
Two important technologies for the semantic web are already in place.

The XML language for expressing information gives the community a common way of creating structured documents, though it doesn’t have a way of saying in any sense what they mean.

However, a starting point for talking about meaning comes from developments in the metadata world of information about information such as library cards and catalogs of web resources.

This was the initial impetus behind the development of the Resource Description Framework (RDF) which provides a simple model of conveying the meaning of information as sets of triples, rather like the subject, verb and object in a sentence.

Web semántica y Linked Open Data  
Tecnologías y estándares  
User interface and applications  
Proof  
Trust  
Unified Logic Rules  
RIF/SWRL  
Taxonomies  
RDFS  
Ontologías  
Consultas  
OWL  
Querying  
SPARQL  
Identificadores  
Data interchange  
RDF Syntax/XML  
Identifiers  
URI  
Character Set  
UNICODE  
https://en.wikipedia.org/wiki/SemanticWebStack

Cryptography

Tripletas  
Web semántica y Linked Open Data  
Tecnologías y estándares  
SPARQL, OWL, RDF, URIs

1 Ontologías y vocabularios  
Vocabularios promovidos por instituciones como IFLA, W3C, DARIAH

2 Enriquecimiento  
owl:sameAs  
skos:exactMatch  
wdt:P2799

3 https://5stardata.info/es

Web semántica y Linked Open Data  
Cuando trabajamos con RDF, la información se almacena en forma de tripletas, en forma de Sujeto-Predicado-Objeto.

es:autor  
Sujeto  
Predicado  
Objeto

Web semántica y Linked Open Data  
Se usan URIs para identificar a los recursos y a las propiedades.  
https://data.cervantesvirtual.com/person/40  
https://data.cervantesvirtual.com/manifestation/238924

Web semántica y Linked Open Data  
Tecnologías y estándares  
SPARQL, OWL, RDF, URIs

1 Ontologías y vocabularios  
2 Enriquecimiento  
owl:sameAs  
skos:exactMatch  
wdt:P2799

Web semántica y Linked Open Data  
https://schema.org/author  
https://data.cervantesvirtual.com/person/40  
https://data.cervantesvirtual.com/manifestation/238924  
https://schema.org/name  
Miguel de Cervantes  
https://schema.org/title  
El Quijote

Podemos describir los recursos usando ontologías como Schema.org

Web semántica y Linked Open Data  
Podemos especificar el tipo de los recursos y usar espacios de nombres, p.ej. schema en lugar de https://schema.org  
schema:author  
https://data.cervantesvirtual.com/person/40  
https://data.cervantesvirtual.com/manifestation/238924  
schema:name  
Miguel de Cervantes  
schema:title  
El Quijote  
rdf:type  
schema:Person

Web semántica y Linked Open Data  
Tecnologías y estándares  
SPARQL, OWL, RDF, URIs

1 Ontologías y vocabularios  
2 Enriquecimiento  
owl:sameAs  
skos:exactMatch  
wdt:P2799

Web semántica y Linked Open Data  
Podemos enriquecer los recursos con la propiedad owl:sameAs  
schema:author  
https://data.cervantesvirtual.com/person/40  
https://data.cervantesvirtual.com/manifestation/238924  
schema:name  
Miguel de Cervantes  
schema:title  
El Quijote  
rdf:type  
schema:CreativeWork  
owl:sameAs  
https://www.wikidata.org/entity/Q5682

LOD  
Web semántica y Linked Open Data  
https://lod-cloud.net  
Nov, 2025  
1678 repositorios  
Legend  
Cross Domain  
Geography  
Government  
Life Sciences  
Linguistics  
Media  
Publications  
Social Networking  
User Generated

The Linked Open Data Cloud from lod-cloud.net

Web semántica y Linked Open Data  
Data Foundry  
Data collections from the National Library of Scotland  
https://doi.org/10.5281/zenodo.8051036

LIBRARY  
LIBRARY OF CONGRESS LABS  
https://id.loc.gov

KUNGL. BIBLIOTEK  
National Library of Sweden  
https://libris.kb.se/sparql

europeana pro  
https://pro.europeana.eu/page/apis

SAAM  
https://americanart.si.edu/about/lod

1640  
DATOS-BNE-ES  
https://datos.bne.es

BnF Data  
https://data.bnf.fr

KB LAB  
https://data.bibliotheken.nl

CENTRO BIBLIOTECA VIRTUAL MIGUEL DE CERVANTES  
https://data.cervantesvirtual.com

n  
B  
Bibliothèque nationale du Luxembourg Open Data  
https://data.bnl.lu

DEUTSCHE NATIONAL BIBLIOTHEK  
https://www.dnb.de/EN/lds

THE NATIONAL LIBRARY OF FINLAND  
https://data.nationallibrary.fi

BRITISH LIBRARY  
https://bl.natbib-lod.org

österreichische Nationalbibliothek  
https://labs.onb.ac.at/en/dataset/lod

Datos estructurados  
Dominio público  
Editado por la comunidad  
Basado en estándares  
Multilingüe

Wikidata  
Wikidata Representación en forma de tripleta  
https://www.wikidata.org/wiki/Q5682

wd:Q5682  
1547  
wdt:P569  
Miguel de Cervantes nació en 1547

Uso de identificadores únicos para entidades y propiedades  
Sujeto - Predicado - Objeto

Wikidata Representación en forma de grafo  
wd:Q5682  
wdt:P18  
wd:Q5 ser humano  
wdt:P31  
wd:Q5 masculino  
wdt:P21  
1547  
wdt:P569  
https://www.wikidata.org/wiki/Q5682

Wikidata  
Espacios de nombre  
wd:Q5682  
wdt:P18  
wd:Q5 ser humano  
wdt:P31  
wd:Q5 masculino  
wdt:P21  
1547  
wdt:P569

wd http://www.wikidata.org/entity  
wd:Q5682  
http://www.wikidata.org/entity/Q5682

wdt http://www.wikidata.org/prop/direct  
wdt:P31  
http://www.wikidata.org/prop/direct/P31

https://www.mediawiki.org/wiki/Wikibase/Indexing/RDFDumpFormat#Full_list_of_prefixes

Podemos usar los prefijos wd y wdt en lugar de la URL completa

Consultas con SPARQL  
Introducción  
PREFIX ex: <http://example.org/>  
SELECT * WHERE { ?s ?p ?o }

Espacios de nombre a usar en la sentencia  
Selección de columnas. Un * se refiere a todas  
Tripletas para restricciones. Las que empiezan con ? las interpreta como variables

Consultas con SPARQL  
¿Qué estructura tienen los datos?  
Revisar las propiedades utilizadas para describir los metadatos  
Obtener las clases y propiedades mediante sentencias SPARQL  
SELECT DISTINCT ?class WHERE { ?subject a ?class . }  
FILTER REGEX(?class, "rda")  
LIMIT 100

https://data.cervantesvirtual.com/sparql  
https://datos.bne.es/sparql  
https://www.wikidata.org/wiki/Wikidata:List_of_properties

Consultas con SPARQL  
Introducción  
SELECT ?autor ?idbvmc WHERE { ?autor wdt:P2799 ?idbvmc }  
LIMIT 10

?autor devuelve el identificador del recurso en Wikidata  
Propiedad que enlaza autores de la BVMC en Wikidata  
https://www.wikidata.org/wiki/Property:P2799

Consultas con SPARQL  
Introducción  
SELECT ?autor ?autorLabel ?idbvmc WHERE {  
?autor wdt:P2799 ?idbvmc .  
SERVICE wikibase:label { bd:serviceParam wikibase:language "es". }  
LIMIT 10

Si añadimos Label al nombre de la variable automáticamente nos recupera la etiqueta del recurso.  
?autor devuelve el identificador del recurso  
Añadimos esta instrucción para poder tener acceso a las etiquetas de forma más sencilla.  
AUTOLANGUAGE se refiere al idioma del navegador

Consultas con SPARQL  
Introducción  
SELECT ?autor ?autorLabel ?idbvmc ?fechaNacimiento WHERE {  
?autor wdt:P2799 ?idbvmc .  
?autor wdt:P569 ?fechaNacimiento  
FILTER( "1500-01-01"^^xsd:dateTime < ?fechaNacimiento && ?fechaNacimiento < "1550-01-01"^^xsd:dateTime ) .  
SERVICE wikibase:label { bd:serviceParam wikibase:language "es". }  
LIMIT 10

Instrucción FILTER permite aplicar filtros

Consultas con SPARQL  
Uso avanzado  
- Operadores Values y Bind  
- asignar uno o más valores específicos a una variable  
- asignar el resultado de una expresión a una variable  
- Service - consultas federadas entre repositorios de datos SPARQL  
- Visualizaciones en Wikidata - defaultViewMap, defaultViewGraph  
- Expresiones regulares  
- FILTER regex(?x, pattern, flags)  
- FILTER regex(?nombre, "g", "i") la variable ?nombre contiene el texto g o G  
- Limit y offset paginación resultados

Más ejemplos de SPARQL

Ontologías y vocabularios  
¿Qué es una ontología?  
ontología  
Artículo  
Del lat. mod. ontologia, de onto- (onto-) y -logia (-logía).  
D  
Sinónimos o afines  
1. f. Fil. Parte de la metafísica que trata del ser en general y de sus propiedades trascendentales.  
SIN. metafísica, filosofía.  
Diccionario de la lengua española  
2. f. En ciencias de la comunicación y en inteligencia artificial, red o sistema de datos que define las relaciones existentes entre los conceptos de un dominio o área del conocimiento.

Clases y propiedades para describir los recursos

Ontologías y vocabularios  
Ontologías para modelar y describir la información  
https://www.loc.gov/bibframe  
https://schema.org  
https://repository.ifla.org/handle/123456789/40  
https://pro.europeana.eu/page/edm-documentation  
https://www.cidoc-crm.org  
http://www.rdaregistry.info  
https://www.w3.org/TR/vocab-dcat-3

Ontologías y vocabularios  
¿Qué es una vocabulario o taxonomía?  
taxonomía  
Artículo  
Del gr. txis (ordenación) y -noma.  
Sinónimos o afines  
1. f. Ciencia que trata de los principios, métodos y fines de la clasificación.  
Se aplica en particular, dentro jerarquizada y sistemática, con sus nombres, de los grupos de animales y de vegetales.  
Diccionario de la lengua española  
2. f. clasificación, acción de clasificar.  
SIN. clasificación, categorización, sistemática.

Trminos para describir y clasificar los recursos

The LIBRARY of CONGRESS  
ASK A LIBRARIAN  
DIGITAL COLLECTIONS  
LIBRARY CATALOGS  
Search  
GO

Ontologías y vocabularios  
C TADIRAH  
THE TAXONOMY OF DIGITAL RESEARCH ACTIVITIES IN THE HUMANITIES  
https://skos.um.es/unesco600.html  
SKOS  
Nomenclatura de Ciencia y Tecnología de la UNESCO  
The Library of Congress  
Cataloging, Acquisitions  
Library of Congress Subject Headings  
PDF Files  
CATALOGING AND ACQUISITIONS  
Cataloging and Acquisitions Home  
About the Organization  
Contact  
FAQS  
News  
Acquisitions Resources for Cataloging  
Catalogs, Authority Records  
Classification and Shelflisting  
Cooperative Cataloging Programs  
Descriptive Cataloging  
Products for Purchase  
Publications, Reports  
Subject Headings  
Genre/Form Terms  
Library of Congress Subject Headings PDF Files  
About LCSH - Introduction to LCSH  
Individual Files - Free-floating Subdivisions  
Children's Subject Headings - Genre/Form Terms for Library and Archival Materials  
Demographic Group Terms - Medium of Performance  
Thesaurus for Music - About the Library of Congress Subject Headings PDF Files  
This page provides print-ready PDF files for the 43rd Edition of the Library of Congress Subject Headings (LCSH).  
Data for the 43rd edition was selected in April 2021.  
For users desiring enhanced functionality, LCSH will continue as part of the web-based subscription product, Classification Web.  
Earlier editions are available here but should not be used for cataloging.  
Back to Top  
Introduction to Library of Congress Subject Headings  
Introduction to Library of Congress Subject Headings PDF, 11 p., 337 KB  
Back to Top  
Individual PDF Files  
By Beginning Letter  
Numerals  
12  
., 143 KB  
C  
842  
., 4.65 MB  
F  
322 p., 1.84 MB  
A  
563 p., 3.14 MB  
D  
328 p., 1.86 MB  
G  
323 p., 1.83 MB  
B  
490  
., 2.74 MB  
E  
323 p., 1.84 MB  
334  
., 1.89 MB

Introducción  
Consultar nomenclatura  
Presentación alfabética  
Presentación jerárquica  
Punto de acceso SPARQL  
Descargas  
Estadísticas  
Créditos y aviso legal  
Español  
English  
Français  
Texto a buscar...

RDF/XML  
N-Triples  
N3/Turtle  
JSON  
JSON-LD

Proyecto de nomenclatura internacional normalizada relativa a la ciencia y la tecnología  
Proposed international standard nomenclature for fields of science and technology en  
Projet de nomenclature internationale type des domaines de la science et de la technologie fr

Conceptos cabecera  
skos:topConcept

11 Lógica  
12 Matemáticas  
21 Astronomía y Astrofísica  
22 Física  
23 Química  
24 Ciencias de la Vida  
25 Ciencias de la Tierra y del Espacio  
31 Ciencias Agrarias  
32 Ciencias Médicas  
33 Ciencias Tecnológicas  
51 Antropología  
52 Demografía  
53 Ciencias Económicas  
54 Geografía  
55 Historia  
56 Ciencias Jurídicas y Derecho  
57 Lingüística  
58 Pedagogía  
59 Ciencia Política  
61 Psicología  
62 Ciencias de las Artes y las Letras  
63 Sociología  
71 Ética  
72 Filosofía

European Commission  
Live, work, travel in the EU  
EN  
Employment, Social Affairs and Inclusion  
Home  
Policies and activities  
News  
Events  
Publications  
Contact  
EU Social Forum  
Employment, Social Affairs and Inclusion  
Skills for jobs  
European Skills/Competences, Qualifications and Occupations (ESCO)

Q Search  
European Skills/Competences, Qualifications and Occupations (ESCO)

ESCO European Skills, Competences, Qualifications and Occupations is the European multilingual classification of skills, competences, qualifications and occupations.

ESCO works like a dictionary, describing, identifying and classifying professional occupations and skills relevant for the EU labour market and education and training area and systematically showing the relations between those occupations and skills.

It is available in an online portal where its dataset of occupations and skills can be consulted and downloaded free of charge.

Its common reference terminology helps make the European labour market more effective and integrated, and allows the worlds of work and education/training to communicate more effectively with each other.

What is ESCO?

Schema.org  
Schema.org Docs  
Schemas  
Validate  
About

Schema.org is a collaborative, community activity with a mission to create, maintain, and promote schemas for structured data on the Internet, on web pages, in email messages, and beyond.

Schema.org vocabulary can be used with many different encodings, including RDFa, Microdata and JSON-LD.

These vocabularies cover entities, relationships between entities and actions, and can easily be extended through a well-documented extension model.

As of 2024, over 45 million web domains markup their web pages with over 450 billion Schema.org objects.

Many applications from Google, Microsoft, Pinterest, Yandex and others already use these vocabularies to power rich, extensible experiences.

Founded by Google, Microsoft, Yahoo and Yandex, Schema.org vocabularies are developed by an open community process, using the public-schemaorg@w3.org mailing list and through GitHub.

Schema.org Docs  
Schemas  
Validate  
About

Place  
A Schema.org Type  
Thing  
Place

Entities that have a somewhat fixed, physical extension.

Property  
Properties from Place  
additionalProperty  
address  
aggregateRating  
amenityFeature  
Expected Type  
Description  
more...

PropertyValue  
A property-value pair representing an additional characteristic of the entity, e.g. a product feature or another characteristic for which there is no matching property in schema.org.

Note  
Publishers should be aware that applications designed to use specific schema.org properties e.g. https://schema.org/width, https://schema.org/color, https://schema.org/gtin13, ... will typically expect such data to be provided using those properties, rather than using the generic property-value mechanism.

PostalAddress or Physical address of the item.  
Text  
AggregateRating  
Text  
branchCode  
Place  
containedInPlace  
The overall rating, based on a collection of reviews or ratings, of the item.

LocationFeatureSpecification  
An amenity feature e.g. a characteristic or service of the Accommodation.

This generic property does not make a statement about Event whether the feature is included in an offer for the main accommodation or available at extra costs.

A short textual code also called store code that uniquely identifies a place of business.

The code is typically assigned by the parentOrganization and used in structured URLs.

For example, in the URL http://www.starbucks.co.uk/store-locator/detail/3047 the code 3047 is a branchCode for a particular branch.

The basic containment relation between a place and one that contains it.

Supersedes containedIn.

Inverse property containsPlace

The basic containment relation between a place and another that it contains.

Inverse property containedInPlace

Upcoming or past event associated with this place, organization, or action.

Supersedes events.

https://schema.org/Place

Place  
containsPlace  
event

Ontologías  
schema:CreativeWork  
fecha  
schema:dateCreated  
URL  
schema:thumbnailURL  
url  
licencia  
schema:license  
título  
schema:name

CSV  
metadatos  
título  
licencia  
imagen  
fecha  
recurso  
propiedades  
valores de columnas

Ontologías  
Know Where Graph  
The Graph  
STATUS  
The Graph  
Tools  
Pilots  
People  
Publications  
About  
Contact

The KnowWhereGraph ontology  
At the project's core is the KnowWhere Graph, a geo-knowledge graph that is based on existing standards like RDF, OWL and GeoSPARQL, incorporates custom ontologies, and uses a hierarchical grid for spatial representations.

The integrated KWG schema provides a holistic view of the graph modeling.

Its current size exceeds 12 billion information triples, and the covered data support pilot scenarios in disaster relief, agricultural land use and food-related supply chains.

These data include observations of natural hazards e.g., hurricanes, wildfires, smoke plumes and spatial characteristics related to climate e.g., temperature, precipitation, air quality, soil properties, crop and land-cover types, demographics, and human health, among others.

The table below shows a summary of the raw datasets, their providers, their spatiotemporal scopes etc.

https://knowwheregraph.org

Dataset Name  
Source  
Theme  
Agency  
Soil Properties  
Key Attributes  
Thematic Datasets  
Spatial Coverage  
Targeted regions in US  
Temporal Coverage  
Place-Centric Dataset  
Current US  
1984-current  
soil type, farmland class  
wildfire type, burn severity, num. acres burned, contained date

USDA  
Wildfires  
USGS, USDA, USFS, NIFC

Earthquakes  
USGS  
geometry  
iniurian  
daatha  
nonare.  
magnitude, length, width,  
Global  
mag. 2011-01-01 to  
over 4.5  
2022-01-18

Place-Centric Datasets  
S2 Cells  
Global  
Defining Authority  
Google  
University of Berkeley, Museum of Vertebrate Zoology and the International Administrative Regions Dice  
Desearch  
Spatial Coverage  
Lvl 9 Global, Lvl 13 US, Global

Ontologías  
GeoNames  
Home  
Postal Codes  
Download  
Webservice  
About...

Name  
1 Alicante  
Alicante  
all countries  
V search advanced search  
Country Spain, Valencia  
2802 records found for Alicante  
Latitude Feature class Longitude  
seat of a second-order administrative division  
N 38 20 42  
W 0 28 53  
population 348,901  
A-li-kham-thit, ALC, Akra Leuke, Alacant, Alacante, Alacanti, Alakanto, Alicant, Alicante, Alikante, Alikanteh...

Alicante  
Alicante  
2 Elche  
Spain, Valencia  
3 Ehlch, Ehlche, Elche, Elce, Elch, Elche, Elig, Elx, El, Illici, ai er qie, alchh, alsh, elche, eruche, xelche,...

Alicante-Elche Airport  
Alicante  
Elche  
seat of a third-order administrative division  
population 234,765, elevation 96m  
N 38 15 43  
W 0 42 3  
Spain, Valencia  
airport  
N 38 1655  
W 0 33 29  
ALC, Aeroport d'Alicante-Elche, Aeroporto di Alicante-Elche, Aeropuerto Internacional de Alicante - El ...

Alicante Elche  
elevation 43m

40  
Alicante Canyon  
canyon  
N 37 59 0  
E 0 6 0

5 Orihuela  
Spain, Valencia

6P Auraiola, Aurariola, Orihuela, Oriola, Oriouela, Oriuehla, Oriuela, Orivela, ,Orivela, ao li wei la,aryhwyla, awrywyla,...

Torrevieja  
Alicante  
Orihuela  
seat of a third-order administrative division  
population 101,321  
N 38 5 5  
W 0 56 38  
Spain, Valencia

7P Malnovturo, Toreviekha, Toreviexa, Torevijekha, Torrevekha, Torrevekha, Torrevella, Torrevella de la Mata,...

Benidorm  
Alicante  
Torrevieja  
seat of a third-order administrative division  
population 82,599  
N 37 58 43  
W 0 40 56  
Spain, Valencia

8P Benidorm, Benidormo, bei ni duo er mu, benidoleum, benidorumu, bnydwrm, , , nnnu ...

Alcoy.  
Alka, Alkoj, Alco, Alcodium, Alcoi, Alcoy, Alkoj, Alkojus,a er ke yi, alkwy, arukoi, , , ...

Spain, Valencia  
Alicante  
Alcoy  
Alicante  
Benidorm  
seat of a third-order administrative division  
population 70,450  
N 38 32 17  
W 0 7 51  
seat of a third-order administrative division  
population 61,552  
N 38 42 19  
W 0 28 27

Geonames  
https://www.geonames.org

Ontologías  
Creando nuestra propia ontología.

SOFTWARE  
SUPPORT  
COMMUNITY  
ABOUT

A free, open-source ontology editor and framework for building intelligent systems

Protégé is supported by a strong community of academic, government, and corporate users, who use Protégé to build knowledge-based solutions in areas as diverse as biomedicine, e-commerce, and organizational modeling.

DOWNLOAD NOW  
USE WEBPROTÉGÉ  
https://protege.stanford.edu

Transformación  
Tecnologías  
Apache Jena  
RDF Java framework  
Virtuoso open-source edition  
Spring Boot application  
Apache Maven  
RDFLib  
Jupyter  
Neo4J

Transformación  
En 2015 la BVMC publicó su catálogo como datos abiertos y enlazados  
Modelado de datos basado en RDF y RDA registry  
Enriquecimiento con repositorios externos como Wikidata y GeoNames  
Disponible a través de un punto de acceso SPARQL

Candela, G., Escobar, P., Carrasco, R. and Marco-Such, M. Migration of a library catalogue into RDA linked open data. Semantic Web 9(4) 481-491 2018.  
http://hdl.handle.net/10045/65427

Transformación  
Modelado de datos  
Manifestation  
Expression  
Work  
Agent  
Family  
Corporate Body  
Person  
http://www.rdaregistry.info/Elements/c

Transformación  
Varios puntos de acceso  
URIs usados como identificadores únicos  
https://data.cervantesvirtual.com/date/1616  
https://data.cervantesvirtual.com/language/es  
https://data.cervantesvirtual.com/manifestation/722875  
https://data.cervantesvirtual.com/person/40  
https://data.cervantesvirtual.com/corporatebody/7802  
https://data.cervantesvirtual.com/work/2904  
https://data.cervantesvirtual.com/expression/152342  
https://data.cervantesvirtual.com/item/134373

Nuevas formas de acceso al catálogo

Transformación  
Wikidata y la Biblioteca Virtual Miguel de Cervantes  
Propiedad  
Descripción  
Elementos  
P2799  
BVMC person ID  
15054  
P3976  
BVMC work ID  
764  
P10834  
BVMC organization ID  
240  
https://www.wikidata.org/wiki/Wikidata:Property_proposal

Transformación  
Wikidata y la Biblioteca Virtual Miguel de Cervantes  
Vega, Lope de, 1562-1635  
sacerdote, poeta y dramaturgo español del Siglo de Oro  
Información extraída de Wikipedia CC BY-SA 3.0  
EXPORTAR  
www  
Wikimedia Commons  
Identificador  
72  
Nombre  
Vega, Lope de  
Fecha de nacimiento  
1562  
Fecha de fallecimiento  
1635  
VIAF  
https://viaf.org/viaf/89773778  
Variantes de nombre  
Burguillos, Tom de  
Carrera, Luis de la  
Flórez, Antonio  
Lope de Vega Carpio, Félix  
Padecopio, Gabriel  
Puente, Juan de la  
Un Ingenio de esta Corte  
Vega Carpio, Lope de  
Vega y Carpio, Lope de  
Lope de Vega  
Lugar de nacimiento  
Madrid  
Lugar de fallecimiento  
Madrid  
Nacionalidad  
España  
Nombre de pila  
Lope  
Género  
masculino  
https://data.cervantesvirtual.com/person/72  
RDF  
JSON

5  
Sitio web  
The Cervantes ...  
... Society of America  
Bulletin of the Cervantes Society of America  
Página personal de Daniel Eisenberg ...  
... Daniel Eisenberg dentro del portal temático  
Figuras del Hispanismo  
de la Biblioteca Virtual Miguel ...  
... de Cervantes  
Anuario Bibliográfico Cervantino  
H-Cervantes  
IV Centenario del Quijote  
Instituto Cervantes ...  
Centro de Estudios Cervantinos  
Proyecto Cervantes 2001 ...  
Ver más  
Nacionalidad del autor  
Datos extraídos de Wikidata  
España 2868  
México 227  
Estados Unidos 133  
Argentina 123  
Francia 101  
Chile 60  
Venezuela 49  
Italia 48  
Uruguay 44  
Perú 44

Cervantes  
Bulletin of the Cervantes Society of...  
PUBLICACIÓN PERIÓDICA  
Título  
Portales  
Mat. aut.  
Fondo  
Cervantes  
Bulletin of the Cervantes Society of America - Registro bibliográfico  
Literatura  
Miguel de Cervantes  
Cervantes Bulletin of the Cervantes Society of America  
Cervantes Saavedra, Miguel de 1547-1616  
Crítica e interpretación  
Cervantes Saavedra, Miguel de, 1547-1616- Publicaciones periódicas  
61 tomos

Movimiento del autor  
Datos extraídos de Wikidata  
Siglo de Oro 613  
Romanticismo 167  
Realismo literario 138  
Generación del 98 64  
Barroco 34  
Naturalismo 23  
Costumbrismo literario 16...  
Literatura del barroco 16  
Neoclasicismo 12  
Generación del 27 12  
https://www.cervantesvirtual.com/buscar?q=migueldecervantes  
Ver más  
Ver mas...

Transformación - Java y Jena  
Proyecto biblioteca de Spring Boot en versión 3.4.2  
Este proyecto se ha creado para la asignatura Tecnologías de Internet Orientadas al Navegador del Máster Universitario en Desarrollo de Aplicaciones y Servicios Web de la Universidad de Alicante.  
Para poder editar el código es posible instalar un IDE como Eclipse o Idea.

Configuración  
En el fichero src/main/resources/application.properties se puede configurar el acceso a la base de datos mysql para el almacenamiento de los libros del catálogo.  
También se puede configurar el puerto para ejecutar la aplicación.  
El proyecto incluye la librería Jena como dependencia en el fichero pom.xml para el uso de SPARQL.  
El fichero pom.xml incluye las versiones de las librerías utilizadas en este proyecto.

API REST  
El proyecto proporciona los siguientes patrones de URL para dar acceso al API REST  
Crear libro POST localhost:8081/api/book  
Modificar libro UPDATE localhost:8081/api/book/ID  
Eliminar libro DELETE localhost:8081/api/book/ID  
Recuperar libro GET localhost:8081/api/book/ID  
Para poder realizar pruebas se puede utilizar la herramienta Postman

La SI Ba M  
https://github.com/hibernator11/biblioteca-springboot

Maven Java dependencies  
<dependency>  
<groupId>org.springframework.boot</groupId>  
<artifactId>spring-boot-starter-data-jpa</artifactId>  
</dependency>  
<dependency>  
<groupId>org.springframework.boot</groupId>  
<artifactId>spring-boot-starter-web</artifactId>  
</dependency>  
<dependency>  
<groupId>org.springframework.boot</groupId>  
<artifactId>spring-boot-starter-thymeleaf</artifactId>  
</dependency>  
<!-- https://mvnrepository.com/artifact/com.itextpdf/itextpdf -->  
<dependency>  
<groupId>com.itextpdf</groupId>  
<artifactId>itextpdf</artifactId>  
<version>5.5.13.4</version>  
</dependency>  
<!-- jena version 4.1.0 Java 11- -->  
<dependency>  
<groupId>org.apache.jena</groupId>  
<artifactId>apache-jena-libs</artifactId>  
<version>5.3.0</version>  
<type>pom</type>  
</dependency>  
Apache Jena

Transformación  
Unlocking the Colonial Archive  
Lancaster University  
The University of Texas at Austin Collections  
University of Texas Libraries  
manifest.json

Gustavo Candela, Javier Pereda, Dolores Sez, Pilar Escobar, Alexander Sánchez, Andrés Villa Torres, Albert A. Palacios, Kelly McDonough, and Patricia Murrieta-Flores.  
2023.  
An ontological approach for unlocking the Colonial Archive.  
J. Comput. Cult. Herit.  
Just Accepted April 2023.  
https://doi.org/10.1145/3594727

WIKIDATA  
json2CSV  
python  
OpenRefine  
RDF  
https://curio.lib.utexas.edu/assets/images/utldams/utblac/edmWebResource/38127378-7a33-412f-a425-cc511ff1d351.jp2  
dc:contributor  
edm:Agent  
GeoNames  
..relaciones/agent/leyva-antoniode  
edm:Agent  
dc:autor  
...relaciones/agent/nunez-juan  
edm:ProvidedCHO  
http://scollections.lib.utexas.edu/catalog/utblac/38127378-7a33-412f-a425-cc511ff1d351  
dc:terms/spatial  
edm:Place  
relaciones/place/ameca  
http://github.com/hibernator11/UCA-relacionesgeograficas  
edm:hasView  
..relaciones/aggregation/38127378-7a33-412f-a425-cc511ff1d351  
ore:Aggregation  
edm:aggregatedCHO

Transformación  
Datos originales  
The University of Texas at Austin Collections  
University of Texas Libraries

Extracción  
Modelado  
Enriquecimiento  
json2CSV  
python  
TW  
OpenRefine  
WIKIDATA  
RDF  
Schema.org  
GeoNames  
manifest.json  
JSON  
CSV  
RDF  
https://github.com/hibernator11/uned-unlocking-workshop

OpenRefine  
A power tool for working with messy data.  
Create project  
New Version  
Downl

Create a project by importing data.  
What kinds of data files can I import?  
TSV, CSV, SV, Excel .xls and .xlsx, JSON, XML, RDF as XML, and Google Data

do  
Open project  
Import project  
Language settings  
Get data from  
This Computer  
Web Addresses (URLs)  
Clipboard  
Locate one or more files on your computer to uplo

Examinar...  
No se han seleccionado archivos.

Abrimos el fichero CSV  
Next

OpenRefine  
A power tool for working with messy data.  
New version  
Dowload  
Openkeme v5.0.1 now.

Create a project by importing data.  
What kinds of data files can I import?  
TSV, CSV, SV, Excel .xls and .xlsx, JSON, XML, RDF as XML, and Google Data documents are all supported.  
Support for other formats c

Enter one or more web addresses (URLs) pointing to data to download  
https://raw.githubusercontent.com/hibernator11/uned-unlocking-workshop/main/output/metadatos.csv

Create project  
Open project  
Import project  
Get data from  
Language settings  
This Computer  
Web Addresses (URLs)  
Add another URL  
Next  
Clipboard  
Database  
Google Data

OpenRefine  
A power tool for working with messy data.  
start over  
Configure parsing options  
New Version  
Download OpenRefine v3.8.1 now.

Project name  
UNED metadatos csv

Tags  
Create project  
lugar  
coordenadas  
thumbnail  
urlmanifest

1579-10-02  
MX Diocese of  
20.547647,  
https://curio.lib.utexas.edu/assets/DAMS/utblac  
https  
Guadalajaral  
Ameca, Jalisco, Mexico  
-104.04662  
utblac38127378-7a33-412f-a425-cc511ff1d351TN  
utblac38127378-7a33-412f-a425-cc511ff1d351.jpg  
https://curio.lib.utexas.edu/assets/DAMS/utblac  
creativecommons.org  
utblac38127378-7a33-412f-a425-  
publicdomain  
cc511ff1d351.json  
mark1.0  
manifests2/utblac/38127378-7a33-412f-a425-  
Create project  
Open project  
titulo  
autores  
fecha

Import project  
1. Pintura de Ameca  
unknown artist

Language settings  
Leyva, Antonio de  
contributor  
Moras, Pedro de  
scribe  
Bejarano, Pedro  
signer  
Nez, Juan  
signer  
Cortes, Martín

Parse data as  
CSV/TSV (separator-based files)  
Line-based text files  
Fixed-width field text files  
PC-Axis text files

Character encoding  
Columns are separated by  
Ignore first  
commas  
CSV  
Otabs  
TSV  
Parse next 1 lines as column headers  
O custom, Column names comma separated  
JSON files  
Version 3.6.0  
ff7de4d  
MARC files  
Use character to enclose cells containing column separators  
0 lines at beginning of file  
Update preview  
Disable auto preview  
Attempt to parse cell text into numbers  
Store blank rows  
Store blank cells as nulls  
Store file source  
Store archive file  
Discard initial 0  
JSON-LD files  
Trim leading/trailing whitespace from strings  
Load at most 0 rows of data  
rows of data  
Preferences  
Escape special characters with  
RDF/N3 files

Le damos un nombre y creamos el proyecto desde el menú de la parte superior  
Le damos un nombre al proyecto

OpenRefine  
UNED metadatos cSV  
Permalink  
Facet  
Filter  
Undo/Redo

00  
Using facets and filters  
Use facets and filters to select subsets of your data to act on.  
Choose facet and filter methods from the menus at the top of each data column.  
Not sure how to get started? Watch these screencasts

10 rows  
Show as rows records  
Show 5  
10  
25  
50  
100  
500  
1000 rows  
All  
titulo  
autores  
fecha  
lugar

1. Pintura de Ameca  
unknown  
1579-10-02  
MX Diocese of  
20.547647,  
artist  
Leyva,  
Guadalajaral  
Ameca, Jalisco, Mexico  
-104.04662  
Antonio de  
contributor  
Moras, Pedro de  
scribe  
Bejarano, Pedro  
signer  
Nez, Juan  
signer  
Cortes, Martín  
signer  
Mesa, Francisco de  
signer  
Vzquez, Juan  
signer  
Garca Icazbalceta, Joaqun, 1825-1894  
collector

2. Pintura de  
unknown  
Cuzcatlan  
artist  
Castaeda Len, Juan de  
signer  
Garca, Pero  
interpreter  
Cortes, fir

Open  
Export  
Help  
Extensions  
RDF

Transform  
Wikidata  
lost  
coordenadas  
thumbnail  
licencia  
urlmanifest

https://curio.lib.utexas.edu/assets/DAMS/utblac  
https  
https://curio.lib.utexas.edu/assets  
utblac38127378-7a33-412f-a425-cc511ff1d351TN  
creativecommons.org  
utblac38127378-7a33-412f-a42!  
utblac38127378-7a33-412f-a425-cc511ff1d351.jpg  
publicdomain  
mark1.0  
manifests2/utblac/38127378-7a3  
cc511ff1d351.json

1580-10-26  
MX Diocese of  
18.266262,  
Tlaxcalal  
Coxcatln, Puebla, Mexico  
-97.147278

https://curio.lib.utexas.edu/assets/DAMS/utblac  
https  
https://curio.lib.utexas.edu/assets  
utblace38f8f71-f967-46fb-9493-1edec8cbc1b3TN  
creativecommons.org  
utblace38f8f71-f967-46fb-9493-  
utblace38f8f71-f967-46fb-9493-1edec8cbc1b3.jpg  
publicdomain  
mark1.0  
manifests2/utblace38f8f71-  
f967-46fb-9493-1edec8cbc1b3.js

Vista de creación del proyecto, desde el menú superior podemos configurar la extensión para generar el formato RDF

RDF Transform  
The RDF template below specifies how the RDF data is generated from your tabular data.  
The cells in each record of your data will get placed into nodes within the transform.  
Configure the transform by using column names and values, computed strings, or specified IRI as a subject, property, and object resources or literals.  
Compute strings using GREL. See the docs.

Base IRI  
http://127.0.0.1:3333

Edit Transform  
Preview  
Available Namespaces  
rdf  
rdfs  
owl  
xsd  
vord  
foaf

Add  
Manage  
x R Index  
Add type...  
x titulo  
x autores  
x fecha  
x lugar  
x coordenadas  
x thumbnail  
x licencia  
x urlmanifest  
Add property  
Add Root Node  
Add objed x L auto  
Add objed x L fech  
Add objed x L luga  
Add objed x L coor  
Add objed x L thun  
Add object...  
L licencia  
Add object...  
RDF Transform  
The RDF template below specifi  
Add new prefix  
get placed into nodes within the specified IRI as a subject, prope

Base IRI  
http://127.0.0.1:3333

Transform  
Prefix  
schem  
IRI

Preview  
Available Namespaces  
rdf  
rdfs  
owl  
xsd  
vcard  
foaf  
schema

Add  
Manag  
x R Index  
x titulo  
x L titulo  
Add type...  
Search for class  
schema:CreativeWork

S  
Select an item from the list  
schema:CreativeWork  
http://schema.org/Creativi

Your item not in the list?  
rdft-dialogadd-it  
Shift+Enter

RDF Transform  
Add object..  
The RDF template belo  
RDF Node  
get placed into nodes  
v

Aadimos el espacio de nombres Schema.org y http://example para crear las URIs  
http://example/mapa/xyz

Transform  
Preview  
Available Namespaces  
rdf  
rdfs  
owl  
xsd  
vcard  
foaf  
schema

Add  
Manag  
x R Index  
x titulo  
x L titulo  
Add type...  
Search for class  
schema:CreativeWork

S  
Select an item from the list  
schema:CreativeWork  
http://schema.org/Creativi

Your item not in the list?  
rdft-dialogadd-it  
Shift+Enter

RDF Transform  
Add object..  
The RDF template belo  
RDF Node  
get placed into nodes  
v

Aadimos la clase y definimos la URL  
cord of your da  
ted strings, specified IRI as a subje  
cs.  
Base IRI  
http://127.0.0.1:3333

Prefix  
ex  
Content...

Content used...

Transform  
Prev  
Index  
IRI  
Text  
titulo  
Available Namespace  
autores  
Language  
x R Index  
fecha  
x schema:Creative  
lugar  
Add type...  
coordenadas  
thumbnail  
licencia  
urlmanifest

Constant value  
Integer  
Double  
Date (yyyy-MM-dd)  
DateTime (yyyy-MM-ddTHH:mm:ss.SSS)  
Boolean  
Custom  
specify type  
IRI  
O  
Blank  
Expression...  
mapa/row.index

Edit  
Preview  
Add Root Node  
OK  
Cancel  
Import Template  
Export Template

RDF Transform  
The RDF template below specifies how the RDF data is generated from your tabular data.  
The cells in each  
get placed into nodes within the transform.  
Configure the transform by using column names and values, computed strings, or specified IRI as a subject, property, and object resources or literals.  
Compute strings using GREL. See the docs.

Base IRI  
http://127.0.0.1:3333

Edit  
Transform  
Preview  
Available Namespaces  
rdf  
rdfs  
owl  
xsd  
vcard  
foaf  
schema  
ex

Add  
Manage  
x R Index  
x -schema:name  
X L titulo  
Aadimos las  
schema:CreativeWork  
Add object...  
propiedades  
Add type...  
x -schema:dateCreated  
L fecha  
Add object...  
x -schema:thumbnailURL-  
X L thumbnail  
Add object...  
x-schema:license  
L licencia  
Add object...  
Add property...  
propiedad de  
Columna  
Schema.org  
CSV

RDF Transform  
The RDF template below specifies how the RDF data is generated from your tabular data.  
The cells in each record of your data w  
get placed into nodes within the transform.  
Configure the transform by using column names and values, computed strings, or specified IRI as a subject, property, and object resources or literals.  
Compute strings using GREL. See the docs.

Base IRI  
http://127.0.0.1:3333

Edit  
Transform  
Preview  
Sample Data Preview 20 rows. Shown below Turtle Stream Turtle Pretty  
prefix schema <http://schema.org/> .  
prefix vcard <http://www.w3.org/2006/vcard/ns#> .  
prefix xsd <http://www.w3.org/2001/XMLSchema#> .  
http://example/mapa/3  
rdf:type schema:CreativeWork  
schema:dateCreated 1579-11-22  
schema:name Pintura de Zapotitlan  
schema:license https://creativecommons.org/publicdomainmark/1.0  
schema:thumbnailURL https://curio.lib.utexas.edu/assets/DAMS/utblac/utblac32713c87-b23c-474c-acb9-0757bc1d2dd3TN/utblac32713c87-b23c-474c-acb9-0757bc1d2dd3.jpg.

http://example/mapa/8  
rdf:type schema:CreativeWork  
schema:dateCreated 1580-04-29  
schema:license https://creativecommons.org/publicdomainmark/1.0  
schema:name Pintura de Coatzacualco  
schema:thumbnailURL https://curio.lib.utexas.edu/assets/DAMS/utblac/utblac9a78720b-d927-4635-bdc0-9993a3024f9aTN/utblac9a78720b-d927-4635-bdc0-9993a3024f9a.jpg.

http://example/mapa/1  
rdf:type schema:CreativeWork  
schema:dateCreated 1580-10-26  
schema:license https://creativecommons.org/publicdomainmark/1.0  
schema:name Pintura de Cuzcatlan  
schema:thumbnailURL https://curio.lib.utexas.edu/assets/DAMS/utblac/utblace38f8f71-f967-46fb-9493-1edec8cbc1b3TN/utblace38f8f71-f967-46fb-9493-1edec8cbc1b3.jpg

Podemos ver el resultado desde la opción Preview

Show 5  
10  
25  
50  
100  
500  
1000 rows  
autores  
fecha  
lugar  
coordenadas  
thumbnail  
unknown  
1579-10-02  
MX Diocese of  
20.547647,  
https://curio.lib.utexas.edu/assets/DAMS/utblc  
ist  
Guadalajaral  
-104.04662  
utblac38127378-7a33-412f-a425-cc511ff10851TN  
rva, Ameca,  
utblac38127378-7a33-412f-a425-cc511ff10851.jpg  
onio de Jalisco, Mexico  
ntributor  
ras, Pedro  
scribe  
arano, Iro  
iner  
iez, Juan  
iner  
tes, tin  
iner  
, ncisco de  
iner  
zquez, iner  
ca

Open...

Export  
OpenRefine project archive to file  
dat  
Tab-separated value  
las  
Comma-separated value  
HTML table  
Excel .xls  
Was  
Excel 2007 .xlsx  
12f-a  
378  
ODF spreadsheet  
Custom tabular exporter

SQL Exporter

Templating

OpenRefine project archive to Google Drive

Google Sheets

Podemos exportar los datos una vez finalizado el proceso de transformación

Wikibase edits

QuickStatements file

Wikibase schema Pretty  
Exports RDF/XML Pretty  
Was  
h  
Stream  
Exports Turtle Pretty  
-97.147278  
b-94  
utblace38f8f71-f967-46fb-9493-1edec8cbc  
b3.jpg  
TriG Pretty  
F71-  
bc1b  
JSON-LD Pretty  
RDF/JSON Pretty  
zbalceta, qun, 15-1894  
llector  
unknown  
1580-10-26  
MX Diocese of  
18.266262,  
ist  
Tlaxcalal  
staeda  
Coxcatln,  
in, Juan  
Puebla, Mexico  
signer  
ca, Pero  
erpreter  
tes

7  
prefix schema <http://schema.org/> .  
8  
prefix vcard <http://www.w3.org/2006/vcard/ns#> .  
9  
prefix xsd <http://www.w3.org/2001/XMLSchema#> .  
10  
11  
http://example/mapa/3  
12  
rdf:type schema:CreativeWork  
13  
schema:dateCreated 1579-11-22  
14  
schema:license https://creativecommons.org/publicdomainmark/1.0  
15  
schema:name Pintura de Zapotitlan  
16  
schema:thumbnailURL https://curio.lib.utexas.edu/assets/DAMS/utblac/utblac32713c87-b23c-474c-ac  
El fichero RDF  
17  
18  
http://example/mapa/8  
19  
rdf:type schema:CreativeWork  
20  
schema:dateCreated 1580-04-29  
21  
schema:license https://creativecommons.org/publicdomainmark/1.0  
22  
schema:name Pintura de Coatzacualco  
23  
schema:thumbnailURL https://curio.lib.utexas.edu/assets/DAMS/utblac/utblac9a78720b-d927-4635-bd  
output del en formato TTL se encuentra en la carpeta  
24  
25  
http://example/mapa/1  
26  
rdf:type schema:CreativeWork  
27  
schema:dateCreated 1580-10-26  
28  
schema:license https://creativecommons.org/publicdomainmark/1.0  
29  
schema:name Pintura de Cuzcatlan  
30  
schema:thumbnailURL https://curio.lib.utexas.edu/assets/DAMS/utblac/utblace38f8f71-f967-46fb-94  
proyecto GitHub  
34  
https://github.com/hibernator11/uned-unlocking-workshop  
blob/main/output/UNED/metadatos.csv.ttl

LC Maps for Robots  
BL Labs  
Archives Unleashed Notebooks  
LC - Newspapers navigator  
National Library of Scotland  
Biblioteca Virtual Miguel de Cervantes  
GLAM WorkBench

Ejecución interactiva  
En la nube  
Reproducible  
Documentación  
Herramienta educacional  
Código  
Flujo de trabajo  
Multilingüe

Transformación - Código reproducible...

dhlab-na-lisboa  
launch binder  
This project was originally created for a workshop f de Lisboa.

LABORATORIO DE HUMANIDADES DIGITAIS  
NOVA/FCSH  
FACULDADE DE CIENCIAS SOCIAIS E HUMANAS  
UNIVERSIDADE NOVA DE LISBOA  
Thanks to OVH, GESIS Notebooks and Curvenote for supporting us!

mybinder.org has updated the base image to Ubuntu 22.04!  
See the upgrade guide for details.

binder  
2  
ting repository  
hibernator11/uned-unlocking  
orksho  
https://hub.binder.cu  
H of Universidade NOVA  
serhibernator11-un-ocking-workshop-04xnedcblabtree/notebo  
X  
ExtraccionUCA2CSV.ipynb  
C  
Download  
GitHub  
Binder  
Markdown

Introducción  
This project provide several examples of reuse based on different technique  
Language Processing.  
Map representing the nationalities of the authors de Cervantes  
This example is based on the Linked Open Data version of the Biblioteca Vir  
Wikidata, enabling the creation of visualisations using the Wikidata SPARQL

File  
Edit  
View  
Run  
Kernel  
Tabs  
Settings  
Help  
C  
Launcher  
Filter files by name  
notebooks  
Q  
Name  
Last Modified  
Extraccion....  
2 minutes ago  
SPARQLAna...  
2 minutes ago  
https://github.com/hibernator11/dhlab-nova-lisboa  
cionUCA  
3  
Este ejemplo se encarga de extraer los metadatos necesarios de la colección.  
En concreto, vamos a extrae

En primer lugar cargamos las librerías necesarias  
1  
import urllib.request, json  
import csv

Función que extrae los campos requeridos  
47  
def getCampos(urlmanifest):  
manifest = json.load(urllib.request.urlopen(urlmanifest))  
titulo = autores = fecha = lugar = coordenadas = thumbnail = licencia

Transformación  
National Librarians Research Fellowship in Digital Scholarship 2022-23  
https://github.com/NLS-Digital-Scholarship/nls-fellowship-2022-23  
Candela, G. 2023.  
Towards a semantic approach in GLAM Labs: The case of the Data Foundry at the National Library of Scotland.  
Journal of Information Science.  
https://doi.org/10.1177/01655515231174386

Transformación  
Moving Image Archive  
This dataset represents the descriptive metadata from the Moving Image Archive catalogue, which is Scotland's national collection of moving images.

Data format  
metadata available as MARCXML and Dublin Core

Data source  
https://data.nls.uk/data/metadata-collections/moving-image-archive

The Jupyter Notebooks include a set of examples to reproduce the transformation to RDF and enrichment with external repositories

Data extraction  
Exploring the CSV text file  
Transformation to LOD  
Enrichment  
Exploring with SPARQL  
Exploring geographic locations  
Data Quality assessment

amateur footage  
work tape  
featuring  
Fparticipate  
subtitled programme  
edinburgh  
Live chat  
bbc alba  
scottish shot  
scotland  
grampian  
Felevision alba  
episode look  
source  
bbc  
compilation tape  
radio times  
interview  
gaelic children  
alba programme  
newsitemglasgow  
source  
radio  
provide  
Lives  
Cultures

Preparation  
Jupyter  
Import the libraries required to explore the summary of each record included in the dataset to present a word cloud

In 3...

from rdflib import Graph, URIRef, Literal, Namespace  
from rdflib.namespace import FOAF, RDF, DCTERMS, VOID, DC, SKOS  
import pandas as pd

Transformation to RDF  
Note  
The variable domain could be updated to the domain of the organisation e.g., https://data.nls.uk.

In 3...

domain = "http://example.org"

First, we instantiate all the namespaces that we will use when defining the RDF data

In 3...

g = Graph()  
g.bind("foaf", FOAF)  
g.bind("rdf", RDF)  
g.bind("dcterms", DCTERMS)  
g.bind("dc", DC)  
g.bind("void", VOID)  
g.bind("skos", SKOS)  
schema = Namespace("http://schema.org/")  
g.bind("schema", schema)  
edm = Namespace("http://www.europeana.eu/schemas/edm/")  
g.bind("edm", edm)

We define the resource National Library of Scotland

In 3...

nls = URIRef(domain + "organisation/nls")  
g.add(nls, RDF.type, schema.Organization)  
g.add(nls, schema.url, URIRef("https://www.nls.uk"))  
g.add(nls, schema.logo, URIRef("https://www.nls.uk/images/nls-logo.png"))  
g.add(nls, schema.name, Literal("National Library of Scotland"))  
g.add(nls, DC.title, Literal("National Library of Scotland"))

https://github.com/NLS-Digital-Scholarship/nls-fellowship-2022-23

Transformación  
Loading RDF  
The class JenaTDBLoad is in charge of loading the RDF into the RDF Jena TDB storage system.  
The RDF files mu be places in the folder rdf.  
The following code shows the process

National Bibliography of Scotland and BOSLIT  
The transformation process is based on the tool marc2bibframe that uses BIBFRAME as main vocabulary to describe the resources.

Create dataset  
Path path = Paths.get("..").toAbsolutePath().normalize();  
String dbDir = path.toFile().getAbsolutePath();  
Dataset dataset = TDB2Factory.connectDataset(location);  
dataset.begin(ReadWrite.WRITE);  
Model model = dataset.getDefaultModel();

Files.walk(Paths.get(path).toFile().getAbsolutePath())  
.rdf .filter(p -> p.toString().endsWith(".gz"))  
.forEach(p -> {  
logger.info(p.toFile().getAbsolutePath());  
try {  
RDFDataMgr.read(model, p.toFile().getAbsolutePath(), Lang.RDFXML);  
} catch (Exception e) {  
logger.error(p.toFile().getAbsolutePath(), e.getMessage());  
}  
});

dataset.commit();

Releasing dataset resources  
dataset.close

https://github.com/NLS-Digital-Scholarship/nls-fellowship-2022-23  
dataset.commit

Releasing dataset resources  
dataset.close

https://github.com/hibernator11/nls-jena-tdb  
Java  
Maven  
TM  
Apache Jena

Transformación  
literarybibliography.eu  
Facilitating access to digital research infrastructures and advancing frontier knowledge in the arts and humanities across disciplines, languages and media.

https://atrium-research.eu

Transformación  
DH2025  
ACCESSIBILITY  
CITIZENSHIP  
ATRIUM  
Facilitating access to digital research  
https://atrium-research.eu  
infrastructures and advancing frontier knowledge in the arts and humanities across disciplines, languages and media.

Bibliographic records  
4 777 867  
8  
Persons  
202 040  
Places  
9514  
API  
Ontologies  
Extraction  
Labs  
Vocabularies  
RDF  
Data modelling  
Corporates  
7454  
M  
Magazines  
843  
31  
Events  
319  
literarybibliography.eu

Criteria  
Platforms  
Scenarios  
Transformation and enrichment  
Data quality  
Publication  
External repositories  
Shape Expressions  
Reuse  
Prototypes  
Jupyter Notebooks

TITLE update path

ATRIUM project  
A reproducible approach  
The Jupyter Notebooks include a set of examples to reproduce the transformation to RDF.

Data extraction  
extraction of the data from the biblio.json file to create a CSV file.

Data exploration  
exploration of the original biblio.json file.

Transformation to LOD  
transformation of the original data using the CSV file to RDF using as main vocabulary Schema.org.

Data exploration using SPARQL  
exploration using SPARQL of the RDF data generated.

Data quality  
ShEx validation of the RDF data generated using Shape Expressions.

In order to check how to test the ShEx against the RDF generated you can see the Data quality assess notebook.

Candela, G., Rosiski, C., Margraf, A. 2024.  
A reproducible framework to publish and reuse Collections as data: the case of the European Literary Bibliography.

https://doi.org/10.5281/zenodo.14106707

Research scenarios  
European Literary Bibliography  
API, ZIP files  
Data Infrastructure  
Publication  
reuse

Transformación  
Data curation and management  
Cloud computing  
Jupyter Notebooks  
Sustainability  
Code repository  
Best practices  
Data platforms  
Dissemination  
Vocabularies

Architecture defined to apply the framework proposed in this work.  
It focuses on three main elements: data, infrastructure, and publication

Transformación  
Scenario 1  
Comparative analysis of provincial Spanish novels featuring vampires

Scenario 2  
Republican writers who migrated during the Spanish Civil War

Scenario 3  
Geographical distribution of publications dedicated to particular Spanish writers

TITLE update path

Articles  
Issues  
About  
Boards  
For authors  
Article Transformations  
A DARIAH Journal  
A reproducible framework to publish and reuse Collections as data: the case of the European Literary Bibliography

Gustavo Candela 1, Cezary Rosiski 2, Arkadiusz Margraf 3

1 University of Alicante  
2 Institute of Literary Research of the Polish Academy of Sciences  
3 Institute of Bioorganic Chemistry of the Polish Academy of Sciences

Abstract  
EN

GLAM (Galleries, Libraries, Archives and Museums) institutions host rich content that is provided in the form of digital collections.  
Bibliographic databases are collections of references focused on a particular topic that can be used to apply Digital Humanities (DH) methods.

Recent approaches such as Collections as Data and Labs promote the publication of digital collections supporting computational use.

This work aims to provide a framework for publishing and reusing digital collections based on literary bibliographies published by GLAM institutions in order to make them suitable for computational use in the form of Collections as Data, in particular, in the context of the European Literary Bibliography.

It also describes the infrastructure used and DH research scenarios to illustrate how the results can be reused for different goals.

Digital curators and DH researchers interested in making their datasets available in the form of Collections as Data are the intended audience of this work.

https://doi.org/10.46298/transformations.14729

Jupyter search  
Download article  
Open on Zenodo  
Cite Metadata  
Share  
Submit

Publication details  
Published on June 16, 2025  
Accepted on  
Submitted on April 3, 2025  
November 12, 2024  
Volume 1

Workflows  
DOI 10.46298/transformations.14729

TITLE update path

Transformación  
Espacios de datos de patrimonio cultural  
Jupyter  
https://marketplace.sshopencloud.eu/workflow/I3JvP6

Workflow steps  
10  
1 Provide a clear license and terms of use allowing reuse of the dataset without restrictions  
Expand  
2 Provide a suggested citation for the dataset so reusers are aware of how to cite it  
Expand  
about the dataset  
Expand  
Enrichment  
make available the dataset for the public  
Expand  
VIAF  
copyright  
websites  
content  
research articles  
WIKIDATA  
o demonstrate how the dataset can be reused  
Expand  
for the dataset for a better understanding of how to reuse  
Expand  
API  
Selection  
Labs  
Institutions  
GLAM  
Compilation  
Description  
le metadata about the content provided in the dataset  
Expand  
rative-edition platform to include the information about the  
Expand  
W3C Semantic Web  
means of an existing API  
Expand  
sent and describe the dataset to encourage its reuse  
Expand  
DCAT  
DQV  
Vocabularies  
Data Catalog Vocabulary (DCAT)  
https://github.com/hibernator11/dcat-glam-catalog

TITLE update path

Transformación  
Spanish-Civil-War-KGs  
Extracting Knowledge Graphs as Collections as Data using the Spanish Civil War as case study  
DOI 10.5281/zenodo.16747522

Introduction  
This project intends to analyse the options and potential of Wikidata to extract Knowledge Graphs as Collections as Data using the Spanish Civil War as case study.

The data was retrieved from the National Archives in Spain, and enriched in Wikidata.

The authors of this work are  
Gustavo Candela, University of Alicante, Spain  
Meltem Dili, Hacettepe University, Turkiye  
Paul Spence, Kings College London, United Kingdom  
Cezary Rosiski, Institute of Literary Research of Polish Academy of Sciences, Poland  
Arkadiusz Margraf, Poznan Supercomputing and Networking Center affiliated to Institute of Bioorganic Chemistry of the Polish Academy of Sciences, Poland

We provide 4 examples of use covering different topics and content  
Artists from the period of the Spanish Republic and Spanish Civil War  
Refugee ships on which Spanish exiles embarked during the Spanish Exile and the Spanish Civil War  
French refugee camps, which concentrated the Spanish Republican exiles of 1939  
Retrieving bibliographic records related to the Spanish Civil War from the Biblioteca Virtual Miguel de Cervantes LOD repository

Casos de uso basados en la extracción de datos y la Guerra Civil Española  
PA RES  
Jupyter  
WIKIDATA

TITLE update path

Transformación  
Cómo buscar en varios repositorios y evitar silos de datos?  
Creating Collections as Data Using Federated Queries  
WIKIDATA  
COLLECTIONS AS DATA

[1](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/125899823/b9c9375c-e8b6-40d5-b6a0-aab6472e9f19/apd-25-26-tema8_moodle.pdf)