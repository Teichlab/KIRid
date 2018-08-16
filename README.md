KIRquant - quantification of KIR genes using personalised references
What is KIRquant?
The KIR family is highly polymorphic and displays extensive homology between genes, making it challenging to detect and quantify the expression of its members accurately. KIRquant quantifies the expression of KIR genes using full-length single cell RNA-seq data. Briefly, we first perform a genotyping step with KIRid (under development). Subsequently, we build a custom reference for each individual containing all reference transcripts plus all IPD-KIR sequences for the complement of KIR genes present in each individual. Finally, we quantify expression with MMSEQ, a method that disaggregates allele isoform specific expression from multi-mapping reads.

Citing KIRquant
If you use KIRquant, please cite: Manuscript under revision.

Requirements
A Unix system (e.g. Mac OS or Linux).

Installation
Download this repository and move into the downloaded directory:
git clone https://github.com/Teichlab/maternal-fetal-interface.git maternal-fetal-interface
cd KIRquant
chmod a+x *.sh
Download the latest release of MMSEQ, unzip and add the bin directory to your PATH. E.g.:
wget -O mmseq-latest.zip https://github.com/eturro/mmseq/archive/latest.zip
unzip mmseq-latest.zip && cd mmseq-latest
export PATH=`pwd`/bin:$PATH
Download and install the latest release of Kallisto and add it to your PATH.
Download and install the latest release of Samtools and add it to your PATH.
(Optional) Download and install R.
Estimating KIR expression levels
Input files:
FASTQ files for each single cell (paired end reads should be in separate files subscripted _1 and _2, e.g. 23728_3#176_1.fq.gz and 23728_3#176_2.fq.gz)
a FASTA file containing reference transcript sequences to align to (find ready-made files in the MMSEQ github page)
a tab separated text file showing the mapping of each cell to each individual (one cell/file per line). E.g. fileMap.tab:
23728_3#176	individual_1
24088_8#247	individual_2
a tab separated file containing the list of genes absent in each individual (one individual per line). E.g. haplotypeMap.tab:
individual_1    KIR2DS3
individual_2    KIR2DS1|KIR2DS3|KIR2DS5|KIR2DL5|KIR3DS1
Step 1: create personalised reference
./createReference.sh /full/path/to/transcript_reference.fasta /full/path/to/haplotypeMap.tab
Step 2: quantify
./quantifyMMSEQ.sh /full/path/to/fastq/directory/ /full/path/to/fileMap.tab
See the MMSEQ pages for a full description of the output.

Step 3 (optional): read in KIR expression estimates into an R table
ToDo
