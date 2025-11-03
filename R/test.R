# library(biomaRt)
#
# listEnsembl("GRCh=38")
#
# ensembl = useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
# chr1_genes <- getBM(attributes=c('ensembl_gene_id', "ensembl_exon_id",
#                                  'ensembl_transcript_id','hgnc_symbol'), filters =
#                       'external_gene_name', values ="BRCA2", mart = ensembl)
#
# testE <- c("BRCA2", "TP53")
#
# listFilters(ensembl)
# chr2_genes <- getBM(attributes=c('ensembl_gene_id', "ensembl_transcript_id", "ensembl_exon_id", "exon_chrom_start", "exon_chrom_end"), filters =
#                       c('external_gene_name', "transcript_is_canonical"), values = list('external_gene_name'=testE, 'transcript_is_canonical'=TRUE), mart = ensembl)
#
#
# col1 <- c("trust", "trustee", "trust", NA)
# col2 <- c("random", "truster", "random", "test")
# example <- data.frame(name1 = col1, name2 = col2)
#
# col3 <- c("trust", "else", "trust", "whatever")
# col4 <- c("1", "2", "3", "4")
# example2 <- data.frame(name1 = col3, other = col4)
#
# merged_esy <- merge(x = example, y = example2, by = "name1", all.x = TRUE)
# merged_test2 <- merge(example, example2)
#
# if (all(is.na(example))) {
#   print("yes")
# }
#
# ex_func <- function(some_char_value) {
#   some_char_value
# }
#
# unique(example$name1)
# example %>% filter(name1 == "trust")
