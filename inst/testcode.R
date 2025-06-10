library(shiny)
library(daisyuiwidget1)

ui <- fluidPage(
  daisyTimelineOutput("timeline")
)

server <- function(input, output) {
  output$timeline <- renderDaisyTimeline({
    daisyTimeline(list(
      list(date = "2022", content = "Planning phase"),
      list(date = "2023", content = "Development started"),
      list(date = "2024", content = "Launch 🚀")
    ))
  })
}

shinyApp(ui, server)
