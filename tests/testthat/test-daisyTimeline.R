test_that("daisyTimeline works with data frame input", {
  # Create test data frame
  events_df <- data.frame(
    date = c("2022", "2023", "2024"),
    content = c("Event 1", "Event 2", "Event 3"),
    stringsAsFactors = FALSE
  )
  
  # Test function execution
  result <- daisyTimeline(events_df)
  
  # Check that result is an htmlwidget
  expect_s3_class(result, "htmlwidget")
  expect_s3_class(result, "daisyTimeline")
  
  # Check that the data is properly formatted
  expect_type(result$x$events, "list")
  expect_length(result$x$events, 3)
  
  # Check first event structure
  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Event 1")
  
  # Check all events are properly converted
  dates <- sapply(result$x$events, function(x) x$date)
  contents <- sapply(result$x$events, function(x) x$content)
  expect_equal(dates, c("2022", "2023", "2024"))
  expect_equal(contents, c("Event 1", "Event 2", "Event 3"))
})

test_that("daisyTimeline works with data frame including side column", {
  # Create test data frame with side column
  events_df <- data.frame(
    date = c("2022", "2023"),
    content = c("Event 1", "Event 2"),
    side = c("left", "right"),
    stringsAsFactors = FALSE
  )
  
  result <- daisyTimeline(events_df)
  
  # Check that side information is preserved
  expect_equal(result$x$events[[1]]$side, "left")
  expect_equal(result$x$events[[2]]$side, "right")
})

test_that("daisyTimeline works with list input (backward compatibility)", {
  # Create test data as list of lists
  events_list <- list(
    list(date = "2022", content = "Event 1"),
    list(date = "2023", content = "Event 2"),
    list(date = "2024", content = "Event 3")
  )
  
  result <- daisyTimeline(events_list)
  
  # Check that result is an htmlwidget
  expect_s3_class(result, "htmlwidget")
  expect_s3_class(result, "daisyTimeline")
  
  # Check that the data structure is preserved
  expect_type(result$x$events, "list")
  expect_length(result$x$events, 3)
  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Event 1")
})

test_that("daisyTimeline handles type conversion properly", {
  # Test with numeric dates and factor content
  events_df <- data.frame(
    date = c(2022, 2023, 2024),
    content = factor(c("Event 1", "Event 2", "Event 3")),
    stringsAsFactors = FALSE
  )
  
  result <- daisyTimeline(events_df)
  
  # Check that numeric dates are converted to character
  expect_type(result$x$events[[1]]$date, "character")
  expect_equal(result$x$events[[1]]$date, "2022")
  
  # Check that factor content is converted to character
  expect_type(result$x$events[[1]]$content, "character")
  expect_equal(result$x$events[[1]]$content, "Event 1")
})

test_that("daisyTimeline validates data frame columns", {
  # Test missing date column
  events_df_no_date <- data.frame(
    content = c("Event 1", "Event 2"),
    stringsAsFactors = FALSE
  )
  
  expect_error(
    daisyTimeline(events_df_no_date),
    "Data frame must contain 'date' and 'content' columns"
  )
  
  # Test missing content column
  events_df_no_content <- data.frame(
    date = c("2022", "2023"),
    stringsAsFactors = FALSE
  )
  
  expect_error(
    daisyTimeline(events_df_no_content),
    "Data frame must contain 'date' and 'content' columns"
  )
  
  # Test missing both columns
  events_df_wrong_cols <- data.frame(
    year = c("2022", "2023"),
    description = c("Event 1", "Event 2"),
    stringsAsFactors = FALSE
  )
  
  expect_error(
    daisyTimeline(events_df_wrong_cols),
    "Data frame must contain 'date' and 'content' columns"
  )
})

test_that("daisyTimeline handles empty data frame", {
  # Test with empty data frame
  events_df_empty <- data.frame(
    date = character(0),
    content = character(0),
    stringsAsFactors = FALSE
  )
  
  result <- daisyTimeline(events_df_empty)
  
  expect_s3_class(result, "htmlwidget")
  expect_length(result$x$events, 0)
})

test_that("daisyTimeline handles single row data frame", {
  # Test with single row
  events_df_single <- data.frame(
    date = "2022",
    content = "Single Event",
    stringsAsFactors = FALSE
  )
  
  result <- daisyTimeline(events_df_single)
  
  expect_s3_class(result, "htmlwidget")
  expect_length(result$x$events, 1)
  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Single Event")
})

test_that("daisyTimeline preserves widget parameters", {
  events_df <- data.frame(
    date = c("2022", "2023"),
    content = c("Event 1", "Event 2"),
    stringsAsFactors = FALSE
  )
  
  result <- daisyTimeline(
    events_df, 
    width = "100%", 
    height = "400px", 
    elementId = "test-timeline"
  )
  
  expect_equal(result$width, "100%")
  expect_equal(result$height, "400px")
  expect_equal(result$elementId, "test-timeline")
})

test_that("daisyTimeline handles NA values", {
  # Test with NA values
  events_df_na <- data.frame(
    date = c("2022", NA, "2024"),
    content = c("Event 1", "Event 2", NA),
    stringsAsFactors = FALSE
  )
  
  result <- daisyTimeline(events_df_na)
  
  expect_s3_class(result, "htmlwidget")
  expect_length(result$x$events, 3)
  
  # Check that NA values are converted to "NA" strings
  expect_equal(result$x$events[[2]]$date, "NA")
  expect_equal(result$x$events[[3]]$content, "NA")
})
