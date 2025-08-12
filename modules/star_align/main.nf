#!/usr/bin/env nextflow

process STAR_ALIGN {
    label "process_high"
    container "ghcr.io/bf528/star:latest"
    publishDir params.outdir
   
    input:
    path index //from the STAR indexing process
    tuple val(name), path(fq) //input reads

    output:
    tuple val(name), path("${name}*.bam"), emit: BAM
    path("${name}*Log.final.out"), emit: log


    script:
    """
    STAR --runThreadN $task.cpus --genomeDir $index --readFilesIn $fq --readFilesCommand zcat --outFileNamePrefix ${name}_ --outSAMtype BAM Unsorted 

    """

}