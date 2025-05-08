# cgg-toolkit
CGG toolkit version 1.0.1
Citation: Vasileiou D, Karapiperis C, Baltsavia I,
Chasapi A, Ahrén D, Janssen PJ, et al. (2023) CGG
toolkit: Software components for computational
genomics. PLoS Comput Biol 19(11): e1011498.
https://doi.org/10.1371/journal.pcbi.1011498

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

---

## Getting Started with Docker

### 1. Install Docker
- Download and install Docker Desktop from [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/) (Windows/Mac)
- For Linux, follow instructions at [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)
- (Optional) Install Docker Compose if not included: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

### 2. Build the Toolkit Docker Images
From the project root directory, run:
```sh
docker compose build
```

### 3. Prepare Your Data
- Place your input files (FASTA, BLAST outputs, etc.) in the `./data` directory in the project root.

---

## Running the Tools with Docker Compose

### MagicMatch
**Description:** Cross-references sequence identifiers across databases or finds identicals between FASTA files.

**Example:**
```sh
docker compose run --rm magicmatch -f /workspace/data/example.fasta -t
```
- See help: `docker compose run --rm magicmatch -h`

---

### GeneCAST
**Description:** Masks compositional bias in protein sequences and prepares queries for sensitive searches.

**Example:**
```sh
docker compose run --rm genecast /workspace/data/example.fasta
```
- See help: `docker compose run --rm genecast -h`

---

### CoGenT Utils
**Description:** Converts FASTA files to CoGenT-style identifiers for consistent, reproducible sequence naming.

**Batch convert all FASTA files in `./data` to CoGenT format:**
```sh
docker compose run --rm cogent /workspace/data /workspace/data/output_folder
```
- Output files will be in `./data/output_folder` on your host.
- See help: `docker compose run --rm cogent -h`

---

### Clustt Utils (MCL Clustering)
**Description:** Generates sequence similarity graphs and clusters protein families using the MCL algorithm.

**Example:**
```sh
docker compose run --rm clustt /workspace/data/meth_v_meth.m8.blastout /workspace/data/families.txt 1.8
```
- Input: BLAST tabular pairs file
- Output: `families.txt` and intermediate files in `./data`
- See help: `docker compose run --rm clustt -h`

---

### GeneRAGE
**Description:** Clusters protein sequence similarity tables for protein family and domain detection.

**Example:**
```sh
docker compose run --rm generage example.fasta example.parsed
```
- Input: FASTA file and parsed BLAST results (both in `./data`)
- Output: `clusters.out`, `paralogues.out`, etc. in `./data`
- See help: `docker compose run --rm generage -h`

---

### DifFuse
**Description:** Detects gene fusion events within a single genome (see `4_generage/diffuse/` for usage).

**Example:**
```sh
docker compose run --rm genefuse /workspace/data/meth.fasta /workspace/data/sach2.fasta /workspace/data/meth_v_meth.m8.blastout /workspace/data/meth_v_sach.m8.blastout -verbose -rand 1000
```

---

## Notes
- All file paths inside the container should use `/workspace/data/`.
- Output files will appear in your `./data` directory on the host.
- For more details on each tool, see the respective README files in each subfolder.

---

