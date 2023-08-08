# cgg-toolkit
CGG toolkit version 1.0.1
## Excerpt from abstract:

We re-launch a range of established software components for computational genomics, as legacy version 1.0.1, suitable for sequence matching, masking, searching, clustering and visualization for protein family discovery, annotation and functional characterization on a genome scale.

These applications are made available online as open source and include MagicMatch, GeneCAST, support scripts for CoGenT-like sequence collections, GeneRAGE and DifFuse, supported by centrally administered bioinformatics infrastructure funding.

The toolkit may also be conceived as a flexible genome comparison software pipeline that supports research in this domain.

## modified from Figure 2 legend:
### pre-processing:
- MagicMatch: facilitates cross-indexing of entries at the sequence level or simply identification.
- GeneCAST: masks compositional bias in protein sequences and prepares query for sensitive searches.
- cogent_utils: creates a uniformly named sequence set.
### post-processing:
(following a BLAST search) - 
- clustt_utils: launches Tribe-MCL and generates protein families, and input for network visualization.
- GeneRAGE: clusters protein sequence similarity tables (pairs-list) for protein family (and domain) detection.
- DifFuse: similarly to GeneRAGE, detects gene fusion events within a single genome.

