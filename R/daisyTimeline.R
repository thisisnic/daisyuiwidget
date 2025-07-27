#' Daisy Timeline
#'
#' Create a Daisy Timeline
#'
#' @param events A data frame with columns 'date' and 'content', and optionally 'side'
#' @param width Width of the widget
#' @param height Height of the widget
#' @param elementId HTML element ID
#'
#' @import htmlwidgets
#'
#' @export
daisyTimeline <- function(events, width = NULL, height = NULL, elementId = NULL) {
  # Convert data frame to list of lists for JavaScript consumption
  if (is.data.frame(events)) {
    # Check required columns
    if (!all(c("date", "content") %in% names(events))) {
      stop("Data frame must contain 'date' and 'content' columns")
    }
    
    # Convert data frame to list of lists
    events_list <- lapply(seq_len(nrow(events)), function(i) {
      # Handle NA values by converting them to "NA" strings
      date_val <- events$date[i]
      content_val <- events$content[i]
      
      event <- list(
        date = ifelse(is.na(date_val), "NA", as.character(date_val)),
        content = ifelse(is.na(content_val), "NA", as.character(content_val))
      )
      
      # Add side column if it exists
      if ("side" %in% names(events)) {
        side_val <- events$side[i]
        event$side <- ifelse(is.na(side_val), "NA", as.character(side_val))
      }
      
      return(event)
    })
  } else {
    # Backward compatibility: if events is already a list, use it as is
    events_list <- events
  }
  
  htmlwidgets::createWidget(
    name = "daisyTimeline",
    x = list(events = events_list),
    width = width,
    height = height,
    package = "daisyuiwidget1",
    elementId = elementId,
    dependencies = list(
      htmltools::htmlDependency(
        name = "tailwind-daisy",
        version = "1.0.0",
        src = system.file("htmlwidgets/lib", package = "daisyuiwidget1")#,
        #stylesheet = "tailwind-daisy.min.css"
      )
    )
  )

}




#' Shiny bindings for daisyTimeline
#'
#' Output and render functions for using daisyTimeline within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a daisyTimeline
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name daisyTimeline-shiny
#'
#' @export
daisyTimelineOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'daisyTimeline', width, height, package = 'daisyuiwidget1')
}

#' @rdname daisyTimeline-shiny
#' @export
renderDaisyTimeline <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, daisyTimelineOutput, env, quoted = TRUE)
}
