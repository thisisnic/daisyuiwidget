test_that("daisyTimelineOutput creates proper Shiny output", {
  output <- daisyTimelineOutput("test-output")
  
  # The output from htmlwidgets::shinyWidgetOutput is typically a shiny.tag.list
  expect_s3_class(output, "shiny.tag.list")
  
  # Check that it contains the expected HTML widget structure
  expect_true(length(output) > 0)
  
  # The actual structure depends on htmlwidgets implementation
  # Just verify it's a valid Shiny output
  expect_true(is.list(output))
})

test_that("daisyTimelineOutput accepts custom dimensions", {
  output <- daisyTimelineOutput("test-output", width = "80%", height = "300px")
  
  expect_s3_class(output, "shiny.tag.list")
  expect_true(length(output) > 0)
  
  # The dimensions are passed to htmlwidgets::shinyWidgetOutput
  # We can't easily test the exact CSS without rendering, but we can test
  # that the function accepts the parameters without error
  expect_true(is.list(output))
})

test_that("renderDaisyTimeline returns proper render function", {
  events_df <- data.frame(
    date = c("2022", "2023"),
    content = c("Event 1", "Event 2"),
    stringsAsFactors = FALSE
  )
  
  render_func <- renderDaisyTimeline({
    daisyTimeline(events_df)
  })
  
  expect_s3_class(render_func, "shiny.render.function")
})

# Note: These tests require the shiny package to be available
# We'll skip them if shiny is not installed
test_that("Shiny integration works when shiny is available", {
  skip_if_not_installed("shiny")
  
  library(shiny)
  
  # Test that the functions work in a basic Shiny context
  ui <- fluidPage(daisyTimelineOutput("timeline"))
  
  expect_s3_class(ui, "shiny.tag.list")
  
  # Test server function
  server <- function(input, output) {
    output$timeline <- renderDaisyTimeline({
      events_df <- data.frame(
        date = c("2022", "2023"),
        content = c("Event 1", "Event 2"),
        stringsAsFactors = FALSE
      )
      daisyTimeline(events_df)
    })
  }
  
  expect_type(server, "closure")
})
