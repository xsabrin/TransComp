library(transComp)

# Test that CanTrans returns the correct canonical transcripts
test_that("CanTrans() returns the correct canonical transcript", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData <- loadAndCleanData(filepath)
  canonical_transcript <- CanTrans(formattedData)
  testthat::expect_equal(canonical_transcript, c("ENSG00000141510", "ENSG00000139618"))
})

# [END]
