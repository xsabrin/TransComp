library(transComp)

# Test that loadAndCleanData returns the correct data format
test_that("loadAndCleanData() returns the correct output", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  testData <- loadAndCleanData(filepath)
  testthat::expect_length(testData, 7)
})
