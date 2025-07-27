# Helper functions for tests

create_sample_events_df <- function(n = 3) {
  data.frame(
    date = paste0("202", 2:(1+n)),
    content = paste("Event", 1:n),
    stringsAsFactors = FALSE
  )
}

expect_valid_htmlwidget <- function(widget) {
  expect_s3_class(widget, "htmlwidget")
  expect_s3_class(widget, "daisyTimeline")
  expect_true(is.list(widget$x))
  expect_true("events" %in% names(widget$x))
}

expect_valid_event <- function(event, expected_date = NULL, expected_content = NULL) {
  expect_true(is.list(event))
  expect_true("date" %in% names(event))
  expect_true("content" %in% names(event))
  expect_type(event$date, "character")
  expect_type(event$content, "character")
  
  if (!is.null(expected_date)) {
    expect_equal(event$date, expected_date)
  }
  
  if (!is.null(expected_content)) {
    expect_equal(event$content, expected_content)
  }
}
