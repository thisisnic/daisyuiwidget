test_that("helper functions work correctly", {
  # Test create_sample_events_df
  sample_df <- create_sample_events_df(2)
  expect_s3_class(sample_df, "data.frame")
  expect_equal(nrow(sample_df), 2)
  expect_equal(colnames(sample_df), c("date", "content"))
  expect_equal(sample_df$date, c("2022", "2023"))
  expect_equal(sample_df$content, c("Event 1", "Event 2"))
  
  # Test expect_valid_htmlwidget helper
  widget <- daisyTimeline(sample_df)
  expect_valid_htmlwidget(widget)
  
  # Test expect_valid_event helper
  event <- list(date = "2022", content = "Test Event")
  expect_valid_event(event, "2022", "Test Event")
})

test_that("comprehensive integration test using helpers", {
  # Test with data frame
  events_df <- create_sample_events_df(4)
  widget_df <- daisyTimeline(events_df)
  
  expect_valid_htmlwidget(widget_df)
  expect_length(widget_df$x$events, 4)
  
  # Validate each event
  for (i in 1:4) {
    expect_valid_event(
      widget_df$x$events[[i]], 
      expected_date = paste0("202", 1+i),
      expected_content = paste("Event", i)
    )
  }
  
  # Test with different data frame sizes
  small_df <- create_sample_events_df(1)
  large_df <- create_sample_events_df(10)
  
  small_widget <- daisyTimeline(small_df)
  large_widget <- daisyTimeline(large_df)
  
  expect_valid_htmlwidget(small_widget)
  expect_valid_htmlwidget(large_widget)
  expect_length(small_widget$x$events, 1)
  expect_length(large_widget$x$events, 10)
})
