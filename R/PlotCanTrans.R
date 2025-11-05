#' Plot Canonical Transcript Composition.
#'
#' Plot the canonical transcript composition of this dataset based on transcripts
#' associated with the exon composition associated with each gene.
#'
#' @param transData a dataframe containing ensembl gene, transcript, and exon IDs.
#' @param datasetName (optional) name of dataset provided to include in figure.
#'
#' @returns Returns a plot of transcript composition.
#'
#' @examples
#' canPlot <- plotTransCan(formattedData, "test data")
#' canPlot
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
plotTransCan <- function(transData, datasetName) {

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

  # load ensembl database
  ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")

  # load the corresponding transcripts and canonical status for each exon
  ensembldbValues <- biomaRt::getBM(attributes=c("ensembl_gene_id", "ensembl_transcript_id", "ensembl_exon_id", "transcript_is_canonical"),
                                    filters = 'ensembl_exon_id', values = exons, mart = ensembl)

  # replace 0 and 1 with "not canonical" and "canonical"
  ensembldbValues <- ensembldbValues %>% dplyr::mutate(transcript_is_canonical = ifelse(is.na(transcript_is_canonical), "Not Canonical", transcript_is_canonical))
  ensembldbValues$transcript_is_canonical[ensembldbValues$transcript_is_canonical == 1] <- "Canonical"

  # plot data
  plot <- ggplot2::ggplot(ensembldbValues, aes(x = ensembl_gene_id, fill = transcript_is_canonical)) + geom_bar() +
    labs(title = plotTitle, x = "Ensembl Gene ID", y = "Possible Transcripts", fill = "Canonical Status")

  return(plot)
}
