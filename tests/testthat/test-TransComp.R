library(transComp)

# Test that TransComp returns the correct transcript
test_that("TransComp() returns the correct result", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData <- loadAndCleanData(filepath)
  result <- TransComp(formattedData)
  test <- result$ensembl_transcript_id
  testthat::expect_equal(test[1], "ENST00000380152")
})
