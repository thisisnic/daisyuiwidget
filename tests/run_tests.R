# Test runner script for daisyuiwidget package
# Run this script to execute all tests

# Install required packages if not already installed
if (!requireNamespace("testthat", quietly = TRUE)) {
  install.packages("testthat")
}

if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Load required libraries
library(testthat)
library(devtools)

# Run all tests
cat("Running tests for daisyuiwidget package...\n")
test_results <- devtools::test()

# Print summary
cat("\n=== Test Summary ===\n")
print(test_results)

# Check if all tests passed
if (all(test_results$failed == 0)) {
  cat("\n✅ All tests passed!\n")
} else {
  cat("\n❌ Some tests failed. Please check the output above.\n")
}
