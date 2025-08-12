#!/usr/bin/env nextflow

process ID_SYMBOL {
    label 'process_single'
    container "ghcr.io/bf528/biopython:latest"
    publishDir params.outdir, mode: 'copy'
    cache 'lenient'

    input:
    path gtf   // GTF file
    path script // Explicitly pass the Python script

    output:
    path "id_to_symbol.txt"

    script:
    """
    python $script -i $gtf -o id_to_symbol.txt
    """
}