.. toctree::
   :hidden:

.. role:: red

SBDI module for ASV observations
================================
The `Swedish Biodiversity Data Infrastructure (SBDI) <https://biodiversitydata.se/>`_ will mobilize sequence-based occurrence data, e.g. Amplicon Sequence Variant (ASV) observations, and make these available for integrative analyses in `the BioAtlas portal <https://bioatlas.se/>`_. SBDI is part of the `Living Atlas Community <https://living-atlases.gbif.org/>`_, and is based on `standard Darwin core files and extensions <https://www.gbif.org/darwin-core>`_, but to make the BioAtlas platform more useful to the research community, we will add a separate atlas module that slightly modifies how molecular data are stored, accessed and presented. We describe this 'molecular module' from a functional/technical standpoint below. Once all components are in place, we will provide detailed instructions on how to submit ASV data to SBDI, via the molecular module.

Main objectives
***************
By adding the molecular module, we want to make it possible to:

1. Store and search for processed barcode sequences, i.e. ASVs, underlying occurrence records in the BioAtlas. Users should be able to use BLAST (Basic Local Alignment Search Tool) to find occurrences related to their own ASVs in the BioAtlas.

2. Store data and metadata on repeated taxonomic annotations of ASVs. Regular re-annotation is important, as reference databases continuously grow and thus enable identification at lower taxonomic levels.

3. Store or seamlessly retrieve metadata from external repositories of raw sequence reads, such as the European Nucleotide Archive (ENA). Central metadata, e.g. on primer sequences or target gene regions, should be stored and made searchable, while other metadata could be retrieved from source databases on request.

Components
**********
The SBDI molecular module will have three main components:

1. A database of Swedish Amplicon Sequence Variants (ASVs), their occurrence in environmental samples, and associated metadata.

2. A RESTful API, providing programmatic access to the database.

3. A web application, providing browser access to database, as well as to BLAST and API search functionality.

Data model
**********

Data flow
*********
Input: User > (Ampliflow >) Molecular module > IPT > BioAtlas

Access: Molecular module > BioAtlas > ...?
