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
    # Using data frame format (recommended)
    events_df <- data.frame(
      date = c("2022", "2023", "2024", "2025"),
      content = c("Planning phase", "Development started", "Launch 🚀", "IPO 🚀"),
      stringsAsFactors = FALSE
    )
    
    daisyTimeline(events_df)
    
    # Alternative: still works with list format for backward compatibility
    # daisyTimeline(list(
    #   list(date = "2022", content = "Planning phase"),
    #   list(date = "2023", content = "Development started"),
    #   list(date = "2024", content = "Launch 🚀"),
    #   list(date = "2025", content = "IPO 🚀")
    # ))
  })
}

shinyApp(ui, server)
