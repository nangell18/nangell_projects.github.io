configfile:
        "test_config.json"

base_dir = config["base_dir"]
sample_dir = base_dir+config["sample_dir"]
seq_dir = base_dir+config["seq_dir"]
trim_dir = seq_dir+config["trim_dir"]
aln_dir = seq_dir+config["aln_dir"]
log_dir = seq_dir+config["log_dir"]
bt2_index = config["bt2_index"]

samples = ["reads_set_1_viewpoint_10_ESC_replicate_1", "reads_set_1_viewpoint_10_ESC_replicate_2", "reads_set_1_viewpoint_10_ESC_replicate_3"]

rule all:
        input:
                expand(aln_dir+"{sample}_sorted.bam.bai", sample = samples)

rule fastqc:
        input:
                sample_dir+"{sample}.fastq.gz"
        output:
                zip = log_dir+"{sample}_fastqc.zip",
                html = log_dir+"{sample}_fastqc.html"
        log:
                log_dir+"{sample}_fastqc.log"
        wrapper:
                "0.31.1/bio/fastqc"

rule trimmomatic_se:
	input:
		expand(sample_dir+"{sample}.fastq.gz", sample = samples),
		expand(log_dir+"{sample}_fastqc.html", sample = samples)
	output:
		trim_dir+"{sample}_trimmed.fastq"
	log:
		log_dir+"{sample}_trimmed.log"
	threads:
		20
	params:
		trimmer=["HEADCROP:24 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:20"]
	wrapper:
		"0.31.1/bio/trimmomatic/se"

rule bowtie2:
	input:
		sample = [trim_dir+"{sample}_trimmed.fastq"]
	output:
		aln_dir+"{sample}.sam"
	log:
		log_dir+"{sample}_bt2.log"
	params:
		index=bt2_index,
		extra = ""
	wrapper:
		"0.31.1/bio/bowtie2/align"

rule samtools_sort:
	input:
		aln_dir+"{sample}.sam"
	output:
		aln_dir+"{sample}_sorted.bam"
	wrapper:
		"0.31.1/bio/samtools/sort"

rule samtools_index:
	input:
		aln_dir+"{sample}_sorted.bam"
	output:
		aln_dir+"{sample}_sorted.bam.bai"
	wrapper:
		"0.31.1/bio/samtools/index"

