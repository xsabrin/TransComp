library(transComp)

# Test that loadAndCleanData returns the correct data format
test_that("loadAndCleanData() returns the correct output", {
  filepath <- system.file("extdata", "example_data.csv", package = "transComp")
  testData <- loadAndCleanData(filepath)
  testthat::expect_length(testData, 7)
})

# Test that an empty input returns an error
test_that("loadAndCleanData() returns an error if the input is empty", {
  filepath <- ""
  testthat::expect_error(loadAndCleanData(filepath))
})

# [END]
