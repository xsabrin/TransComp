library(transComp)

# Test that TransComp returns the correct transcript
test_that("TransComp() returns the correct result", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData <- loadAndCleanData(filepath)
  result <- TransComp(formattedData)
  test <- result$ensembl_transcript_id
  testthat::expect_equal(test[1], "ENST00000380152")
})

# Test that TransComp returns an error if the input dataset is incorrect
test_that("TransComp() returns an error if necessary", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData <- loadAndCleanData(filepath)
  testthat::expect_error(TransComp(formattedData["ensembl_gene_id"]))
})

# Test that CompTransc returns the correct transcript
test_that("CompTransc() returns the correct result", {
  # load data
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData1 <- loadAndCleanData(filepath)
  filepath <- system.file("extdata", "example_data2.csv", package = "transComp")
  formattedData2 <- loadAndCleanData(filepath)

  # check result
  result <- CompTransc(formattedData1, formattedData2)
  testthat::expect_equal(result, "ENST00000380152")
})

# Test that CompTransc returns an error if the input dataset is incorrect
test_that("CompTransc() returns an error if necessary", {
  # load data
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  formattedData1 <- loadAndCleanData(filepath)
  filepath <- system.file("extdata", "example_data2.csv", package = "transComp")
  formattedData2 <- loadAndCleanData(filepath)

  # check result
  result <- CompTransc(formattedData1, formattedData2)
  testthat::expect_error(CompTransc(formattedData1["ensembl_gene_id", "sample"], formattedData2))
})

# [END]
