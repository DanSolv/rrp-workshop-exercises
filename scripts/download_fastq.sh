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

# Create directory (if it doesn't exist)
mkdir -p "$fastq_dir"

#### Obtain and process R1 fastq file
# -O file retains the original filename
echo "Obtaining $fastq_r1 ..."
curl -O $fastq_url/$fastq_r1

echo "Obtaining $fastq_r2 ..."
curl -O $fastq_url/$fastq_r2

# Explore the file
echo "The number of lines in $fastq_r1 is...drumroll...."
gunzip -c $fastq_r1 | wc -l
echo "The number of lines in $fastq_r2 is...drumroll...."
gunzip -c $fastq_r2 | wc -l

# Move to the appropriate directory
mv $fastq_r1 $fastq_dir
echo "$fastq_r1 moved to $fastq_dir"
mv $fastq_r2 $fastq_dir
echo "$fastq_r2 moved to $fastq_dir"