.. toctree::
   :hidden:

.. role:: red

Atlas module for ASV data
=========================
As part of the `Living Atlas Community <https://living-atlases.gbif.org/>`_, the `Swedish Biodiversity Data Infrastructure (SBDI) <https://biodiversitydata.se/>`_ and the `BioAtlas portal <https://bioatlas.se/>`_ is based on `standard Darwin core files and extensions <https://github.com/gbif/ipt/wiki/DwCAHowToGuide>`_. To make SBDI more useful to the molecular research community, however, we will add a module that slightly modifies how these data are added, stored and accessed. We briefly outline this molecular module, and how it will fit into the overall data flow, below. Please note that this is an ongoing project and that information thus is subject to change. Once all components are in place, we will provide detailed instructions on how to submit and access ASV occurrences via the module.

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

3. A web application, providing browser access to data submission, BLAST and API search functionality.

Data model
**********
.. figure:: _static/images/data-model.png
   :alt: ASV data model

   SBDI data model for ASV data and metadata (Try: right-click | Open Image in New Tab / View Image, for improved resolution).

In our ASV data model, each dataset includes one or more sampling event(s), each of which are linked to or one more quantified sequence occurrence(s). Events are also associated with metadata on sequencing and bioinformatic processing, either stored in the `'mixs' <https://tools.gbif.org/dwca-validator/extension.do?id=http://gensc.org/ns/mixs/terms/Sample>`_ table (mandatory data), or accessed via hyperlink to an external repository, in the 'associated_sequences' field (additional data). In addition, events can be related to any type of contextual metadata, registered in the `'emof' <https://tools.gbif.org/dwca-validator/extension.do?id=http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact>`_ table. Finally, while we will store the original taxonomic identification submitted to us by the data provider, we will also apply a 'standard SBDI' annotation, subject to regular updates as new releases of external reference databases, such as `GTDB <https://gtdb.ecogenomic.org/>`_, become available.

Place in ASV data flow
**********************
In a first implementation of the web application, data providers will be able to upload data as text or spreadsheet files, formatted in accordance with a provided guide on data fields and accepted values. These will largely be a subset of `standard Darwin core terms <https://dwc.tdwg.org/terms>`_, with a few additions specific to the Swedish ASV database. At data submission, users will also be asked to provide higher level metadata, e.g. on dataset origin and contact details, in a web form linked to the `Swedish IPT portal <http://www.gbif.se/ipt/>`_. Later on, we plan to accept BIOM files with corresponding ASV data and metadata, and to provide more automated data import facilities.

Once we have imported data into the ASV database, SBDI will apply a standard taxonomic re-annotation to each ASV, using current versions of selected classification algorithms and reference databases, for the organism group in question. This will provide the valid and searchable taxonomy of the ASV, although the original, user-provided annotation will also be stored and displayed.

Following taxonomic processing, ASV occurrence data will be ingested into the BioAtlas as `Darwin Core Archives (DwCA) <https://github.com/gbif/ipt/wiki/DwCAHowToGuide>`_, via `IPT <http://www.gbif.se/ipt/>`_. Users will then be able to BLAST for sequences and associated occurrence records in the atlas, as well as search for data associated with e.g. specific primer sequences or sampling environments. In addition to data visualization and download options provided in the atlas, the molecular module will also provide download of BLAST results.
