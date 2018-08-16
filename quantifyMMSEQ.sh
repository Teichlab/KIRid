#!/bin/bash

# check arguments
if [ "$#" -ne 2 ]; then
    echo -e "\nIllegal number of arguments.\n"

    echo "Usage: quantifyMMSEQ.sh fastqDir fileMap.tab"
    echo -e "\tfastqDir: full path to the directory containing the single cell fastq files"
    echo -e "\thfileMap.tab: a tab separated text file showing the mapping of each cell file to each individual (one per line, e.g. 23728_3#176	individual_1)"
    echo -e "Output: see the MMSEQ github pages for a description of the output\n"
    exit 1
fi

file=$2
dir=$1

declare -A filemap  
while read -r line
do
    name="$line"
    IFS=$'\t'
    parts=($line)
    echo "added individual ${parts[1]} with info ${parts[0]}"
    filemap[${parts[1]}]=${parts[0]}
done < "$file"

for i in "${!filemap[@]}"
do
    echo "individual: $i | cell: ${filemap[$i]}"
    kallisto pseudo -i $i.kallisto --pseudobam -o ${filemap[$i]}.kout $dir/${filemap[$i]}_1.fq.gz $dir/${filemap[$i]}_2.fq.gz | samtools-dev view -F 0xC -bS - | samtools-dev sort -n -o ${filemap[$i]}.namesorted.bam -
    mkdir ${filemap[$i]}.mout
    bam2hits-linux $i.fasta ${filemap[$i]}.namesorted.bam  > ${filemap[$i]}.mout/${filemap[$i]}.hits
    mmseq-linux ${filemap[$i]}.mout/${filemap[$i]}.hits ${filemap[$i]}.mout/${filemap[$i]}
done

		
