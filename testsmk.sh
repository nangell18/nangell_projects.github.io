#!/bin/bash
#
#SBATCH --job-name=testsmk
#SBATCH --ntasks=1
#SBATCH --time=6:00:00

module load SAMtools/1.9-iccifort-2019.1.144-GCC-8.2.0-2.31.1
module load Bowtie2/2.3.5.1-GCC-8.2.0-2.31.1
module load Trimmomatic/0.38-Java-1.8
module load pigz/2.4-GCCcore-8.2.0
module load FastQC/0.11.9-Java-11
module load snakemake
snakemake --verbose -s test.smk
module purge

