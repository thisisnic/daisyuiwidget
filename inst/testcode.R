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
      date = c("2022", "2023", "2024", "2025"),
      content = c("Planning phase", "Development started", "Launch 🚀", "IPO 🚀")
    )
    
    daisyTimeline(events_df)
  })
  
  observeEvent(input$timeline_selected, {
    print(input$timeline_selected)
  })
  
  output$clicked_index <- renderPrint({
    input$timeline_selected
  })
}

shinyApp(ui, server)
