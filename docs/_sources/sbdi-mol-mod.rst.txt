.. toctree::
   :hidden:

.. role:: red

Atlas module for ASV data
=========================
As part of the `Living Atlas Community <https://living-atlases.gbif.org/>`_, the `Swedish Biodiversity Data Infrastructure (SBDI) <https://biodiversitydata.se/>`_ and the `BioAtlas portal <https://bioatlas.se/>`_ is based on `standard Darwin core files and extensions <https://www.gbif.org/darwin-core>`_. To make SBDI more useful to the molecular research community, however, we will add a module that slightly modifies how these data are stored and accessed. We briefly outline this molecular module below. Once all components are in place, we will provide detailed instructions on how to submit and access ASV occurrences, via the molecular module.

Main objectives
***************
By adding the molecular module, we want to make it possible to:

1. Store and search for processed barcode sequences, i.e. ASVs, underlying occurrence records in SBDI. Users will be able to use BLAST (Basic Local Alignment Search Tool) to find ASV occurrences.

2. Store data and metadata on successive taxonomic annotations of ASVs. Regular re-annotation is important, as reference databases continuously grow and thus enable identification at lower taxonomic levels.

3. Store or seamlessly retrieve metadata from external repositories of raw sequence reads, such as the European Nucleotide Archive (ENA). Central metadata, e.g. on primer sequences or target gene regions, should be stored and made searchable, while other metadata could be retrieved from source databases on request.

Components
**********
The SBDI molecular module will have three main components:

1. A database of Swedish Amplicon Sequence Variants (ASVs), their occurrence in environmental samples, and associated metadata.

2. A RESTful API, providing programmatic access to the ASV database.

3. A web application, providing browser access to the database, as well as to BLAST and API search functionality.

Data model
**********
.. figure:: _static/images/data-model.png
   :alt: ASV data model

   SBDI data model for ASV data and metadata.

In our ASV data model, each dataset includes one or more sampling events, for each of which the occurrence of one or more unique sequences have been quantified (i.e. as read counts). Events are also linked to metadata on sequencing and bioinformatic processing, either stored in the `'mixs' <https://gensc.org/mixs/table>`_ table (mandatory data), or accessed via hyperlink in in the 'associated_sequences' field (additional data). Events can also be related to any contextual metadata, registered in the `'emof' <https://tools.gbif.org/dwca-validator/extension.do?id=http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact>`_ table. Finally, while we will store the original taxonomic identification, submitted to us by the data provider, we will also apply a 'standard SBDI' annotation, subject to regular updates as new releases of external reference databases, such as `GTDB <https://gtdb.ecogenomic.org/>`_, are provided.
