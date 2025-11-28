# Purpose: Plot the Transcript Composition
# Author: Sabrina Xi
# Date: 2025-11-27
# Version: 0.2.0
# Bugs and Issues: None

#' Plot Transcript Composition.
#'
#' Plot the transcript composition of this dataset. This function will plot the
#' count of each transcript associated with the dataset for each, using the
#' result from TransComp based on genomic coordinates given.
#'
#' @param transData a dataframe containing ensembl gene, transcript, and exon IDs.
#' @param datasetName (optional) name of dataset provided to include in figure.
#'
#' @returns Returns a plot of transcript composition.
#'
#' @examples
#' plot <- plotTransComp(formattedData, "test data")
#' plot
#'
#' @references
#' BioMart and Bioconductor: a powerful link between biological databases and microarray data analysis. Steffen Durinck,
#' Yves Moreau, Arek Kasprzyk, Sean Davis, Bart De Moor, Alvis Brazma and Wolfgang Huber, Bioinformatics 21, 3439-3440
#' (2005).
#'
#' H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
#'
#' Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data Manipulation_.
#' doi:10.32614/CRAN.package.dplyr <https://doi.org/10.32614/CRAN.package.dplyr>, R package version 1.1.4,
#' <https://CRAN.R-project.org/package=dplyr>.
#'
#' @export
#'
#' @import ggplot2
#' @import biomaRt
#' @importFrom dplyr mutate
plotTransComp <- function(transData, datasetName) {

  # check that the input dataset has a list of exon and gene IDs
  if (!("ensembl_gene_id" %in% colnames(transData))) {
    stop("Dataset should include ensembl gene IDs in a column labeled 'ensembl_gene_id'.")
  } else if (!("ensembl_exon_id" %in% colnames(transData))) {
    stop("Dataset should include ensembl exon IDs in a column labeled 'ensembl_exon_id'.")
  }

  exons <- transData$ensembl_exon_id
  plotTitle <- "Canonical Transcript Composition of Dataset"
  if (!is.na(datasetName)) {
    plotTitle <- paste(plotTitle, datasetName)
  }

  # get transcript composition data from TransComp function
  plotData <- TransComp(transData)

  # plot data
  plot <- ggplot2::ggplot(plotData, aes(x = ensembl_gene_id, fill = ensembl_transcript_id)) + geom_bar() +
    labs(title = plotTitle, x = "Ensembl Gene ID", y = "Possible Transcripts (count)", fill = "ensembl_transcript_id")

  return(plot)
}

# [END]
