library(shiny)
library(daisyuiwidget)

ui <- fluidPage(
  "hr underneath me",
  hr(),
  "timeline underneath me",
  daisyTimelineOutput("timeline"),
)

server <- function(input, output) {
  output$timeline <- renderDaisyTimeline({
    # Using data frame format
    events_df <- data.frame(
      date = c("2022", "2023", "2024", "2025"),
      content = c("Planning phase", "Development started", "Launch 🚀", "IPO 🚀"),
      stringsAsFactors = FALSE
    )
    
    daisyTimeline(events_df)
  })
}

shinyApp(ui, server)
