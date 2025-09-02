test_that("daisyTimeline handles different data frame sizes", {
  # Single row
  single <- data.frame(date = "2022", content = "Event")
  result_single <- daisyTimeline(single, ~date, ~content)
  expect_length(result_single$x$events, 1)

  # Multiple rows
  multiple <- data.frame(
    date = c("2022", "2023", "2024", "2025"),
    content = c("A", "B", "C", "D")
  )
  result_multiple <- daisyTimeline(multiple, ~date, ~content)
  expect_length(result_multiple$x$events, 4)

  # Empty
  empty <- data.frame(date = character(0), content = character(0))
  result_empty <- daisyTimeline(empty, ~date, ~content)
  expect_length(result_empty$x$events, 0)
})

test_that("daisyTimeline end-to-end functionality", {
  events <- data.frame(
    date = c("2022", "2023", "2024"),
    content = c("Planning", "Development", "Launch"),
    side = c("left", "right", "left")
  )

  result <- daisyTimeline(events, ~date, ~content, width = "100%", elementId = "test")

  # Widget structure
  expect_s3_class(result, c("daisyTimeline", "htmlwidget"))
  expect_equal(result$width, "100%")
  expect_equal(result$elementId, "test")

  # Data structure
  expect_length(result$x$events, 3)

  # First event
  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Planning")

  # Last event
  expect_equal(result$x$events[[3]]$date, "2024")
  expect_equal(result$x$events[[3]]$content, "Launch")
})

test_that("daisyTimeline integration with real-world data", {
  # Test with complex date formatting and multiple data types
  events_data <- data.frame(
    release_date = as.Date(c("2022-01-01", "2023-06-15", "2024-03-10")),
    package_name = c("dplyr", "ggplot2", "tidyr"),
    event = c("Major release", "Bug fixes", "New features"),
    version = c("1.0.0", "3.4.2", "1.3.0"),
    stringsAsFactors = FALSE
  )
  
  widget <- daisyTimeline(events_data,
                         date = ~format(release_date, "%B %Y"),
                         title = ~paste(package_name, "-", event, "(v", version, ")"))
  
  expect_s3_class(widget, "htmlwidget")
  expect_length(widget$x$events, 3)
  expect_equal(widget$x$events[[1]]$date, "January 2022")
  expect_true(grepl("dplyr - Major release", widget$x$events[[1]]$content))
})

test_that("daisyTimeline works in Shiny context", {
  # Test that Shiny bindings are properly configured
  output_widget <- daisyTimelineOutput("timeline1", width = "500px", height = "300px")
  
  expect_true(grepl("timeline1", as.character(output_widget)))
  expect_true(grepl("500px", as.character(output_widget)))
  expect_true(grepl("300px", as.character(output_widget)))
})

test_that("daisyTimeline handles edge cases", {
  # Test with single row
  single_event <- data.frame(
    date = "2023",
    event = "Single event"
  )
  
  widget <- daisyTimeline(single_event, date = ~date, title = ~event)
  expect_length(widget$x$events, 1)
  
  # Test with empty data frame
  empty_data <- data.frame(
    date = character(0),
    event = character(0)
  )
  
  widget_empty <- daisyTimeline(empty_data, date = ~date, title = ~event)
  expect_length(widget_empty$x$events, 0)
})

test_that("daisyTimeline preserves data types correctly", {
  mixed_data <- data.frame(
    date = as.Date(c("2022-01-01", "2023-01-01")),
    event = c("Event 1", "Event 2"),
    numeric_col = c(1.5, 2.7),
    logical_col = c(TRUE, FALSE)
  )
  
  widget <- daisyTimeline(mixed_data,
                         date = ~as.character(date),
                         title = ~paste(event, "-", numeric_col, "-", logical_col))
  
  expect_type(widget$x$events[[1]]$date, "character")
  expect_type(widget$x$events[[1]]$content, "character")
  expect_true(grepl("Event 1 - 1.5 - TRUE", widget$x$events[[1]]$content))
})
