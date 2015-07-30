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

### Downstream  filtering
