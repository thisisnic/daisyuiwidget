test_that("daisyTimeline creates htmlwidget with data frame", {
  events <- data.frame(
    date = c("2022", "2023"),
    content = c("Event 1", "Event 2")
  )

  result <- daisyTimeline(events)

  expect_s3_class(result, "htmlwidget")
  expect_s3_class(result, "daisyTimeline")
})

test_that("daisyTimeline converts data frame to correct structure", {
  events <- data.frame(
    date = c("2022", "2023", "2024"),
    content = c("Event 1", "Event 2", "Event 3")
  )

  result <- daisyTimeline(events)

  expect_type(result$x$events, "list")
  expect_length(result$x$events, 3)
})

test_that("daisyTimeline preserves date and content values", {
  events <- data.frame(
    date = c("2022", "2023"),
    content = c("Planning", "Launch")
  )

  result <- daisyTimeline(events)

  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Planning")
  expect_equal(result$x$events[[2]]$date, "2023")
  expect_equal(result$x$events[[2]]$content, "Launch")
})

test_that("daisyTimeline handles side column when present", {
  events <- data.frame(
    date = c("2022", "2023"),
    content = c("Event 1", "Event 2"),
    side = c("left", "right")
  )

  result <- daisyTimeline(events)

  expect_equal(result$x$events[[1]]$side, "left")
  expect_equal(result$x$events[[2]]$side, "right")
})

test_that("daisyTimeline converts factor content to character", {
  events <- data.frame(
    date = c("2022", "2023"),
    content = factor(c("Event 1", "Event 2"))
  )

  result <- daisyTimeline(events)

  expect_type(result$x$events[[1]]$content, "character")
  expect_equal(result$x$events[[1]]$content, "Event 1")
})

test_that("daisyTimeline works with empty data frame", {
  events <- data.frame(
    date = character(0),
    content = character(0)
  )

  result <- daisyTimeline(events)

  expect_length(result$x$events, 0)
})

test_that("daisyTimeline works with single row", {
  events <- data.frame(
    date = "2022",
    content = "Single Event"
  )

  result <- daisyTimeline(events)

  expect_length(result$x$events, 1)
  expect_equal(result$x$events[[1]]$date, "2022")
})

test_that("daisyTimeline preserves widget parameters", {
  events <- data.frame(
    date = "2022",
    content = "Event"
  )

  result <- daisyTimeline(events, width = "100%", height = "400px", elementId = "test")

  expect_equal(result$width, "100%")
  expect_equal(result$height, "400px")
  expect_equal(result$elementId, "test")
})

test_that("daisyTimeline rejects non-data frame input", {
  events_list <- list(list(date = "2022", content = "Event"))

  expect_error(daisyTimeline(events_list), "events must be a data frame")
  expect_error(daisyTimeline("not a data frame"), "events must be a data frame")
  expect_error(daisyTimeline(NULL), "events must be a data frame")
})

test_that("daisyTimeline requires date column", {
  events <- data.frame(content = "Event")

  expect_error(daisyTimeline(events), "Data frame must contain 'date' and 'content' columns")
})

test_that("daisyTimeline requires content column", {
  events <- data.frame(date = "2022")

  expect_error(daisyTimeline(events), "Data frame must contain 'date' and 'content' columns")
})

test_that("daisyTimeline requires both date and content columns", {
  events <- data.frame(year = "2022", description = "Event")

  expect_error(daisyTimeline(events), "Data frame must contain 'date' and 'content' columns")
})

