process CONCAT {
    label 'process_single'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir
    
    input:
    path verse_outputs

    output:
    path ('counts_matrix.csv'), emit:concat

    shell:
    """
    concat.py -i ${verse_outputs.join(' ')} -o counts_matrix.csv
    """
}