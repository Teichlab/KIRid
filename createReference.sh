#! /bin/bash

# check arguments
if [ "$#" -ne 2 ]; then
    echo -e "\nIllegal number of arguments.\n"

    echo "Usage: createReference.sh fastafile.fa haplotypeMap.tab"
    echo -e "\tfastaFile.fa: a FASTA file containing reference cDNA sequences (e.g. from Ensembl)"
    echo -e "\thaplotypeMap.tab: a tab separated file specifying which genes are present (separated with |) in each individual (one per line, e.g. individual_1	KIR2DL1|KIR2DL2|KIR2DL3|KIR2DS2|KIR2DP1|KIR2DS4|KIR3DL1)"
    echo -e "Output: a personalised reference FASTA file is created in the current directory for each individual\n"
    exit 1
fi

fastafile="$1" 
hapfile="$2"

declare -A hapmap  
while read -r line
do
    name="$line"
    IFS=$'\t'
    parts=($line)
    echo "added individual ${parts[0]} with info ${parts[1]}"
    hapmap[${parts[0]}]=${parts[1]}
done < "$hapfile"

# create a general reference by putting together the reference fasta file 
# provided, removing any eventual KIR genes from it and add in the KIR 
# sequences from the IPD-DB
newfastafile=all.fasta

# remove KIRs from ensembl annotation 
fastagrep.sh -v 'gene_symbol:KIR[0-9]' $fastafile > temp.fa
	
# merge ensembl and ipd
cat temp.fa KIR_cdna.fasta > $newfastafile	
rm temp.fa

# create individual references
# build kallisto indexes
for i in "${!hapmap[@]}"
do
    echo "individual: $i"
    echo "genes: ${hapmap[$i]}"
    fastagrep.sh -v "${hapmap[$i]}" $newfastafile > $i.fasta
    kallisto index -i $i.kallisto $i.fasta
done

