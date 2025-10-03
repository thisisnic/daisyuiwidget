library(shiny)
library(daisyuiwidget)

ui <- fluidPage(
  "hr underneath me",
  hr(),
  "timeline underneath me",
  daisyTimelineOutput("timeline"),
  verbatimTextOutput("clicked_index")
)

server <- function(input, output) {
  output$timeline <- renderDaisyTimeline({
    # Using data frame format
    events_df <- data.frame(
      date = c("2014", "2015", "2018", "2020", "2025"),
      content = c("htmlwidgets released", "plotly switches to htmwidgets", "htmlwidgets get async functionality", "htmlwidgets get bindCache support", "htmlwidgets get a hex sticker")

    )
    
    daisyTimeline(events_df, ~date, ~content)
  })
  
  observeEvent(input$timeline_selected, {
    print(input$timeline_selected)
  })
  
  output$clicked_index <- renderPrint({
    input$timeline_selected
  })
}

shinyApp(ui, server)
