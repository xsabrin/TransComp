library(transComp)

# Test that CanTrans returns the correct canonical transcripts
test_that("CanTrans() returns the correct canonical transcript", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData <- loadAndCleanData(filepath)
  canonical_transcript <- CanTrans(formattedData)
  testthat::expect_equal(canonical_transcript, c("ENSG00000141510", "ENSG00000139618"))
})

# Test that an error is raised for an incorrect submission
test_that("CanTrans() returns error for incorrect input", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData <- loadAndCleanData(filepath)
  testthat::expect_error(CanTrans(formattedData["ensembl_gene_id"])) # missing columns
})

# Test that

# [END]
