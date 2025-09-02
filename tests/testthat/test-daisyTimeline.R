test_that("daisyTimeline creates htmlwidget with data frame", {
  events <- data.frame(
    date = c("2022", "2023"),
    content = c("Event 1", "Event 2")
  )

  result <- daisyTimeline(events, ~date, ~content)

  expect_s3_class(result, "htmlwidget")
  expect_s3_class(result, "daisyTimeline")
})

test_that("daisyTimeline converts data frame to correct structure", {
  events <- data.frame(
    date = c("2022", "2023", "2024"),
    content = c("Event 1", "Event 2", "Event 3")
  )

  result <- daisyTimeline(events, ~date, ~content)

  expect_type(result$x$events, "list")
  expect_length(result$x$events, 3)
})

test_that("daisyTimeline preserves date and content values", {
  events <- data.frame(
    date = c("2022", "2023"),
    content = c("Planning", "Launch")
  )

  result <- daisyTimeline(events, ~date, ~content)

  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Planning")
  expect_equal(result$x$events[[2]]$date, "2023")
  expect_equal(result$x$events[[2]]$content, "Launch")
})

test_that("daisyTimeline converts factor content to character", {
  events <- data.frame(
    date = c("2022", "2023"),
    content = factor(c("Event 1", "Event 2"))
  )

  result <- daisyTimeline(events,  ~date, ~content)

  expect_type(result$x$events[[1]]$content, "character")
  expect_equal(result$x$events[[1]]$content, "Event 1")
})

test_that("daisyTimeline works with empty data frame", {
  events <- data.frame(
    date = character(0),
    content = character(0)
  )

  result <- daisyTimeline(events,  ~date, ~content)

  expect_length(result$x$events, 0)
})

test_that("daisyTimeline works with single row", {
  events <- data.frame(
    date = "2022",
    content = "Single Event"
  )

  result <- daisyTimeline(events,  ~date, ~content)

  expect_length(result$x$events, 1)
  expect_equal(result$x$events[[1]]$date, "2022")
})

test_that("daisyTimeline preserves widget parameters", {
  events <- data.frame(
    date = "2022",
    content = "Event"
  )

  result <- daisyTimeline(events, ~date, ~content, width = "100%", height = "400px", elementId = "test")

  expect_equal(result$width, "100%")
  expect_equal(result$height, "400px")
  expect_equal(result$elementId, "test")
})

test_that("daisyTimeline rejects non-data frame input", {
  events_list <- list(list(date = "2022", content = "Event"))

  expect_error(daisyTimeline(events_list), "`data` must be a data frame")
  expect_error(daisyTimeline("not a data frame"), "`data` must be a data frame")
  expect_error(daisyTimeline(NULL), "`data` must be a data frame")
})

test_that("daisyTimeline works with formula inputs", {
  events_data <- data.frame(
    release_date = as.Date(c("2022-01-01", "2023-01-01")),
    package_name = c("dplyr", "ggplot2"),
    event = c("Major release", "Bug fixes")
  )
  
  widget <- daisyTimeline(events_data,
                         date = ~format(as.Date(release_date), "%Y"),
                         title = ~event)
  
  expect_s3_class(widget, "htmlwidget")
  expect_length(widget$x$events, 2)
  expect_equal(widget$x$events[[1]]$date, "2022")
  expect_equal(widget$x$events[[1]]$content, "Major release")
})

test_that("daisyTimeline works with direct column names", {
  events_simple <- data.frame(
    date_col = c("2022", "2023"),
    content_col = c("Release 1", "Release 2")
  )
  
  widget <- daisyTimeline(events_simple, date = ~date_col, title = ~content_col)
  
  expect_s3_class(widget, "htmlwidget")
  expect_length(widget$x$events, 2)
  expect_equal(widget$x$events[[1]]$date, "2022")
  expect_equal(widget$x$events[[1]]$content, "Release 1")
})

test_that("daisyTimeline validates input", {
  expect_error(daisyTimeline("not a data frame"), "`data` must be a data frame")
  
  data <- data.frame(x = 1, y = 2)
  expect_error(daisyTimeline(data, date = ~x), "Either 'title' or 'event' parameter must be provided")
})

test_that("daisyTimeline handles factors correctly", {
  data <- data.frame(
    date = factor(c("2022", "2023")),
    event = factor(c("Event 1", "Event 2"))
  )
  
  widget <- daisyTimeline(data, date = ~date, title = ~event)
  
  expect_type(widget$x$events[[1]]$date, "character")
  expect_type(widget$x$events[[1]]$content, "character")
})

test_that("daisyTimeline backward compatibility with event parameter", {
  data <- data.frame(
    date = c("2022", "2023"),
    event = c("Event 1", "Event 2")
  )
  
  widget <- daisyTimeline(data, date = ~date, event = ~event)
  
  expect_s3_class(widget, "htmlwidget")
  expect_equal(widget$x$events[[1]]$content, "Event 1")
})

test_that("daisyTimeline handles complex formula expressions", {
  data <- data.frame(
    start_date = as.Date(c("2022-01-15", "2023-07-20")),
    end_date = as.Date(c("2022-02-15", "2023-08-20")),
    project = c("Project A", "Project B")
  )
  
  widget <- daisyTimeline(data,
                         date = ~paste(format(start_date, "%b %Y"), "-", format(end_date, "%b %Y")),
                         title = ~paste("Duration:", project))
  
  expect_equal(widget$x$events[[1]]$date, "Jan 2022 - Feb 2022")
  expect_equal(widget$x$events[[1]]$content, "Duration: Project A")
})

