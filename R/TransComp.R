#' Identify Gene Transcripts Based on Genomic Coordinates
#'
#' Identify the transcript composition of a given dataset, given multiple sequencing reads of a gene.
#'
#' @param transData a dataframe containing the ensembl transcript, exon, and gene IDs.
#'  It should also include a column identifying grouped exons.
#'
#' @returns Returns a dataframe with the possible transcript of each gene read.
#'
#' @examples
#' canonical_transcripts <- TransComp(formattedData)
#' canonical_transcripts
#'
#' @references
#' Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data Manipulation_.
# doi:10.32614/CRAN.package.dplyr <https://doi.org/10.32614/CRAN.package.dplyr>, R package version 1.1.4,
# <https://CRAN.R-project.org/package=dplyr>.
#'
#' @export
#'
#' @importFrom dplyr distinct

TransComp <- function(transData) {
  # check that necessary columns are in dataset
  if (!("ensembl_gene_id" %in% colnames(transData))) {
    stop("Dataset not properly formatted, please include gene IDs.")
  } else if (!("sample" %in% colnames(transData))) {
    stop("Dataset not properly formatted, please include identifiers.")
  }

  diff_exp <- dplyr::distinct(transData, ensembl_gene_id, sample)
  gene_transcripts <- data.frame(ensembl_gene_id = character(), ensembl_transcript_id = character())

  for (i in 1:nrow(diff_exp)) {

    # apply IndTransc to each distinct sample
    poss_transc <- IndTransc(transData, diff_exp[i, ]$ensembl_gene_id, diff_exp[i, ]$sample)

    for (j in 1:length(poss_transc)) {
      gene_transcripts[i, ] <- c(diff_exp[1, ]$ensembl_gene_id, poss_transc[j])
    }
  }

  return(gene_transcripts)
}


#' Identify Gene Transcript Based on Genomic Coordinates
#'
#' Identify which transcript of a gene the given genomic coordinates belong to. These should
#' be grouped by sequenced transcript. This function is not available to the user.
#'
#' @param geneID the ensembl gene ID of the target gene.
#' @param dataset1 a dataframe containing the ensembl exon and transcript IDs.
#' @param sample the sample number.
#'
#' @returns Returns the transcript this sampled gene could have been sequenced
#'  from or a list if there are multiple possibilities. If there are none, it will return an empty list.

IndTransc <- function(dataset1, geneID = NA, sample = NA) {
  # separate each exon into a different dataframe and merge these dataframes together
  # to find the transcripts that satisfy all exons in this datasets
  if (!("ensembl_exon_id" %in% colnames(dataset1))) {
    stop("Dataset is not properly formatted to include exon ID.")
  } else if (!("ensembl_gene_id" %in% colnames(dataset1))) {
    stop("Dataset is not properly formatted to include gene ID.")
  } else if (!("ensembl_transcript_id" %in% colnames(dataset1))) {
    stop("Dataset is not properly formatted to include transcript ID.")
  } else if (is.na(geneID)) {
    stop("Gene ID should not be null.")
  } else if (is.na(sample)) {
    stop("Sample ")
  }

  # subset dataset to find values fitting this geneID and and sample
  dataset1 <- dataset1[dataset1$ensembl_gene_id == geneID, ]
  dataset1 <- dataset1[dataset1$sample == sample, ]

  # find the unique exon IDs
  diff_exons <- unique(dataset1$ensembl_exon_id)

  common_transcripts <- dataset1[dataset1$ensembl_exon_id == diff_exons[1], ]

  for (i in 2:length(diff_exons)) {

    # if common_transcripts isn't empty, merge by transcript ID
    if (nrow(common_transcripts) != 0) {
      curr_sub <- dataset1[dataset1$ensembl_exon_id == diff_exons[i], ]
      common_transcripts <- merge(x = common_transcripts, y = curr_sub, by="ensembl_transcript_id")
    } else {
      break
    }
  }

  if (nrow(common_transcripts) == 0) {
    common_transcripts <- list()
  } else {
    common_transcripts <- common_transcripts$ensembl_transcript_id
  }

  return(common_transcripts)
}


#' Identify If Two Datasets Could Look at Same Transcript
#'
#' For each common gene in dataset1 and dataset2, identify whether they could be looking at the same
#' transcript based on the genetic coordinates listed.
#'
#' @param transComp1 a dataset containing a list of genes and their exons
#' @param transComp2 a second dataset containing a list of genes and their exons
#'
#' @returns Returns a list of genes that show overlap in transcripts. If there are none, an empty list will be returned.
#'
#' @export

CompTransc <- function(transComp1, transComp2) {

  if (!("ensembl_gene_id" %in% colnames(transComp1)) || !("ensembl_exon_id" %in% colnames(transComp1)) || !("sample" %in% colnames(transComp1))) {
    stop("Dataset 1 is not properly formatted.")
  } else if (!("ensembl_gene_id" %in% colnames(transComp2)) || !("ensembl_exon_id" %in% colnames(transComp2)) || !("sample" %in% colnames(transComp2))) {
    stop("Dataset 2 is not properly formatted.")
  }

  # find possible transcripts for each gene
  data1 <- transComp::TransComp(transComp1)
  data2 <- transComp::TransComp(transComp2)

  # find overlapping transcripts
  overl_trans <- merge(transComp1, transComp2, by = "ensembl_transcript_id", "ensembl_gene_id")
  genes_with_overlap <- overl_trans$ensembl_gene_id

  return(overl_trans)
}
