test_that("daisyTimeline creates htmlwidget with data frame", {
  events <- data.frame(
    year = c("2022", "2023"),
    description = c("Event 1", "Event 2")
  )

  result <- daisyTimeline(events, date = year, title = description)

  expect_s3_class(result, "htmlwidget")
  expect_s3_class(result, "daisyTimeline")
})

test_that("daisyTimeline converts data frame to correct structure", {
  events <- data.frame(
    year = c("2022", "2023", "2024"),
    description = c("Event 1", "Event 2", "Event 3")
  )

  result <- daisyTimeline(events, date = year, title = description)

  expect_type(result$x$events, "list")
  expect_length(result$x$events, 3)
})

test_that("daisyTimeline preserves date and content values", {
  events <- data.frame(
    year = c("2022", "2023"),
    description = c("Planning", "Launch")
  )

  result <- daisyTimeline(events, date = year, title = description)

  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Planning")
  expect_equal(result$x$events[[2]]$date, "2023")
  expect_equal(result$x$events[[2]]$content, "Launch")
})

test_that("daisyTimeline converts factor content to character", {
  events <- data.frame(
    year = c("2022", "2023"),
    description = factor(c("Event 1", "Event 2"))
  )

  result <- daisyTimeline(events, date = year, title = description)

  expect_type(result$x$events[[1]]$content, "character")
  expect_equal(result$x$events[[1]]$content, "Event 1")
})

test_that("daisyTimeline works with empty data frame", {
  events <- data.frame(
    year = character(0),
    description = character(0)
  )

  result <- daisyTimeline(events, date = year, title = description)

  expect_length(result$x$events, 0)
})

test_that("daisyTimeline works with single row", {
  events <- data.frame(
    year = "2022",
    description = "Single Event"
  )

  result <- daisyTimeline(events, date = year, title = description)

  expect_length(result$x$events, 1)
  expect_equal(result$x$events[[1]]$date, "2022")
})

test_that("daisyTimeline preserves widget parameters", {
  events <- data.frame(
    year = "2022",
    description = "Event"
  )

  result <- daisyTimeline(events, date = year, title = description, width = "100%", height = "400px", elementId = "test")

  expect_equal(result$width, "100%")
  expect_equal(result$height, "400px")
  expect_equal(result$elementId, "test")
})

test_that("daisyTimeline rejects non-data frame input", {
  events_list <- list(list(date = "2022", content = "Event"))

  expect_error(daisyTimeline(events_list, date = date, title = content), "`data` must be a data frame")
  expect_error(daisyTimeline("not a data frame", date = date, title = content), "`data` must be a data frame")
  expect_error(daisyTimeline(NULL, date = date, title = content), "`data` must be a data frame")
})

test_that("daisyTimeline works with expressions", {
  # Test with simple expression
  events <- data.frame(
    year = c(2022, 2023),
    description = c("Event 1", "Event 2")
  )

  result <- daisyTimeline(events, date = as.character(year), title = paste0("Year: ", description))

  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Year: Event 1")
})

test_that("daisyTimeline supports direct column references", {
  events <- data.frame(
    event_date = c("2022", "2023"),
    event_title = c("Planning", "Launch")
  )

  result <- daisyTimeline(events, date = event_date, title = event_title)

  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, "Planning")
})

test_that("daisyTimeline handles HTML content", {
  events <- data.frame(
    year = c("2022", "2023"),
    name = c("Project Start", "Launch"),
    url = c("https://example.com/start", "https://example.com/launch")
  )

  result <- daisyTimeline(events, 
                         date = year, 
                         title = htmltools::HTML(paste0('<a href="', url, '">', name, '</a>')))

  expect_true(result$x$hasHTML)
  expect_equal(result$x$events[[1]]$date, "2022")
  expect_equal(result$x$events[[1]]$content, '<a href="https://example.com/start">Project Start</a>')
})

test_that("daisyTimeline detects HTML content correctly", {
  # Plain text content
  events_plain <- data.frame(
    year = c("2022", "2023"),
    description = c("Event 1", "Event 2")
  )
  
  result_plain <- daisyTimeline(events_plain, date = year, title = description)
  expect_false(result_plain$x$hasHTML %||% FALSE)
  
  # HTML content
  events_html <- data.frame(
    year = c("2022", "2023"),
    description = c("Event 1", "Event 2")
  )
  
  result_html <- daisyTimeline(events_html, 
                              date = year, 
                              title = htmltools::HTML(paste0('<a href="#">', description, '</a>')))
  expect_true(result_html$x$hasHTML)
})

test_that("daisyTimeline works with shiny::HTML", {
  skip_if_not_installed("shiny")
  
  events <- data.frame(
    year = c("2022", "2023"),
    name = c("Start", "End")
  )

  result <- daisyTimeline(events, 
                         date = year, 
                         title = shiny::HTML(paste0('<strong>', name, '</strong>')))

  expect_true(result$x$hasHTML)
  expect_equal(result$x$events[[1]]$content, '<strong>Start</strong>')
})

