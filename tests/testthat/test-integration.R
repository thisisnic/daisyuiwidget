test_that("helper functions work correctly", {
  # Test create_sample_events_df
  sample_df <- create_sample_events_df(2)
  expect_s3_class(sample_df, "data.frame")
  expect_equal(nrow(sample_df), 2)
  expect_equal(colnames(sample_df), c("date", "content"))
  expect_equal(sample_df$date, c("2022", "2023"))
  expect_equal(sample_df$content, c("Event 1", "Event 2"))
  
  # Test create_sample_events_list
  sample_list <- create_sample_events_list(2)
  expect_type(sample_list, "list")
  expect_length(sample_list, 2)
  expect_equal(sample_list[[1]]$date, "2022")
  expect_equal(sample_list[[1]]$content, "Event 1")
  
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
  
  # Test with list
  events_list <- create_sample_events_list(3)
  widget_list <- daisyTimeline(events_list)
  
  expect_valid_htmlwidget(widget_list)
  expect_length(widget_list$x$events, 3)
  
  # Compare that both methods produce equivalent results for same data
  events_df_small <- create_sample_events_df(3)
  events_list_small <- create_sample_events_list(3)
  
  widget_from_df <- daisyTimeline(events_df_small)
  widget_from_list <- daisyTimeline(events_list_small)
  
  expect_equal(widget_from_df$x$events, widget_from_list$x$events)
})
