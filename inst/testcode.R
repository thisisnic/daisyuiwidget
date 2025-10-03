library(shiny)
library(daisyuiwidget1)

ui <- fluidPage(
  "hr underneath me",
  hr(),
  "timeline underneath me",
  daisyTimelineOutput("timeline"),
)

server <- function(input, output) {
  output$timeline <- renderDaisyTimeline({
    daisyTimeline(list(
      list(date = "2014", content = "htmlwidgets released"),
      list(date = "2015", content = "plotly switches to htmwidgets"),
      list(date = "2018", content = "htmlwidgets get async functionality"),
      list(date = "2020", content = "htmlwidgets get bindCache support"),
      list(date = "2025", content = "htmlwidgets get a hex sticker")
    ))
  })
}

shinyApp(ui, server)
