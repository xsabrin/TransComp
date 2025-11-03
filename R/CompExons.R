# Note for myself to delete later: devtools::document() to generate the automatic help files
# Preview documentation with: ?function
# Functions: 1.

# Identify Exons that Cannot Belong to the Same Transcript
#
# Identify whether two datasets are looking at the same transcript of a gene.
#
# @param file1
# @returns Returns a list of positions that cannot belong to the same transcript. If this is the same transcript, an empty list will be returned.
# @export
# @import biomaRt
# @import dplyr
# @import utils
# @importFrom magrittr %>%

#CompExons <- function(file1 = NA, file2 = NA, geneID) {

  # find possible transcripts for both genes
#  transcripts1 <- IndTransc(file1, geneID)
#  transcripts2 <- IndTransc(file2, geneID)

  # identify overlaps


#}


#' Identify If Two Datasets Could Look at Same Transcript
#'
#' Identify whether two datasets are looking at the same transcripts for a gene.
#'
#' @param dataset1 first dataset to compare. This dataset should contain the genomic coordinates for each sample.
#' @param dataset2 second dataset to compare. This dataset should contain the genomic coordinates for each sample.
#' @param geneID the ensembl gene ID of the target gene.
#' @returns Returns a list of genes that both datasets could be looking at. If there are none, an empty list will be returned.
#' @export

SameTransc <- function(dataset1, dataset2, geneID) {

  # find possible transcripts for both genes
  transcripts1 <- IndTransc(dataset1, geneID)
  transcripts2 <- IndTransc(dataset2, geneID)

  # identify overlaps
  overlaps <- intersect(transcripts1, transcripts2)

  return(overlaps)
}


#' Identify If Two Datasets Could Look at Same Transcript
#'
#' Identify whether two datasets are looking at the same transcripts for each gene.
#'
#' @param transComp1 a dataset containing a list of genes and their possible transcripts.
#' @param transComp2 a second dataset containing a list of genes and their possible transcripts.
#' @returns Returns a list of genes that show overlap in transcripts. If there are none, an empty list will be returned.
#' @export

CompTransc <- function(transComp1, transComp2) {

  if (!("ensembl_gene_id" %in% colnames(transComp1)) || !("ensembl_transcript_id" %in% colnames(transComp1))) {
    stop("Dataset 1 is not properly formatted.")
  } else if (!("ensembl_gene_id" %in% colnames(transComp2)) || !("ensembl_transcript_id" %in% colnames(transComp2))) {
    stop("Dataset 2 is not properly formatted.")
  }

  overl_trans <- merge(transComp1, transComp2, by = "ensembl_transcript_id")
  genes_with_overlap <- overl_trans$ensembl_gene_id

  return(overl_trans)
}
