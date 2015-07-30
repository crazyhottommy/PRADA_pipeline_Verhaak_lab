#! /bin/bash

# this script will automatically download zipped fastq files from 
# cghub, extract them, rename them and generate a pbs file for PRADA preprocessing
# author: Ming Tang 07/15/2015 (with helps from Kathy Hu in Roel Verhaak lab))


set -e
set -u
set -o pipefail

if [ "$#" -ne  1 ] # are there  1 argument for the analysis id?
then
	echo "error:  arguments not correct, you provided $#, 1 required"
	echo "usage: ./gtdownload_preprocess_pbs_generation.sh TCGA_analysis_id"
	exit 1
fi

sample_id=$1
module load cghub/3.8.6-130

#downloading at the login node, max 5 processes
#put the cghub.key in the same directory of this script

gtdownload -d $1 -c cghub.key -vv --max-children 5

cd $sample_id

tar -zxvf *tar.gz

rm *tar.gz


# change name to *end1.fastq *end2.fastq to comply with the 
# PRADA nameing conventions. PRADA is hard coded..

for file in *fastq
do
new_file=$(echo $file | sed -r "s/(.+)_([1-2]).fastq/\1.end\2.fastq/")
mv $file $new_file
done

echo "fastq files downloaded and renamed"

# go out of the folder containing the renamed fastq files
cd ..

FASdir=`pwd`

#extract the fastq name stripping out the .end1.fastq 
fa=$(ls $FASdir/$sample_id -1 | head -1 | sed -r 's/(.+).end1.fastq/\1/')

# running prada-preprocess-bi will generate pbs file for the pre-processing steps.

/scratch/genomic_med/mtang1/PRADA/pyPRADA_1.2/prada-preprocess-bi \
  -conf /scratch/genomic_med/mtang1/PRADA/pyPRADA_1.2/conf.txt \
  -inputdir $FASdir/$sample_id -sample $fa  -tag $fa -step 2_e1_1 \
  -pbs $sample_id -outdir $FASdir/$sample_id -submit no

echo "PBS file generated: $FASdir/$sample_id/$fa.pbs"




