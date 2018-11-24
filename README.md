# cot-meta-data
This repository contains the complete catalog of open textbooks listings from collegeopentextbooks.org.

# College Open Textbooks System
## Purpose
The College Open Textbooks (COT) metadata search system was built to aggregate Open Education Resources (OER) from existing single-purpose OER repositories. Several repositories exist but provide metadata only for their own open resources and sometimes include a partner's resources as well. The COT metadata search system aggregates all of those resources into one searchable place. Search results send users to the originating repository's resource page.

## Architecture
### General
The COT metadata search system is composed of three main parts:
* Importers
* Application Programmer's Interface (API)
* User Interface (UI)

### Importers
Each repository tracked by COT uses a different mechanism to supply metadata to interested parties. [British Colombia's BcCampus](https://bccampus.ca/), [Florida Virtual Campus](https://www.flvc.org/), and University of Georgia's [Galileo](https://oer.galileo.usg.edu) are all based on [OAI-PMH](https://www.openarchives.org/pmh/) but have their own incompatible quirks and customizations. [State University of New York (SUNY)](https://textbooks.opensuny.org) uses the WP-JSON Wordpress plugin to serve up OER metadata as Wordpress blog posts. College Open Textbooks' own repository is composed of static HTML files.

With all of these differences in protocol and parsing, the COT team built an importer architecture that abstracts commonalities between repositories while allowing each repository's importer to customize the import process. For example, the [COT HTML importer](https://github.com/cot-education/cot-api/blob/test/api/src/main/java/org/collegeopentextbooks/api/importer/CotHtmlImporter.java) has the same stages of import as all other importers but it customizes metadata acquisition to originate at the file system and parsing to find appropriate data within HTML files. Since all importers use a common interface, it's very easy to run all of them in a simple loop without needing to know anything about a specific importer's implementation.

In a similar vein, importers translate their repository's data into a common data model used by the COT metadata database, enabling all importers to interact with the database in a unified manner. The same data access layer is reused by each importer and the API.

## Application Programmer's Interface (API)
Since the chief goal of this College Open Textbooks initiative was to provide a searchable metadata database for external consumption, it was necessary to expose an API ([source code](https://github.com/cot-education/cot-api)) to allow third-party applications to search and query the COT database for resources, specific authors, etc. These capabilities were exposed as a RESTful web services API consuming and delivering JSON data. The API provides endpoints to:
* Retrieve metadata for all resources
* Retrieve metadata for all resources in a specific subject or subjects
* Retrieve metadata for a specific resource
* Search for resources matching any combination of:
  * a specific author or authors
  * a specific editor or editors
  * a specific subject or subjects
  * a specific license type or types
  * a specific repository
  * part of a title
  * part of a resource URL
* Retrieve all aggregated:
  * repositories
  * authors
  * editors
  * subjects
  * licenses

All endpoints are unauthenticated in order to foster open use of the API for searching open resource metadata.

### Technical Notes
The COT search API leverages the Spring Boot web application framework to host web services. Spring Boot makes getting up and running easy - [Application.java](https://github.com/cot-education/cot-api/blob/test/api/src/main/java/org/collegeopentextbooks/api/Application.java) can be run as any other Java application but launches an embedded Jetty container so no additional application server configuration is needed.

PostgreSQL database setup is also straightforward - run the [db-import.sql](https://github.com/cot-education/cot-meta-data/blob/master/db-import.sql) file as input to pg_restore to re-create the COT database tables in an existing database and import all COT resource metadata.

Embedded API endpoint documentation is available via Swagger2. When Application.java is launched Swagger2 generates interactive HTML documentation available at http://<webroot>/swagger-ui.html .

## User Interface (UI)
With the completion of the COT metadata searching API it became clear that a proof-of-concept interface allowing humans to actually *use* the API was necessary. The COT team built a Single-Page Application web page ([source code](https://github.com/cot-education/cot-search-ui)) to show the functionality of the search API and provide a mechanism for humans to interact with the searchable metadata database.

