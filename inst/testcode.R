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
    # Using new tidy eval format with expressions
    events_df <- data.frame(
      year = c("2014", "2015", "2018", "2020", "2025"),
      phase = c("Released", "plotly", "async", "bindCache", "hexsticker"),
      emoji = c("🚀", "📊", "⌛️", "📌", "⬢")
    )
    
    # Demonstrate expressions in tidy eval
    daisyTimeline(
      events_df, 
      date = as.character(year),
      title = paste0(phase, " ", emoji)
    )
  })
  
  observeEvent(input$timeline_selected, {
    print(input$timeline_selected)
  })
  ⬢
  output$clicked_index <- renderPrint({
    input$timeline_selected
  })
}

shinyApp(ui, server)
