#' Load and Clean a Given Dataset
#'
#' Given a file, load and clean the dataset so that it contains standardized ensembl
#' gene IDs, exon IDs, and transcript IDs.
#'
#' @param transFile input csv file. This file should contain genomic coordinates, and either the ensembl gene ID or both a gene identifier and source. It can also include a column detailing which rows were sequenced as part of the same sample, which can be useful for some downstream tasks.
#'
#' @returns Returns a cleaned dataset.
#'
#' @examples
#' filepath <- system.file("extdata", "example_data.csv", package = "transComp")
#' results <- loadAndCleanData(filepath)
#' results
#'
#' @references
#' BioMart and Bioconductor: a powerful link between biological databases and microarray data analysis. Steffen Durinck,
#' Yves Moreau, Arek Kasprzyk, Sean Davis, Bart De Moor, Alvis Brazma and Wolfgang Huber, Bioinformatics 21, 3439-3440
#' (2005).
#'
#' Wickham H (2025). stringr: Simple, Consistent Wrappers for Common String Operations.
#' doi:10.32614/CRAN.package.stringr <https://doi.org/10.32614/CRAN.package.stringr>, R package version 1.5.2,
# '<https://CRAN.R-project.org/package=stringr>.
#'
#' R Core Team (2025). R: A Language and Environment for Statistical Computing. R Foundation for Statistical Computing,
#' Vienna, Austria. <https://www.R-project.org/>.
#'
#' Bache S, Wickham H (2025). magrittr: A Forward-Pipe Operator for R. doi:10.32614/CRAN.package.magrittr
#' <https://doi.org/10.32614/CRAN.package.magrittr>, R package version 2.0.4,
#' <https://CRAN.R-project.org/package=magrittr>.
#'
#' @export
#'
#' @import biomaRt
#' @import stringr
#' @import utils
#' @importFrom stats na.omit
#' @importFrom magrittr %>%
loadAndCleanData <- function(transFile = NA) {
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
  if (("geneSource" %in% colnames(transData)) && !("geneIds" %in% colnames(transData))) {
    sources <- unique(transData$geneSource)
    faultySources <- c()

    # for every different gene source, find the corresponding ensembl gene ID
    for (source in sources) {
      if (!(source %in% filters)) {
        faultySources <- append(faultySources, source)
      }
      else {
        currSource <- transData[transData$geneSource == source, ]

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
      ensembldbValues <- biomaRt::getBM(attributes=c("ensembl_gene_id", "ensembl_transcript_id", "ensembl_exon_id", "exon_chrom_start", "exon_chrom_end"), filters =
                                           'ensembl_gene_id', values = gene, mart = ensembl)

      # merge corresponding possible exon IDs with genomic start and stop coordinates for each datasets
      transData <- merge(x = transData, y = ensembldbValues, by = c("exon_chrom_start", "exon_chrom_end", "ensembl_gene_id", "ensembl_transcript_id"), all.x = TRUE)
    }
  }

  # remove all rows with null values in this dataframe
  stats::na.omit(transData)

  return(transData)
}
