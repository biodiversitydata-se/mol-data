.. toctree::
   :hidden:

.. role:: red

Taxonomic annotation of ASVs
===============================
We perform a standard taxonomic annotation of all ASVs submitted to SBDI, using current versions of selected classification algorithms and reference databases. This standard annotation will (eventually) provide the valid and searchable taxonomy of the ASV, although the original, user-provided annotation will also be stored and displayed (under 'previousIdentifications' in the Bioatlas). The taxonomy issue is, however, further complicated by the fact that data also need to be indexed against the taxonomy backbone of the Bioatlas (based on the `GBIF taxonomy backbone <https://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c>`_), for them to become fully accessible in the atlas. While the current taxonomy covers a huge amount of names, it still has poor coverage of some organism groups, such as prokaryotes and protists. This means that the taxonomy of some ASVs will differ between the ASV database and the Bioatlas. We are working hard to solve this problem. We also plan to perform regular re-annotations, to enable identification at lower taxonomic levels as reference databases grow and improve. We describe current methods and reference databases below:

Fungi
*****
Reference database
------------------
`UNITE USEARCH/UTAX release for Fungi. Version 18.11.2018. <https://doi.org/10.15156/BIO/786345>`_

Algorithm
----------
The ITSx tool version 1.1-beta [1] is used to extract the ITS2 region, which is then used to predict the taxonomy with the SINTAX classifier [2] as implemented in VSEARCH (version 2.10.4) [3] and the USEARCH/UTAX reference dataset (version 8.0) [4].

[1] Bengtsson‐Palme, J., Ryberg, M., Hartmann, M., Branco, S., Wang, Z., Godhe, A., De Wit, P., Sánchez‐García, M., Ebersberger, I., & de Sousa, F. (2013). Improved software detection and extraction of ITS1 and ITS 2 from ribosomal ITS sequences of fungi and other eukaryotes for analysis of environmental sequencing data. Methods in ecology and evolution, 4(10), 914-919.

[2] R.C. Edgar (2016), SINTAX: a simple non-Bayesian taxonomy classifier for 16S and ITS sequences, https://doi.org/10.1101/074161

[3] Rognes T, Flouri T, Nichols B, Quince C, Mahé F. (2016) VSEARCH: a versatile open source tool for metagenomics. PeerJ 4:e2584. doi: 10.7717/peerj.2584

[4] UNITE Community (2019): Full UNITE+INSD dataset for Fungi. Version 18.11.2018. UNITE Community. https://doi.org/10.15156/BIO/786347

Prokaryotes
***********
Reference database
------------------
`SILVA v132. SSU Ref NR 99 <https://www.arb-silva.de/documentation/release-132>`_ (representative 16S sequences with 99% dereplication), trained with primers NNNNCCTACGGGNGGCWGCAG and GACTACHVGGGTATCTAATCC.

Algorithm
---------
QIIME2 naive Bayes machine-learning classifier, as a part of `the ampliseq pipeline <https://nf-co.re/ampliseq>`_ for denoising and taxonomic annotation.
