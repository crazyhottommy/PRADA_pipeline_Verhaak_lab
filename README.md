# PRADA pipeline in Verhaak lab

This repo is for the PRADA pipeline at [Verhaak 
lab](http://odin.mdacc.tmc.edu/~rverhaak/) in MD Anderson Cancer Center.  
PRADA can be downloaded from 
[here](http://bioinformatics.mdanderson.org/main/PRADA:Overview). 

**The scripts are still hard coded...you will need to tweak it to adapt to your own use.**  
change path names etc..

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

Go [here](https://cghub.ucsc.edu/manifest_description.html) to check the meaning of the column names  

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
`generate_PRADA_fusion_pbs.sh 02cd7e84-7673-46d1-8980-253dbe54ae0a` will generate the fusion call pbs files in the `02cd7e84-7673-46d1-8980-253dbe54ae0a` folder. 

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


 




### Downstream  filtering
