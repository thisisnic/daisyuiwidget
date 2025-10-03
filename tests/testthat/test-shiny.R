test_that("daisyTimelineOutput creates Shiny output", {
  output <- daisyTimelineOutput("test-output")

  expect_s3_class(output, "shiny.tag.list")
  expect_true(length(output) > 0)
})

test_that("daisyTimelineOutput accepts custom dimensions", {
  output <- daisyTimelineOutput("test-output", width = "80%", height = "300px")

  expect_s3_class(output, "shiny.tag.list")
})

test_that("renderDaisyTimeline returns render function", {
  events <- data.frame(year = "2022", description = "Event")

  render_func <- renderDaisyTimeline({
    daisyTimeline(events, date = year, title = description)
  })

  expect_s3_class(render_func, "shiny.render.function")
})
