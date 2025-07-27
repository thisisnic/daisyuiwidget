# Testing Setup for daisyuiwidget

This document describes the testing infrastructure set up for the daisyuiwidget package using the testthat framework.

## Test Structure

The testing setup follows R package conventions with tests located in the `tests/` directory:

```
tests/
├── testthat.R                    # Main test runner (standard testthat setup)
├── run_tests.R                   # Convenience script for running tests
└── testthat/
    ├── helper.R                  # Helper functions for tests
    ├── test-daisyTimeline.R      # Tests for main daisyTimeline function
    ├── test-shiny.R              # Tests for Shiny integration
    └── test-integration.R        # Integration and end-to-end tests
```

## Test Coverage

### Main Function Tests (`test-daisyTimeline.R`)
- ✅ Data frame input handling
- ✅ Data frame with optional `side` column
- ✅ Backward compatibility with list input
- ✅ Type conversion (numeric dates, factor content)
- ✅ Input validation (missing required columns)
- ✅ Edge cases (empty data frame, single row)
- ✅ Widget parameter preservation
- ✅ NA value handling

### Shiny Integration Tests (`test-shiny.R`)
- ✅ `daisyTimelineOutput()` function
- ✅ Custom dimensions handling
- ✅ `renderDaisyTimeline()` function
- ✅ Basic Shiny integration (when shiny package available)

### Integration Tests (`test-integration.R`)
- ✅ Helper function validation
- ✅ End-to-end workflow testing
- ✅ Data frame vs list equivalence verification

### Helper Functions (`helper.R`)
- `create_sample_events_df()` - Creates test data frames
- `create_sample_events_list()` - Creates test data as list format
- `expect_valid_htmlwidget()` - Validates htmlwidget structure
- `expect_valid_event()` - Validates individual event structure

## Running Tests

### Option 1: Using devtools (recommended)
```r
devtools::test()
```

### Option 2: Using the convenience script
```r
source("tests/run_tests.R")
```

### Option 3: Using testthat directly
```r
library(testthat)
test_dir("tests/testthat")
```

## Test Results
All tests are currently passing:
- **104 tests pass** ✅
- **0 tests fail** ✅
- **0 warnings**
- **0 skipped**

## Dependencies

The testing setup requires these packages (added to DESCRIPTION):
- `testthat (>= 3.0.0)` - Testing framework
- `shiny` - For Shiny integration tests (suggested)

## Continuous Integration

A GitHub Actions workflow (`.github/workflows/R-CMD-check.yaml`) is included for automated testing on:
- Ubuntu with R release
- Ubuntu with R development version

## Test Philosophy

The tests follow these principles:
1. **Comprehensive coverage** - Test both happy path and edge cases
2. **Backward compatibility** - Ensure existing list-based usage still works
3. **Input validation** - Verify proper error handling for invalid inputs
4. **Type safety** - Test various input types and their conversion
5. **Integration testing** - Verify the widget works end-to-end

## Adding New Tests

When adding new functionality:
1. Add unit tests in the appropriate `test-*.R` file
2. Use helper functions where possible to reduce code duplication
3. Test both the happy path and error conditions
4. Update this README if adding new test categories
