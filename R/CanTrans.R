# Purpose: Identify Canonical Transcript Composition
# Author: Sabrina Xi
# Date: 2025-11-25
# Version: 0.2.0
# Bugs and Issues: None

#' Identify a Dataset's Canonical Transcript Composition
#'
#' Identify the composition of canonical transcripts of a dataset from its exon composition.
#'
#' @param transData dataframe containing gene and exon data.
#'
#' @returns Returns a list of genes that only contains exons found on the canonical transcript.
#'
#' @examples
#' canonical_transcripts <- CanTrans(formattedData)
#' canonical_transcripts
#'
#' @references
#' BioMart and Bioconductor: a powerful link between biological databases and microarray data analysis. Steffen Durinck,
#' Yves Moreau, Arek Kasprzyk, Sean Davis, Bart De Moor, Alvis Brazma and Wolfgang Huber, Bioinformatics 21, 3439-3440
#' (2005).
#'
#' @export
#'
#' @import biomaRt
CanTrans <- function(transData) {

  # check that the input dataset has a list of exon and gene IDs
  if (!("ensembl_gene_id" %in% colnames(transData))) {
    stop("Dataset should include ensembl gene IDs in a column labeled 'ensembl_gene_id'.")
  } else if (!("ensembl_exon_id" %in% colnames(transData))) {
    stop("Dataset should include ensembl exon IDs in a column labeled 'ensembl_exon_id'.")
  }

  dataset <- transData
  genes <- transData$ensembl_gene_id

  # load ensembl database
  ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")

  # if this dataset does not contain each exon's corresponding transcript and canonical status, add to dataframe
  if (!("ensembl_transcript_id" %in% colnames(transData))) {
    exons <- unique(transData$ensembl_exon_id)

    # load the corresponding transcripts and canonical status for each exon
    ensembldbValues <- biomaRt::getBM(attributes=c("ensembl_transcript_id", "ensembl_exon_id"), filters =
                                         'ensembl_exon_id', values = exons, mart = ensembl)

    # merge into dataframe
    dataset <- merge(x = transData, y = ensembldbValues, by="ensembl_exon_id")
  }

  canonicalTransc <- biomaRt::getBM(attributes=c("ensembl_transcript_id", "ensembl_gene_id"), filters =
                                      c('ensembl_gene_id', "transcript_is_canonical"), values = list('ensembl_gene_id'=genes, 'transcript_is_canonical'=TRUE), mart = ensembl)

  canonGenes <- merge(x=canonicalTransc, y=dataset, by=c("ensembl_transcript_id", "ensembl_gene_id"), all=FALSE)

  return(unique(canonGenes$ensembl_gene_id))
}

# [END]
