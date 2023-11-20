.. toctree::
   :hidden:

*Please send bug reports and/or suggestions to* |text|_.

.. _text: https://docs.biodiversitydata.se/support/

.. |text| replace:: *SBDI support*

Guide to ENA submission (webin)
===============================
This is a guide on how to submit sequence reads from environmental samples to the `European Nucleotide Archive (ENA) <https://www.ebi.ac.uk/ena/>`_, provided by the `Swedish Biodiversity Data Infrastructure (SBDI) <https://biodiversitydata.se/>`_. Our guide is largely a summary of `ENA's own extensive instructions <https://ena-docs.readthedocs.io/en/latest/index.html>`_, with added pointers on issues specific to submission of metarbarcoding data, as well as on more general matters that may confuse first-time contributors. While ENA provides `three different routes for submission <https://ena-docs.readthedocs.io/en/latest/general-guide.html>`_, we describe interactive submission via the Webin portal here.

Preparation for submission
**************************

Step 1: Prepare data and metadata
---------------------------------
In ENA, raw sequencing output from a next generation platform, including e.g. base calls and per-base quality scores, is accepted in `FASTQ, CRAM or BAM format <https://ena-docs.readthedocs.io/en/latest/fileprep/reads.html>`_. Before submission, make sure that sequencing adapters have been removed (*trimmed*), and that reads have been assigned to their sample of origin (*demultiplexed*). In addition, gather all the information (*metadata*) you have about how, when and where you acquired the samples and generated the reads, as well as any contextual (environmental or clinical) data that was collected during sampling (see `ENA's metadata model <https://ena-docs.readthedocs.io/en/latest/general-guide/metadata.html>`_).

Step 2: Register with ENA
-----------------------------------
To be able to submit data to ENA, you need to register an account. Go to the `Webin submission Portal <https://wwwdev.ebi.ac.uk/ena/submit/webin/login>`_, select *Register* to fill out the form, and save your account details. You will receive a confirmation email with your account name.

Interactive submission
**********************

Step 1: Log in to submission portal
-----------------------------------
ENA provides two submission services: one for `test submission <https://wwwdev.ebi.ac.uk/ena/submit/webin/login>`_ and one for (real) `production submission <https://www.ebi.ac.uk/ena/submit/webin/login>`_. Make sure that your data pass validation in the test procedure, before submitting anything to the production environment. All test submissions are removed the following day, but you will save all metadata as tab-separated text (\*.tsv) files that you can reuse later.

After login, you are directed to the Dashboard, which gives you an overview of all available submission activities and reports (i.e. lists of successfully submitted samples etc.). Via the top-left hamburger icon (|hamburger-icon|) you can either go back to this Dashboard, or jump directly to some activity or report.

.. |hamburger-icon| image:: _static/images/hamburger-icon.png

Step 2: Register study
----------------------
The *study (project)* object is linked to samples and sequence reads via experiments, and is typically what you cite in publications. Click *Studies (Projects) | Register Study* to start filling out the Study form. Note that a single release date is set for all data within a study, and that you thus may want to split sequenced batches of samples into multiple ENA studies. After entering the required metadata for a study, click *Submit | OK*. If successful, you will receive a confirmation message, and should be able to see your study listed in the *Studies (Projects) | Study Report* page.

Step 3: Register samples
------------------------
*Samples* are the source material from which your sequences derive, and the searchability and usability of your submitted data will depend on how well you document these samples. Go to *Samples | Register Samples* and click *Download spreadsheet to register samples* to start the process.

Step 3a: Select sample checklist
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The `ENA sample checklists <https://www.ebi.ac.uk/ena/submit/checklists>`_ are partly overlapping sets of attributes (or data fields) that can be used to describe samples, and by selecting one of these you enable your sample metadata to be validated for correctness during submission. For environmental and organismal (host-associated) samples, alike, we recommend using one of the *Environmental Checklists* and, among these, to select the alternative from the *Genomic Standards Consortium (GSC) MIxS checklists* that provides the most specific match to your sampled environment, for example:

.. csv-table::
  :file: _static/tables/recommended-checklists.csv
  :header-rows: 1

