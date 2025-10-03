test_that("daisyTimeline handles different data frame sizes", {
  # Single row
  single <- data.frame(year = "2022", description = "Event")
  result_single <- daisyTimeline(single, date = year, title = description)
  expect_length(result_single$x$events, 1)

  # Multiple rows
  multiple <- data.frame(
    year = c("2022", "2023", "2024", "2025"),
    description = c("A", "B", "C", "D")
  )
  result_multiple <- daisyTimeline(multiple, date = year, title = description)
  expect_length(result_multiple$x$events, 4)

  # Empty
  empty <- data.frame(year = character(0), description = character(0))
  result_empty <- daisyTimeline(empty, date = year, title = description)
  expect_length(result_empty$x$events, 0)
})

test_that("daisyTimeline end-to-end functionality", {
  events <- data.frame(
    year = c("2022", "2023", "2024"),
    description = c("Planning", "Development", "Launch"),
    side = c("left", "right", "left")
  )

  result <- daisyTimeline(events, date = year, title = description, width = "100%", elementId = "test")

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
