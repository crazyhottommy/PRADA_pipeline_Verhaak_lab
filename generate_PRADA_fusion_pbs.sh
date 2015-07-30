#! /bin/bash

set -e
set -u
set -o pipefail


if [ "$#" -ne  1 ] # is there  1 argument for the analysis id?
then
	echo "error:  arguments not correct, you provided $#, 1 required"
	echo "usage: ./generate_PRADA_fusion_pbs.sh TCGA_analysis_id"
	exit 1
fi

sample_id=$1

# go into the folder containing the folder containing the raw fastq files and 
# the GATKrecalibrated realigned bam files from the preprocess steps.

cd /scratch/genomic_med/mtang1/fusion/UVM/$sample_id

bamfile=$(ls *bam)

# the -junL should set 80% of your reads length

job_string="
#PBS -V
#PBS -N $sample_id
#PBS -j oe
#PBS -o /scratch/genomic_med/mtang1/fusion/UVM/$sample_id/$sample_id.fusion.log
#PBS -m abe
#PBS -M mtang1@mdanderson.org
#PBS -l nodes=1:ppn=3,mem=10gb
#PBS -l walltime=3:00:00
#PBS -d /scratch/genomic_med/mtang1/fusion/UVM/$sample_id

# PRADA needs biopython 
module load Python/2.7.6-anaconda

/scratch/genomic_med/mtang1/PRADA/pyPRADA_1.2/prada-fusion \\
 -bam /scratch/genomic_med/mtang1/fusion/UVM/$sample_id/$bamfile \\
 -conf /scratch/genomic_med/mtang1/PRADA/pyPRADA_1.2/conf.txt -tag $sample_id -mm 1 -junL 40 \\
 -outdir /scratch/genomic_med/mtang1/fusion/UVM/$sample_id/fusion"
 
 
# you need to quote your job_string variable to print the multi-lines
# it is a good practice to quote all your variables 

echo "$job_string" > $sample_id.fusion.pbs
echo "$sample_id.fusion.pbs generated in the /scratch/genomic_med/mtang1/fusion/UVM/$sample_id folder"





