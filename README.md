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

Go [here](https://cghub.ucsc.edu/manifest_description.html) to check the meaning of the column names.

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

2. After untar the zipped fastq (~12G for end1.fastq and end2.fastq respectively) files, and renamed them. It takes ~28hrs, ~25G RAM with 12 cpus to finish PRADA preprocessing.

3. It takes ~1 hour to find the fusions using 2 cpus and ~4Gb RAM

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

The *fus.summary.txt files only has the analysis_id as their basenames.
concatenate them together and annoate with `TCGA_barcode` and `sample_ids`:
`cat ../../data/summary.tsv | cut -f2,17,20 > annotation.txt`  
`./merge_fusion_calls.sh`  

A file named `fusion_calls_with_TCGA_barcode.txt` will be generated.  

One can sort based on the fourth column (fusion `Gene_A`) and (fusion `Gene_B`) to get an idea of recurrent fusion points.   

`cat fusion_calls_with_TCGA_barcode.txt | body sort -k4,4 -k5,5 > fusion_calls_with_TCGA_barcode.sorted.txt`  

`wc -l fusion_calls_with_TCGA_barcode.sorted.txt`   
`79`   
only 78 fusions events were found in these particular data sets.   

### Downstream  filtering

According to Kosuke Yoshihara et.al [The landscape and therapeutic relevance of cancer-associated transcript fusions](http://www.nature.com/onc/journal/vaop/ncurrent/full/onc2014406a.html)  

> In this study, we extracted fusions (1) with at least two discordant read pairs, (2) at least one junction spanning reads and (3) without high gene homology between each fusion gene partner (E-value>0.001)

I filtered the fusion calls based on the `Discordant_n`, `JSR_n` and `Evalue` column:    
maintaing the header  
`cat fusion_calls_with_TCGA_barcode.sorted.txt | awk ' NR ==1 || ($10 > 1 && $11 > 0 && $18 > 0.001)' | tee fusion_calls_with_TCGA_barcode.sorted.filtered.txt| wc -l`  
`58`
 
After filtering, only 57 fusions were remained.

