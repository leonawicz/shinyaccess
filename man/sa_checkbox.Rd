% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checkbox.R
\name{sa_checkbox}
\alias{sa_checkbox}
\alias{update_sa_checkbox}
\title{Checkbox input}
\usage{
sa_checkbox(inputId, label, value = FALSE, color = "#555555", width = NULL)

update_sa_checkbox(session, inputId, label = NULL, value = NULL)
}
\arguments{
\item{inputId}{The id of the input object.}

\item{label}{The label to set for the input object.}

\item{value}{logical, default toggle state.}

\item{color}{character, hex or R color name.}

\item{width}{The width of the input, e.g. \code{'400px'}, or \code{'100\%'};
see \code{shiny::validateCssUnit}.}

\item{session}{The session object passed to function given to shinyServer.}
}
\value{
HTML element that can be added to a UI definition.
}
\description{
A Shiny checkbox input.
}
\examples{
if (interactive()) {
library(shiny)

ui <- function(request) {
fluidPage(
  use_access(),
  fluidRow(bookmarkButton()),
  fluidRow(
    column(3,
      actionButton("btn1", "Set to TRUE"),
      actionButton("btn2", "Change label"),
      sa_checkbox("cb1", "Show text A", FALSE, "firebrick", 200),
      sa_checkbox("cb2", "Show text B", TRUE)
    ),
    column(9, textOutput("txt1"), textOutput("txt2"))
  )
)
}

server <- function(input, output, session) {
  output$txt1 <- renderText(paste("Checkbox 1 input is set to", input$cb1))
  output$txt2 <- renderText(paste("Checkbox 2 input is set to", input$cb2))
  observeEvent(input$btn1, {
    update_sa_checkbox(session, "cb1", value = TRUE)
  })
  observeEvent(input$btn2, {
    update_sa_checkbox(session, "cb1", label = "Show text A 2")
  })
}

shinyApp(ui, server, enableBookmarking = "url")

}
}
