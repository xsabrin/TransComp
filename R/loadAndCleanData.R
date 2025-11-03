#' Load and Clean a Given Dataset
#'
#' Given a file, load and clean the dataset so that it contains standardized ensembl
#' gene IDs, exon IDs, and transcript IDs.
#'
#' @param transFile input csv file. This file should contain genomic coordinates, and either the ensembl gene ID or both a gene identifier and source. It can also include a column detailing which rows were sequenced as part of the same sample, which can be useful for some downstream tasks.
#' @returns Returns a cleaned dataset.
#' @export
#' @import biomaRt
#' @import stringr
#' @import utils
#' @importFrom stats na.omit
#' @importFrom magrittr %>%

loadCleanData <- function(transFile = NA) {
  # check if user input file is valid
  if (is.na(transFile)) {
    stop("File path is null")
  }

  # if the file is valid, save the data in a dataframe
  transData <- utils::read.csv(file = transFile, header = TRUE)

  # load ensembl database and available filters
  ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
  filters <- biomaRt::listFilters(ensembl)
  # pre-process data: if a source for the gene name is included, standardize to ensembl stable gene ID
  # if not, check that the genes are given using ensembl gene ID
  if (("geneSource" %in% colnames(transData)) && !("gene_ids" %in% colnames(transData))) {
    sources <- unique(transData$geneSource)
    faultySources <- c()

    # for every different gene source, find the corresponding ensembl gene ID
    for (source in sources) {
      if (!(source %in% filters)) {
        faultySources <- append(faultySources, source)
      }
      else {
        currSource <- transData %>% filter(geneSource == source)

        # get the gene IDs based on the values of the given gene source
        geneIds <- biomaRt::getBM(attributes=c('ensembl_gene_id', source), filters =
                                     source, values = currSource$gene, mart = ensembl)
        colnames(geneIds)[2] <- "geneSource"

        # add the ensembl gene IDs back into the main dataframe
        merge(x = transData, y = geneIds, by = "geneSource", all.x = TRUE)
      }
    }

    # removes values from sources which are not included in ensembl
    transData <- subset(transData, !(geneSource %in% faultySources))

  } else if ("ensembl_gene_id" %in% colnames(transData)) {
    # check that all gene IDs are in the correct ensembl format
    if (!(all(stringr::str_detect(transData$ensembl_gene_id, "ENSG")))) {
      stop("Genes not provided correctly.")
    }

  } else {
    stop("Genes were not provided.")
  }

  if (!("ensembl_exon_id" %in% colnames(transData))) {
    genes <- unique(transData$ensembl_gene_id)
    faulty_genes <- c()

    # for every different gene, find the corresponding ensembl transcripts and exons
    for (gene in genes) {
      # load the possible transcripts and corresponding exons for this gene
      ensembldbValues <- biomaRt::getBM(attributes=c("ensembl_transcript_id", "ensembl_exon_id", "exon_chrom_start", "exon_chrom_end"), filters =
                                           'ensembl_gene_id', values = gene, mart = ensembl)

      # merge corresponding possible exon IDs with genomic start and stop coordinates for each datasets
      transData <- merge(x = transData, y = ensembldbValues, by = c("exon_chrom_start", "exon_chrom_end", "ensembl_gene_id"), all.x = TRUE)
    }
  }

  # remove all rows with null values in this dataframe
  stats::na.omit(transData)

  return(transData)
}
