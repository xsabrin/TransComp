#' Identify Gene Transcript Based on Genomic Coordinates
#'
#' Identify the transcript composition of a given dataset, given multiple sequencing reads of a gene.
#'
#' @param transData a dataframe containing the ensembl transcript, exon, and gene IDs. It should also include a column identifying grouped exons.
#' @returns Returns a dataframe with the possible transcript of each gene read.
#' @export
#' @import biomaRt
#' @import utils
#' @importFrom magrittr %>%

TransComp <- function(transData) {
  if (!("ensembl_gene_id" %in% colnames(transData))) {
    stop("Dataset not properly formatted, please include gene IDs.")
  } else if (!("samples" %in% colnames(transData))) {
    stop("Dataset not properly formatted, please include identifiers.")
  }

  diff_exp <- distinct(transData, ensembl_gene_id, samples)

  for (exp in diff_exp) {
    # find the subset of transData with this gene id and exp. number
    curr_sub <- subset(transData, ensembl_gene_id == exp[1, ]$ensembl_gene_id && samples == exp[1, ]$samples)

    # apply IndTransc to this subset
    poss_transc <- IndTransc(curr_sub, curr_sub$ensembl_gene_id[1])

    # merge it back
    diff_exp <- merge(x = diff_exp, y = poss_transc, by = c("ensembl_exon_id", "ensembl_transcript_id"))
  }

  return(diff_exp$ensembl_transcript_id)
}


#' Identify Gene Transcript Based on Genomic Coordinates
#'
#' Identify which transcript of a gene the given genomic coordinates belong to.
#'
#' @param geneID the ensembl gene ID of the target gene.
#' @param dataset1 a dataframe containing the ensembl exon and transcript IDs.
#' @returns Returns a list of possible transcripts this gene could be. If there are none, the list will be empty.
#' @import biomaRt
#' @import utils
#' @importFrom magrittr %>%

IndTransc <- function(dataset1, geneID) {
  # separate each exon into a different dataframe and merge these dataframes together
  # to find the transcripts that satisfy all exons in this datasets
  if (!("ensembl_exon_id" %in% colnames(dataset1))) {
    stop("Dataset is not properly formatted to include exon ID.")
  }

  diff_exons <- unique(dataset1$ensembl_exon_id)

  common_transcripts <- subset(dataset1, ensembl_exon_id == diff_exons[1])
  for (i in 2:length(diff_exons)) {
    curr_exon <- diff_exons[i]
    curr_sub <- subset(dataset1, ensembl_exon_id == curr_exon)

    common_transcripts <- merge(x = common_transcripts, y = curr_sub, by = c("ensembl_exon_id", "ensembl_transcript_id"))
  }

  return(common_transcripts$ensembl_transcript_id)
}
