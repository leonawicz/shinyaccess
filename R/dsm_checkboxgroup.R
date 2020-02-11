#' DSM checkbox group input
#'
#' @param inputId input ID.
#' @param label text label.
#' @param choices selection choices.
#' @param selected not in use
#' @param inline not in use
#' @param value defaults to \code{choices}.
#' @param width not in use
#'
#' @return A list of HTML elements that can be added to a UI definition.
#' @export
#' @importFrom shiny tagList tags singleton HTML includeScript
#'
#' @examples
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   fluidRow(
#'     column(3,
#'       checkboxGroupInput("cb1", "Shiny1 - Variables to show:",
#'                          list("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear")),
#'       tableOutput("data1")
#'     ),
#'     column(3,
#'       checkboxGroupInput("cb2", "Shiny2 - Variables to show:",
#'                          list("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear")),
#'       tableOutput("data2")
#'     ),
#'     column(3,
#'       dsmCheckboxGroupInput("cb3", "DSM1 - Variables to show:",
#'                             c("Cylinders", "Transmission", "Gears"),
#'                             selected = c("cyl", "am"),
#'                             values = c("cyl", "am", "gear")),
#'       tableOutput("data3")
#'     ),
#'     column(3,
#'       dsmCheckboxGroupInput("cb4", "DSM2 - Variables to show:",
#'                             c("Cylinders", "Transmission", "Gears"),
#'                             selected = c("cyl", "am"),
#'                             values = c("cyl", "am", "gear")),
#'       tableOutput("data4")
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$data1 <- renderTable({
#'     mtcars[, c("mpg", input$cb1), drop = FALSE]
#'   }, rownames = TRUE)
#'
#'   output$data2 <- renderTable({
#'     mtcars[, c("mpg", input$cb2), drop = FALSE]
#'   }, rownames = TRUE)
#'   output$data3 <- renderTable({
#'     mtcars[, c("mpg", input$cb3), drop = FALSE]
#'   }, rownames = TRUE)
#'
#'   output$data4 <- renderTable({
#'     mtcars[, c("mpg", input$cb4), drop = FALSE]
#'   }, rownames = TRUE)
#' }
#'
#' shinyApp(ui, server)
#'
#' }
dsmCheckboxGroupInput <- function(inputId, label, choices = NULL, selected = NULL,
                                  inline = FALSE, values = choices, width = NULL){
  lab <- tolower(gsub("--+", "-", gsub(":", "", gsub(" |/", "-", label))))
  name <- paste0(lab, "-", values)
  x <- paste0("\n  <input type='checkbox' id='", name, "' name='", lab, "' value='", values, "'></input>",
              "\n  <label for='", name, "'>", choices, "</label>")
  x <- paste(x, collapse = "\n  ")
  x <- paste0(x, "\n</fieldset>\n")
  tagList(
    singleton(tags$head(includeScript(
      system.file("resources/input-binding-dsmcheckboxgroup.js", package = "shinyaccess")
    ))),
    HTML(
      paste0("<fieldset id='", inputId, "' class='dsm-input-checkboxgrp'>",
      "\n  <legend>", label, "</legend>",
      x)
    )
  )
}
