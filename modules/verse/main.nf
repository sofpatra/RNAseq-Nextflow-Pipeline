#!/usr/bin/env nextflow

process VERSE {
    label "process_high"
    container "ghcr.io/bf528/verse:latest"
    publishDir params.outdir
   
    input:
    tuple val(name), path(bam_file)
    path gtf
    
    //Give the general name of the output file, e.g., 'Sample_A'.
    //The summary file will be named 'Sample_A.summary.txt.'
    //The file containing gene counts will be named 'Sample_A.exon.txt',
    //'Sample_A.intron.txt', etc.
    output:
    path("${name}*.summary.txt"), emit: summary
    path("${name}*.exon.txt"), emit: exon

    script:
    """
    verse -S -a $gtf -o ${name} ${bam_file}

    """

}