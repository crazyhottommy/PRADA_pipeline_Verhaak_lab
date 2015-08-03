#! /bin/bash

# author: Ming Tang 07/15/2015 
# this script is used to consolidate all the *fus.summary.txt files
# annotate the fusion calls with the analysis_id, sample_id and TCGA barcode 

set -e
set -u
set -o pipefail

# loop through all the *summary.txt files
# if there are any fusion calls for this file (line number > 1), delete the header,
# add the basename of the *summary.txt file, which is the analysis_id to the
# first column. concatenate all the fusion calls together.

# summary.tsv file contains all the other informations, annotate the merged_fusion calls
# with TCGA barcode and sample_id (UUID)

for file in *fus.summary.txt; do

	# if there are any fusion calls
	# the frist line is the header line
	line_num=$(wc -l $file |  awk '{print $1}')
	if [ $line_num -gt 1 ]
	then
		analysis_id=$(basename $file .fus.summary.txt)
		# delete the first line (header) for each file, add analysis id to the first column	
		cat $file | sed '1d'| awk -v id="$analysis_id" '$1=id"\t"$1'  OFS="\t" >> merged_no_header.txt
	fi
done

# add back the header
# it is really anoying when you have to deal with headers, check the `body` function here https://github.com/crazyhottommy/data-science-at-the-command-line/blob/master/tools/body

header=$(head -1 $(ls -1 *fus.summary.txt | head -1))

# the new header has analysis_id as the first column
printf "analysis_id\t$header\n" > header.txt
cat header.txt merged_no_header.txt > merged_fusion_calls.txt
rm merged_no_header.txt
rm header.txt

# if you do not like the intermediate header.txt file:
# printf "analysis_id\t$header\n" | cat - merged_fusion_calls.txt > merged_fusion_calls.txt

# use body function to maintain the header and only sort the body and join the two files with analysis_id column
# in order for join to work, two files need to be sorted. You can do it in R or by mysql, I just like using linux commands...
# the -t flag is to indicate the output and input seprator. -t "\t" does not work, -t $'t' works
join -t $'\t' -1 1 -2 2 <(cat merged_fusion_calls.txt | body sort -k1,1) <(cat annotation.txt | body sort -k2,2) > annotated_fusion_calls.txt


# The inner-joined file has TCGA barcode and sample_id in the last two columns, I want to move them to the second and third column
# cut command can not reorder the columns, I use csvcut from the csvkit library http://csvkit.readthedocs.org/en/latest/tutorial/1_getting_started.html#csvcut-data-scalpel

# command line tools from csvkis alwasy use comma as input and output delimiter. Use -t to specify input is tab delimited and -T to specify
# output is tab delimited.

csvcut -t -c 1,18,19,2-17 annotated_fusion_calls.txt | csvformat -T > fusion_calls_with_TCGA_barcode.txt 