Note that most GSC MIxS checklists have similar setups of mandatory and recommended attributes, i.e. differ mainly in terms of which optional attributes can be added and validated during submission. The environmental attributes *altitude, elevation* and *depth*, are mandatory only for some lists, however. Furthermore, the GSC MIxS built environment list (not mentioned above) has several unique mandatories.

Step 3b: Add sample attributes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Once you have selected a checklist, you can inspect the attributes available in that list. All *Mandatory Fields* are preselected, and you can add *Optional Fields* by ticking their boxes. We suggest that you, at least, tick the following optional attributes for metabarcoding data\*:

.. csv-table::
  :file: _static/tables/optional-fields.csv
  :header-rows: 1

\* *Disclaimer*: While target gene/subfragment and primers are typically associated with the (sequencing) experiment, ENA only lists these fields as optional at sample level. When queried about this, ENA suggests adding the fields to experiments through post-submission XML editing, but we consider this process too complex. Therefore, we still recommend adding them to your samples as outlined above. Please note, however, that if you've sequenced multiple targets (e.g., both 16S and 18S) using the same *physical* samples, you will then need to submit two sets of *digital* samples. If you choose this approach, please make it easy for data users to identify sequences originating from the same physical sample by adding sample aliases, such as *[physical_sample_id]_16S* and *[physical_sample_id]_18S*.

To ensure that metadata are validated and searchable, you should use existing attributes whenever possible, but you can also add custom attributes to describe your data, if needed (see *Add custom field* in top left corner of page. Write your field name *before* hitting the plus button). Adding more than a few of these is easier to do in a spreadsheet, though, and we explain how to do that in the next step.

Step 3c: Download spreadsheet template
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
After selecting optional attributes, click *Next*, and then the *Download TSV Template* button to download a tab-separated values (\*.tsv) file. Open the file in your spreadsheet application of choice (In MS Excel, click *Data | Text to Columns | Delimited | Delimiter: Tab*, to separate text into columns, if needed). With the added optional attributes from 3b, a template created from the *GSC MIxS water* checklist should look like this:

.. csv-table::
  :file: _static/tables/mixs-water-template.csv
  :header-rows: 0

Step 3d: Edit spreadsheet structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In the downloaded spreadsheet, you can add custom attributes (with units, where applicable) to the right of existing columns, and samples below the row starting with *#units*. For instance, if you add two custom attributes (*salinity [psu]* and *sampling_station_id*), and three samples (*xyz:1:01*, *xyz:1:02* and *xyz:1:03*) to the template from Step 3c, your spreadsheet structure should look like this:

.. csv-table::
  :file: _static/tables/mixs-water-template-edited.csv
  :header-rows: 0

Remember to enter sample aliases that correspond to what you use in related publications. This will enable readers to find sample-specific metadata and read files, even if you only state a Project accession number in your paper. Sample aliases can, furthermore, be optionally displayed as *Unique name* in the *Sample report*.

Step 3e: Add sample metadata
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Before adding actual sample metadata to your spreadsheet, take a close look at ENA's explanations of selected attributes and lists of permitted values. These are available in the `Sample Checklists browser <https://www.ebi.ac.uk/ena/browser/checklists>`_. Also note the following:

- **Taxon attributes for metabarcoding samples may be confusing**. In this context, the *tax_id* & *scientific_name* attributes do not typically refer to *sequenced* organisms, but rather describe *sampled* organisms or environments. The *scientific_name* value *spider metagenome* is, for example, used to describe samples from a spider or spider body part, i.e. not samples from which you have derived spider sequences. The attributes *tax_id* & *scientific_name* should thus be selected from the list of `environmental and organismal metagenomes in NCBI's taxonomy browser <https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=408169>`_. For host-associated samples, also differentiate between these generic attributes (i.e. *tax_id* & *scientific_name*) and *host taxid*, which you can also search for in `NCBI's taxonomy browser <https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi>`_, and should be as specific as possible.

.. |br1| raw:: html

  <br />

