#' Plot Canonical Transcript Composition.
#'
#' Plot the canonical transcript composition of this dataset based on transcripts
#' associated with the exon composition associated with each gene.
#'
#' @param transData a dataframe containing ensembl gene, transcript, and exon IDs.
#' @param datasetName (optional) name of dataset provided to include in figure.
#' @returns Returns a plot of transcript composition.
#' @export
#' @import ggplot2
#' @import biomaRt
plotTransComp <- function(transData, datasetName) {

  # check that the input dataset has a list of exon and gene IDs
  if (!("ensembl_gene_id" %in% colname(transData))) {
    stop("Dataset should include ensembl gene IDs in a column labeled 'ensembl_gene_id'.")
  } else if (!("ensembl_exon_id" %in% colname(transData))) {
    stop("Dataset should include ensembl exon IDs in a column labeled 'ensembl_exon_id'.")
  }

  exons <- transData$ensembl_exon_id
  plotTitle <- "Canonical Transcript Composition of Dataset"
  if (!is.na(datasetName)) {
    plotTitle <- paste(plotTitle, " ", datasetName)
  }

  # load ensembl database
  ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")

  # load the corresponding transcripts and canonical status for each exon
  ensembldbValues <- biomaRt::getBM(attributes=c("ensembl_gene_id", "ensembl_transcript_id", "ensembl_exon_id", "transcript_is_canonical"),
                                    filters = 'ensembl_exon_id', values = exons, mart = ensembl)

  plot <- ggplot2::ggplot(ensembldbValues, aes(x = ensembl_gene_id, y = ensembl_transcript_id, fill = transcript_is_canonical)) + geom_bar() +
    labs(title = plotTitle, x = "Ensembl Gene ID", y = "Possible Transcripts", fill = "Canonical Status")

  return(plot)
}
