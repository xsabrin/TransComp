#' Example BRCA2 and TP53 Dataframe
#'
#' A dataframe of gene and genomic coordinate data from Ensembl for BRCA2 and TP53.
#' This is the expected resulting dataframe when "inst/extdata/example_data.csv"
#' is used as the input file for function loadAndCleanData.
#'
#' @source The dataset was downloaded from Ensembl
#' https://useast.ensembl.org/index.html
#'
#' @format A dataframe with two columns:
#' \describe{
#'  \item{sample}{The sample number}
#'  \item{ensembl_gene_id}{The ensembl gene ID}
#'  \item{ensembl_transcript_id}{The ensembl transcript ID}
#'  \item{ensembl_exon_id}{The ensembl exon ID}
#'  \item{exon_chrom_start}{The exon start coordinate.}
#'  \item{exon_chrom_end}{The exon end coordinate.}
#'  \item{Length}{The transcript length.}
#'  }
#' }
#' @examples
#' \dontrun{
#'  formattedData
#' }
"formattedData"