- **Some attributes should be selected from ontologies**. To increase searchability, some attribute values should be selected from designated ontologies, which are formal specifications of terms used in certain contexts, and of how these terms relate to each other. You can browse or search the latest versions of ontologies used in ENA submission using the `EMBL-EBI Ontology Lookup Service (OLS) <https://www.ebi.ac.uk/ols/index>`_. You can also use the following direct links as *starting points* for finding valid terms for some mandatory or recommended attributes in a GSC MixS checklists:

  .. csv-table::
    :file: _static/tables/ontology-fields.csv
    :header-rows: 1

  In the linked ontology tree views, click the plus sign next to a highlighted branch to show all instances of that term, and continue downwards until you find the most specific term that accurately describes your data. It is good practice to then register the term together with ontology acronym and accession, e.g: *marine pelagic biome (ENVO:01000023)*.


.. |br2| raw:: html

  <br />

- **Environmental attributes of host-associated samples are ambiguous**. For instance, a spider may, in some sense, be the environment from which a host-associated sample derives. But as the external environment also may be of interest here, we tentatively suggest that you interpret *broad-scale* and *local environmental context* the same way as for non-host-associated samples, and use the most specific instance of *material anatomical entity (UBERON:0000465)* or *plant anatomical entity (PO:0025131)* for the *environmental medium* attribute of host- and plant associated samples, respectively.

.. |br3| raw:: html

  <br />

- **Geographic positions should be given in decimal degrees (DD)**. If conversion is needed, use an online tool, such as the `PGC Coordinate Converter <https://www.pgc.umn.edu/apps/convert/>`_, or the following formula:

  +--------------------+---+-------------------------------------+
  | Decimal Degrees    | = | Degrees + Minutes/60 + Seconds/3600 |
  +--------------------+---+-------------------------------------+
  | *Ex: 58°11'12.34'' = 58 + 11/60 + 12.34/3600 = 58.1868°*     |
  +--------------------------------------------------------------+
  | *Ex: 58°11.21' = 58 + 11.21/60 = 58.1868°*                   |
  +--------------------------------------------------------------+

  The related *Geographic location (country and/or sea)* attribute should be selected from the `INSDC list for countries and seas <https://www.insdc.org/submitting-standards/country-qualifier-vocabulary/>`_.

.. |br4| raw:: html

  <br />

Step 3f: Upload spreadsheet
~~~~~~~~~~~~~~~~~~~~~~~~~~~
With data added, your spreadsheet should look similar to this (admittedly, we have added a manufacturer name to the sequencing method ontology term, as it seemed to be missing from this specific device):

.. csv-table::
  :file: _static/tables/mixs-water-template-filled.csv
  :header-rows: 0

If so, go back to *Samples | Register Samples*, click *Upload filled spreadsheet to register samples*, select your edited \*.tsv file, and click *Submit Completed Spreadsheet*. Given that your spreadsheet structure is correct, you will receive a confirmation message, and your samples should now be listed under *Samples | Samples Report*. Note that you need to click *Show unique name* to display sample aliases there.

Step 4: Prepare and upload read files
---------------------------------------------
Before starting submission of reads and experiment data, you need to prepare and upload read files to your own directory in the Webin file upload area. We assume that you have paired-end reads in FASTQ format, like the example files from the `mothur MiSeq SOP <https://www.mothur.org/wiki/MiSeq_SOP>`_ that we use below, but please refer to `ENA's guidelines on file formats <https://ena-docs.readthedocs.io/en/latest/fileprep/reads.html>`_ for other options:

Step 4a: Compress files and calculate checksums
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On a Mac, open the Terminal app (in *Applications | Utilities*), and do the following:

.. code-block:: bash

  # Go to read file directory
  # Tip: type 'cd ' and then drag/drop folder from Finder into Terminal
  cd ~/your-read-file-dir

  # Compress read files, if they are uncompressed (edit file extension as needed)
  gzip -k *.fastq

To enable verification of file integrity after upload, calculate the md5 checksum of each (compressed) read file:

.. code-block:: bash

  # Calculate and print md5 sums to tab-separated file (for easy cut-and-paste later)
  for f in *.gz; do md5 $f | awk '{ gsub(/\(|\)/,""); print $2"\t" $4 }'; done > md5sums.tsv

The resulting file should look similar to this:

.. csv-table::
  :file: _static/tables/md5sums.csv
  :header-rows: 0

