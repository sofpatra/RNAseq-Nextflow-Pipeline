#!/usr/bin/env nextflow

include {FASTQC} from './modules/fastqc'
include { STAR_INDEX } from './modules/star_index'
include {ID_SYMBOL} from './modules/id_symbol'
include {STAR_ALIGN} from './modules/star_align'
include {MULTI_QC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {CONCAT} from './modules/concat'


workflow {
    Channel.fromFilePairs(params.reads)
    |set{align_ch}

    Channel.fromFilePairs(params.reads).transpose()
    |set{fastqc_ch}

    FASTQC(fastqc_ch)

    STAR_INDEX(params.genome, params.gtf)

    ID_SYMBOL(params.gtf, file(params.script))

    STAR_ALIGN(STAR_INDEX.out.index, align_ch)


//create fastqc and star channels
    fastqc_out = FASTQC.out.zip.collect()
    star_out = STAR_ALIGN.out.log.collect()
// Collect outputs from FASTQC and STAR, map, merge them into one channel for MultiQC
    
    //fastqc_out.mix(STAR_ALIGN.out.log.collect())  // Map STAR logs and flatten if needed
    //  | set { multiqc_ch }
//
//    view(multiqc_ch)
    fastqc_out.combine(star_out) 
        | set { multiqc_ch }
    
    multiqc_ch.view()

// Run MultiQC on all collected QC files
    MULTI_QC(multiqc_ch)

    
    VERSE(STAR_ALIGN.out.BAM, params.gtf)
//collect makes sure that the all the files are present before running the process
    CONCAT(VERSE.out.exon.collect())

}
