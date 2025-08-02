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
  events <- data.frame(date = "2022", content = "Event")

  render_func <- renderDaisyTimeline({
    daisyTimeline(events)
  })

  expect_s3_class(render_func, "shiny.render.function")
})