The *md5sum* command should work similarly on a Linux machine, but Windows users may need to install some application to compress files to \*.gz format, and do a quick web search for *how to generate MD5 checksum for file on Windows*.

Step 4b: Upload read files to ENA
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
You can now upload your sequence reads to ENA's transit area, but remember to keep local copies of your data. There are several FTP (File Transfer Protocol) clients available for file transfer. We describe one alternative (`lftp <https://formulae.brew.sh/formula/lftp>`_) for Mac users, but please refer to `ENA's guidelines on file upload <https://ena-docs.readthedocs.io/en/latest/fileprep/upload.html>`_ for other options:

.. code-block:: bash

  # Connect to FTP server [replace X:s, and provide password when prompted]
  lftp webin2.ebi.ac.uk -u Webin-XXXXX
  # Expected response: lftp Webin-XXXXX@webin2.ebi.ac.uk:~>

  # Transfer your read files
  mput ~/your-read-file-dir/*.fastq.gz
  # Expected response: ... Total x files transferred

  # Disconnect from server
  bye


Step 5: Submit sequence reads
-----------------------------
Once you have successfully uploaded your sequence reads, you need to associate them with already submitted sample metadata, as well as describe the sequencing *experiment* that produced the read files. In `the ENA metadata model <https://ena-docs.readthedocs.io/en/latest/general-guide/metadata.html>`_, an *experiment* refers to a sequencing event, and contains information on e.g. library construction and instruments, whereas *runs* represent the read files resulting from an experiment.

Step 5a: Download the experiment/run template
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Go to *Raw Reads (Experiments and Runs) | Submit Reads*, click *Download spreadsheet template for Read submission*, and select your file format. We assume you want to *Submit paired reads using two Fastq files*, here. Again, *Mandatory Fields* have been pre-selected for you, but you can also add *Optional Fields*. Have a look at permitted values before downloading your template (or simply return to this page later).

Your downloaded spreadsheet template should look something this:

.. csv-table::
  :file: _static/tables/run-exp-template.csv
  :header-rows: 0

Step 5b: Describe experiment and runs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In your downloaded template, you need to link each experiment/run row to an already submitted sample and study by adding the correct Sample and Study *Accession* values under the *sample* and *study* headers. Then, for metabarcoding data, you would typically use the following values to describe sequenced libraries (but see `ENA's guidelines on experiment metadata <https://ena-docs.readthedocs.io/en/latest/reads/webin-cli.html>`_ for all available options):

•	**library source:** METAGENOMIC

.. |br6| raw:: html

  <br />

•	**library selection:** PCR

.. |br5| raw:: html

  <br />

•	**library strategy**: AMPLICON

.. |br7| raw:: html

  <br />

Also add the following metadata for read files:

•	**forward [reverse]_file_name:** If you put your read files directly into your account (in step 4b), you add filenames *only* here. Otherwise, enter paths including all subdirectories.

.. |br8| raw:: html

  <br />

•	**forward [reverse]_file_md5:** Paste the md5 checksums from Step 4a.

Your spreadsheet should now look similar to this (but add as much optional metadata as possible):

.. csv-table::
  :file: _static/tables/run-exp-template-filled.csv
  :header-rows: 0

If so, go back to *Raw Reads (Experiments and Runs) | Submit reads*, click *Upload filled spreadsheet template for Read submission*, select your edited \*.tsv file, and click *Submit Completed Spreadsheet*. If your submission is confirmed, you should now be able to se your submitted runs in the *Raw Reads (Experiments and Runs) | Run Files Report*.

Step 6: Submit to production service
------------------------------------
After careful inspection of metadata, you can now repeat the process in the `production version of the Webin interface <https://www.ebi.ac.uk/ena/submit/webin/login>`_.

Post-submission editing
***********************
In each row of the above mentioned *Reports*, you can click the box-arrow icon |action-icon| in the *Action* column to either show related items, e.g. see runs linked to a certain sample, or inspect/edit the underlying xml of a submitted item. But for more complex edits you likely need to `contact ENA`_ and ask them to help you cancel and resubmit data.

.. _contact ENA: datasubs@ebi.ac.uk

.. |action-icon| image:: _static/images/action-icon.png
