# PRADA RNA-seq fusion pipeline in the Verhaak lab

### Introduction

PRADA is a tool to identify fusion genes in cancers from RNA-seq data developed at [Verhaak 
lab](http://odin.mdacc.tmc.edu/~rverhaak/) in MD Anderson Cancer Center.  
PRADA can be downloaded from 
[here](http://bioinformatics.mdanderson.org/main/PRADA:Overview). 

This repo is for PRADA pipeline analzying TCGA RNA-seq data sets with the MD Anderson high-performance
computing cluster. 

**The scripts are still hard coded...you will need to tweak it to adapt to your own use.**  
change path names etc..


Special thanks to Kathy Hu and Siyuan Zheng in the Verhaak lab in helping me with all the questions.

### Installation 
login to your HPC and you are at your home folder:
`pwd`    
`/scratch/genomic_med/mtang1`

Make a new folder called PRADA  
`mkdir PRADA`  
`cd PRADA`  
`wget 
http://sourceforge.net/projects/prada/files/pyPRADA/pyPRADA_1.2.tar.gz/download`  

A file named `download` will appear in the folder. untar the file   
`tar -xvzf download`  
a folder named `pyPRADA_1.2` will appear in the current folder.  

remove the downloaded file  
`rm download`  


### Reference  files

Download the [hg19 reference files](http://bioinformatics.mdanderson.org/Software/PRADA/) into 
`PRADA` folder you generated above, untar it to a folder `PRADA-ref-hg19`

In the `PRADA` folder, index the genome files with bwa:

`./pyPRADA_1.2/tools/bwa-0.5.7-mh/bwa index -a bwtsw  ./PRADA-ref-hg19/Ensembl64.transcriptome.fasta`  
`./pyPRADA_1.2/tools/bwa-0.5.7-mh/bwa index -a bwtsw  ./PRADA-ref-hg19/Ensembl64.transcriptome.formatted.fasta`  
`./pyPRADA_1.2/tools/bwa-0.5.7-mh/bwa index -a bwtsw  ./PRADA-ref-hg19/Ensembl64.transcriptome.plus.genome.fasta`  
`./pyPRADA_1.2/tools/bwa-0.5.7-mh/bwa index -a bwtsw  ./PRADA-ref-hg19/Homo_sapiens_assembly19.fasta`  

The configuration files can be found in the repo.

### Use the scripts
If you go to [cghub](https://browser.cghub.ucsc.edu/) and select "TCGA", "Uveal Melanoma" "unaligned" Assembly,
it will give you only 80 entries, add all to cart and download the `summary.tsv` file.  

Go [here](https://cghub.ucsc.edu/manifest_description.html) to check the meaning of the column names:
 
|  index | column               | description                                                                                                                                                                                                                                          | example(s)                                                                                                                                                                                                   |
| ------ | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1      | study                | study accession number                                                                                                                                                                                                                               | phs000178 (for TCGA)                                                                                                                                                                                         |
| 2      | barcode              | full TCGA aliquot barcode for sample                                                                                                                                                                                                                 | TCGA-61-1734-01B-01W-0722-08                                                                                                                                                                                 |
| 3      | disease              | the code (short abbreviation) for the specific disease                                                                                                                                                                                               | GBM                                                                                                                                                                                                          |
| 4      | disease_name         | the full name for the specific disease                                                                                                                                                                                                               | Glioblastoma multiforme (abbreviated GBM above)                                                                                                                                                              |
| 5      | sample_type          | a multi-letter code for the sample type                                                                                                                                                                                                              | NB (Blood Derived Normal); TP (Primary solid Tumor); CELL (Cell Lines); NEBV (EBV Immortalized Normal)                                                                                                       |
| 6      | sample_type_name     | a brief description of the sample type                                                                                                                                                                                                               | Blood Derived Normal; Primary solid Tumor; Cell Lines; EBV Immortalized Normal                                                                                                                               |
| 7      | analyte_type         | analyte designation                                                                                                                                                                                                                                  | RNA; DNA; WGA and WGA X for Whole Genome Amplification (WGA) by different processes                                                                                                                          |
| 8      | library_type         | the type of sequencing done on the sample                                                                                                                                                                                                            | WXS (whole exome); WGS (whole genome); RNA-Seq; VALIDATION (additional re-sequencing for mutation call evaluation)                                                                                           |
| 9      | center               | the code (short abbreviation) for the center which submitted the analysis file to CGHub                                                                                                                                                              | BI;BCM;WUGSC;UNC-LCCC;BCCAGSC;HMS-RK;USC-JHU                                                                                                                                                                 |
| 10     | center_name          | the full name of the center which submitted the analysis file to CGHub                                                                                                                                                                               | Broad Institute of MIT and Harvard; Baylor College of Medicine                                                                                                                                               |
| 11     | platform             | the controled name of the manufacturer of the sequencer used to sequence the sample                                                                                                                                                                  | ILLUMINA; ABI_SOLID; LS454                                                                                                                                                                                   |
| 12     | platform_name        | the display name of the manufacturer of the sequencer used to sequence the sample                                                                                                                                                                    | Illumina; ABI Solid; 454                                                                                                                                                                                     |
| 13     | assembly             | the version of the human reference assembly used to align against                                                                                                                                                                                    | HG18; HG19; GRCh37-lite; HG19_Broad_variant; GRCh37-lite-+-HPV_Redux-build                                                                                                                                   |
| 14     | filename             | name of the data file on disk at CGHub. this is submitting center dependent and is not controlled or validated by CGHub; in most cases it will end in a .bam, or a .tar.gz for FASTQ files                                                           | TCGA-61-1734-01B-01W-0722-08_IlluminaGA-DNASeq_capture.bam; UNCID_2189775.731721fa-4ced-445d-855f-e4ded85f9726.120514_UNC16-SN851_0159_BC0TARACXX_3_CGATGT.tar.gz                                            |
| 15     | file_size            | size of the data file on disk at CGHub in bytes                                                                                                                                                                                                      | 32997835749                                                                                                                                                                                                  |
| 16     | checksum             | MD5 hash of the data file on disk at CGHub                                                                                                                                                                                                           | 6dec3e714f220a06800a3a565e75d3f9                                                                                                                                                                             |
| 17     | analysis_id          | CGHub analysis uuid assigned to every submission, every unique BAM gets its own                                                                                                                                                                      | 5e26998f-a2e4-4b35-972e-dd3c79fa7e65                                                                                                                                                                         |
| 18     | aliquot_id           | uuid of the aliquot as stored at the DCC                                                                                                                                                                                                             | 0070a74d-0453-47f2-afd2-6237911fb8ee                                                                                                                                                                         |
| 19     | participant_id       | uuid of the patient who contributed the sample as stored at the DCC                                                                                                                                                                                  | b5e64bdb-24f1-400d-aaf7-8fda8ab6fd3c                                                                                                                                                                         |
| 20     | sample_id            | uuid of sample as stored at the DCC                                                                                                                                                                                                                  | 43228687-69df-425e-9414-1a853bd31742                                                                                                                                                                         |
| 21     | tss_id               | tissue source site ID combining source institution and study (disease)                                                                                                                                                                               | 02 (MD Anderson Cancer Center:Glioblastoma multiforme); 07 (TGen:Cell Line Control)                                                                                                                          |
| 22     | sample_accession     | NCBI/SRA accession of the sample                                                                                                                                                                                                                     | SRS033033                                                                                                                                                                                                    |
| 23     | published            | date on which an upload could be downloaded (was migrated from NCBI for pre-CGHub submissions)                                                                                                                                                       | 2010-12-28                                                                                                                                                                                                   |
| 24     | uploaded             | date on which an upload was started (was migrated from NCBI for pre-CGHub submissions)                                                                                                                                                               | 2010-08-09                                                                                                                                                                                                   |
| 25     | modified             | last modified date of the analysis entry in the CGHub or SRA metadata database (was migrated from NCBI for pre-CGHub submissions)                                                                                                                    | 2010-12-22                                                                                                                                                                                                   |
| 26     | state                | CGHub phase of the submission, if                                                                                                                                                                                                                    | live;submitting;uploading;validating_data;validating_sample;bad_data;suppressed                                                                                                                              |
| 27     | sample_type_code     | a numeric code for the sample type                                                                                                                                                                                                                   | 10 (Blood Derived Normal); 01 (Primary solid Tumor); 50 (Cell Lines); 13 (EBV Immortalized Normal)                                                                                                           |
| 28     | analyte_type_code    | a single character for the analyte type                                                                                                                                                                                                              | R (RNA); D (DNA); W,G, and X are all codes for Whole Genome Amplification (WGA) by different processes; note these are broadly-defined categories and are therefore not as useful as using the library_type  |
| 29     | platform_full_name   | the extended name including brand and potentially the model                                                                                                                                                                                          | Illumina HiSeq 2000; Complete Genomics; AB SOLiD 4 System                                                                                                                                                    |
| 30     | file_type            | type of the data file on disk at CGHub. If                                                                                                                                                                                                           | fasta;bam                                                                                                                                                                                                    |
| 31     | reason               | cause of being non-live (in case of suppressed, redacted entries); if                                                                                                                                                                                | REDACTED: Subject identity unknown; analysis linked to a pre-existing bam file                                                                                                                               |
| 32     | reagent_vendor(s)    | The vendor of the reagents used during the experiment for this analysis                                                                                                                                                                              | Agilent                                                                                                                                                                                                      |
| 33     | reagent_name(s)      | The name of the reagent used during the experiment for this analysis                                                                                                                                                                                 | Custom V2 Exome Bait, 48 RXN X 16 tubes                                                                                                                                                                      |
| 34     | catalog_number(s)    | The vendor's catalog number for the reagents used (can be unspecified                                                                                                                                                                                | 95061;NA                                                                                                                                                                                                     |
| 35     | is_custom            | yes if the kit is custom, no if it is stock, leave empty for                                                                                                                                                                                         | yes;no;                                                                                                                                                                                                      |
| 36     | target_file(s)       | Either a relative path to the location of the vendor's target file within the repository, or an absolute URL to the target file hosted on the vendor's website (see Target And Probe File URLs and Repository Paths on wiki page)                    | https://bitbucket.org/cghub/cghub-capture-kit-info/raw/c5355788e4e0c0a5002bf30774f7b8aaba2304ca/BI/vendor/Agilent/cancer_2000gene_shift170.targetIntervals.bed                                               |
| 37     | probe_file(s)        | Either a relative path to the location of the vendor's probe file within the repository, or an absolute URL to the target file hosted on the vendor's website (can be unspecified, see Target And Probe File URLs and Repository Paths on wiki page) | https://bitbucket.org/cghub/cghub-capture-kit-info/raw/c5355788e4e0c0a5002bf30774f7b8aaba2304ca/BI/vendor/Agilent/cancer_2000gene_shift170.baitIntervals.bed;   



If you want to work with TCGA data, see [here](https://wiki.nci.nih.gov/display/TCGA/Working+with+TCGA+Data) to get started. 
>A TCGA barcode is composed of a collection of identifiers. Each specifically identifies a TCGA data element. Refer to the following figure for an illustration of how metadata identifiers comprise a barcode. An aliquot barcode, an example of which shows in the illustration, contains the highest number of identifiers. 

![](TCGA_barcode.png)

|  Label      | Identifier for                                                                  | Value | Value description                                    | Possible values                                                                                                                                       |
| ----------- | ------------------------------------------------------------------------------- | ----- | ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Project     | Project name                                                                    | TCGA  | TCGA project                                         | TCGA                                                                                                                                                  |
| TSS         | Tissue source site                                                              | 2     | GBM (brain tumor) sample from MD Anderson            | See Code Tables Report                                                                                                                                |
| Participant | Study participant                                                               | 1     | The first participant from MD Anderson for GBM study | Any alpha-numeric value                                                                                                                               |
| Sample      | Sample type                                                                     | 1     | A solid tumor                                        | Tumor types range from 01 - 09, normal types from 10 - 19 and control samples from 20 - 29. See Code Tables Reportfor a complete list of sample codes |
| Vial        | Order of sample in a sequence of samples                                        | C     | The third vial                                       | A to Z                                                                                                                                                |
| Portion     | Order of portion in a sequence of 100 - 120 mg sample portions                  | 1     | The first portion of the sample                      | Jan-99                                                                                                                                                |
| Analyte     | Molecular type of analyte for analysis                                          | D     | The analyte is a DNA sample                          | See Code Tables Report                                                                                                                                |
| Plate       | Order of plate in a sequence of 96-well plates                                  | 182   | The 182nd plate                                      | 4-digit alphanumeric value                                                                                                                            |
| Center      | Sequencing or characterizationcenter that will receive the aliquot for analysis | 1     | The Broad InstituteGCC                               | See Code Tables Report                                                                                                                                |

I am processing some UVM samples, make a new folder  
`mkdir -p /scratch/genomic_med/mtang1/fusion/UVM`

Inside the `UVM` folder:  
`./gtdownload_preprocess_pbs_generation.sh TCGA_analysis_id` 

`gtdownload_preprocess_pbs_generation.sh` will download the fastq files into a folder named with the TCGA analysis id from cghub, untar the file, rename the fastq files to have suffix *end1.fastq *end2.fastq and generate the pbs files for PRADA preprocessing.

`cat summary.tsv| cut -f17 | sort | uniq | head`  

02cd7e84-7673-46d1-8980-253dbe54ae0a  
046e576b-cf6c-4669-9b8a-18710a2241e1  
0476df29-c667-4803-be37-2d2d19512f36  
062b725c-0a73-4ca1-8b4d-4312305ae937  
081a619d-3c81-41e8-bcd5-a8a5dc06165f  
0a91b66e-f8e9-4425-97f0-d1ff62f44fc7  
0b7f8d10-e786-4030-a5e0-4dc310f477ab  
0b853e3d-40f7-4134-af62-d81ff068811e  
11125e23-fa6c-47b7-baeb-845c5f94c73e  
119c55e8-7e54-4a28-a642-d0bcf42e6b02
  

Example usage:  
Inside the `UVM` folder:    
`./gtdownload_preprocess_pbs_generation.sh  02cd7e84-7673-46d1-8980-253dbe54ae0a`

Go inside the `02cd7e84-7673-46d1-8980-253dbe54ae0a` folder, and submit the pbs file:  
`cd 02cd7e84-7673-46d1-8980-253dbe54ae0a.pbs`  
`msub 02cd7e84-7673-46d1-8980-253dbe54ae0a.pbs`

Inside the `UVM` folder:  
`./generate_PRADA_fusion_pbs.sh 02cd7e84-7673-46d1-8980-253dbe54ae0a` will generate the fusion call pbs files in the `02cd7e84-7673-46d1-8980-253dbe54ae0a` folder. 

`cd 02cd7e84-7673-46d1-8980-253dbe54ae0a`  
`msub 02cd7e84-7673-46d1-8980-253dbe54ae0a.fusion.pbs`  

The sample pbs file and log file can be found in the repo.  

### Timing and resources needed  

Examples: 

1. The RNA-seq fastq zipped files are around 12G, it takes gtdownload around 30mins to download.  

2. After untar the zipped fastq (~12G for end1.fastq and end2.fastq respectively) files, and renamed them. It takes 28hrs, 21G RAM with 12 cpus to finish PRADA preprocessing.

3. It takes ~1 hour to find the fusions using 3 cpus and 3Gb RAM

It all depends on the size of the fastq files and the fusion numbers in the sample. You can tweak the paramters by yourself.

### Output
There will be many files (intermediate files etc) generated after fusion call. The most informative file you want is the *fus.summary.txt file. One example is below:  

|  Gene_A  | Gene_B  | A_chr  | B_chr  | A_strand  | B_strand  | Discordant_n  | JSR_n  | perfectJSR_n  | Junc_n  | Position_Consist  | Junction                                      | Identity | Align_Len  | Evalue | BitScore |
| -------- | ------- | ------ | ------ | --------- | --------- | ------------- | ------ | ------------- | ------- | ----------------- | --------------------------------------------- | -------- | ---------- | ------ | -------- |
| MAPKAPK5 | ACAD10  | 12     | 12     | 1         | 1         | 31            | 19     | 16            | 1       | PARTIALLY         | MAPKAPK5:12:112308984_ACAD10:12:112182447,19  | 95.00    | 20         | 0.002  | 31.9     |

Explanation of each column can be found in the PRADA manual:

>Discordant represents the discordant reads mapping to the gene pair. Junction Spanning Reads (JSR) are reads which maps to the gene-fusion exon junction and the mate end maps to one of the genes in the gene-pair. Perfect JSR are reads with 0 mis-matches. Junction represents the unique exon junctions that were found in the JSR. Position Consistency indicates if the mapping location of the discordant reads is consistent with the location of the spanning reads.
>

In the `UVM` folder, copy all the fusion summary files to a new folder fusion_results  

`find . -name "*fus.summary.txt" | xargs cp -t ./fusion_results`
`cd fusion_results`  
The first line is the header in the summary file.  
`ls -1 | xargs wc -l | awk '$1>1' | wc -l`  
`39`  
Only 39 out of 80 samples have fusions identified by PRADA, and each sample only have serval fusions (max 12).   

1. PRADA is very conservative in finding fusions. In other words, PRDAD is very accurate in finding fusions but may lack sensitivity.  
2. Melanoma samples do not have many fusions according to Siyuan. Liquid tumors have a lot more.    







### Downstream  filtering
