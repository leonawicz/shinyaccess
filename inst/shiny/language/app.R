library(shiny)

ui <- fluidPage(
  h3("App title"),
  includeScript(system.file("inst/resources/access.js", package = "shinyaccess"))
)

server <- function(input, output, session) {
  set_lang(session)
}

shinyApp(ui, server)
