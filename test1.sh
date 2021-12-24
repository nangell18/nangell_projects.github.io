#!/bin/bash
#
#SBATCH --job-name=test1
#SBATCH --output=test1.txt
#SBATCH --node=1
#SBATCH --tasks-per-cpu=20

module load FastQC/0.11.8-Java-1.8
fastqc /data/inbre-bioinfo/Weicksel/pipe4C-master/example/*.fastq.gz \
    -o /data/inbre-bioinfo/Weicksel/practice1/shOut/trimmed -t $SLURM_CPUS_ON_NODE
module unload FastQC/0.11.8-Java-1.8

module load Trimmomatic/0.32-Java-1.7.0_80
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.32.jar SE -trimlog /data/inbre-bioinfo/Weicksel/practice1/shOut/trim_log1.txt \
    /data/inbre-bioinfo/Weicksel/pipe4C-master/example/reads_set_1_viewpoint_10_ESC_replicate_1.fastq.gz \
	/data/inbre-bioinfo/Weicksel/practice1/shOut/trimmo/trimmed1.fastq.gz HEADCROP:24 SLIDINGWINDOW:4:15 MINLEN:20
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.32.jar SE -trimlog /data/inbre-bioinfo/Weicksel/practice1/shOut/trim_log2.txt \
    /data/inbre-bioinfo/Weicksel/pipe4C-master/example/reads_set_1_viewpoint_10_ESC_replicate_2.fastq.gz \
        /data/inbre-bioinfo/Weicksel/practice1/shOut/trimmo/trimmed2.fastq.gz HEADCROP:24 SLIDINGWINDOW:4:15 MINLEN:20
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.32.jar SE -trimlog /data/inbre-bioinfo/Weicksel/practice1/shOut/trim_log3.txt \
    /data/inbre-bioinfo/Weicksel/pipe4C-master/example/reads_set_1_viewpoint_10_ESC_replicate_3.fastq.gz \
        /data/inbre-bioinfo/Weicksel/practice1/shOut/trimmo/trimmed3.fastq.gz HEADCROP:24 SLIDINGWINDOW:4:15 MINLEN:20
module unload Trimmomatic/0.32-Java-1.7.0_80

module load Bowtie2/2.4.1-GCC-8.3.0
bowtie2 -x /data/inbre-bioinfo/Shared_Genome_Indexes/Indexes/GRCm39/GRCm39 -U /data/inbre-bioinfo/Weicksel/practice1/shOut/trimmo/trimmed1.fastq.gz,/data/inbre-bioinfo/Weicksel/practice1/shOut/trimmo/trimmed2.fastq.gz,/data/inbre-bioinfo/Weicksel/practice1/shOut/trimmo/trimmed3.fastq.gz -S /data/inbre-bioinfo/Weicksel/practice1/shOut/SAMfiles/SAMpractice.bam
module unload Bowtie2/2.4.1-GCC-8.3.0

module load SAMtools/1.10-GCC-8.3.0
samtools sort /data/inbre-bioinfo/Weicksel/practice1/shOut/SAMfiles/SAMpractice.bam -o /data/inbre-bioinfo/Weicksel/practice1/shOut/SAMfiles/out.bam
module unload SAMtools/1.10-GCC-8.3.0

module load SAMtools/1.10-GCC-8.3.0
samtools index /data/inbre-bioinfo/Weicksel/practice1/shOut/SAMfiles/out.bam
module unload SAMtools/1.10-GCC-8.3.0

module load SAMtools/1.10-GCC-8.3.0
samtools view /data/inbre-bioinfo/Weicksel/practice1/shOut/SAMfiles/out.bam -h
module unload SAMtools/1.10-GCC-8.3.0
