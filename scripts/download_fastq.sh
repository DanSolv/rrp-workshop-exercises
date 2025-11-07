#!/bin/bash

#error handling for script
set -euo pipefail 

#set wd to this files directory
cd "$(dirname "${BASH_SOURCE[0]}")"

#"constant" variables
study_id="SRP255885"
fastq_url="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR115/089/SRR11518889"

# Define files and directories
fastq_r1="SRR11518889_1.fastq.gz"
fastq_r2="SRR11518889_2.fastq.gz"
fastq_dir="../data/raw/fastq/$study_id"
trimmed_dir="../data/trimmed/$study_id"
reports_dir="../reports/fastp"
# Create directory (if it doesn't exist)
mkdir -p "$fastq_dir"
mkdir -p "$trimmed_dir"
mkdir -p "$reports_dir"
#### Obtain and process R1 fastq file
# -O file retains the original filename

if [ ! -f "$fastq_dir/$fastq_r1" ]; then
   curl -O $fastq_url/$fastq_r1
   echo "Obtaining $fastq_r1 ..."
else
    echo "$fastq_r1 already exists. Skipping download."
fi

if [ ! -f "$fastq_dir/$fastq_r2" ]; then
   curl -O $fastq_url/$fastq_r2
   echo "Obtaining $fastq_r2 ..."
else
    echo "$fastq_r2 already exists. Skipping download."
fi



# Move to the appropriate directory
if [ -f $fastq_r1 ]; then
mv $fastq_r1 $fastq_dir
echo "$fastq_r1 moved to $fastq_dir"
fi
if [ -f $fastq_r2 ]; then
mv $fastq_r2 $fastq_dir
echo "$fastq_r2 moved to $fastq_dir"
fi



# Explore the file
echo "The number of lines in $fastq_r1 is...drumroll...."
gunzip -c $fastq_dir/$fastq_r1 | wc -l
echo "The number of lines in $fastq_r2 is...drumroll...."
gunzip -c $fastq_dir/$fastq_r2 | wc -l


## Trim the files with fastp
fastp \
  --in1 $fastq_dir/$fastq_r1 \
  --in2 $fastq_dir/$fastq_r2 \
  --out1 $trimmed_dir/$fastq_r1 \
  --out2 $trimmed_dir/$fastq_r2 \
  --html "$reports_dir/${study_id}_report.html" \
  --json "$reports_dir/${study_id}_report.json"