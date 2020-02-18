#' DSM checkbox group input
#'
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param choices List of values to show checkboxes for. If elements of the
#' list are named then that name rather than the value is displayed to the user.
#' If this argument is provided, then choiceNames and choiceValues must not be
#' provided, and vice-versa. The values should be strings; other types (such as
#' logicals and numbers) will be coerced to strings.
#' @param selected The values that should be initially selected, if any.
#' @param inline not in use
#' @param value defaults to \code{choices}.
#' @param width not in use
#' @param choiceNames,choiceValues See \code{\link[shiny]{checkboxGroupInput}}.
#' Vector of names and values, must have same length.
#' @param session The session object passed to function given to shinyServer.
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
#'       actionButton("btn1", "Reset checkbox group 1"),
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
#'       actionButton("btn3", "Reset checkbox group 3"),
#'       dsmCheckboxGroupInput("cb3", "DSM1 - Variables to show:",
#'                             c("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear"),
#'                             selected = c("cyl", "am")),
#'       tableOutput("data3")
#'     ),
#'     column(3,
#'       dsmCheckboxGroupInput("cb4", "DSM2 - Variables to show:",
#'                             selected = c("cyl", "am"),
#'                             choiceNames = c("Cylinders", "Transmission", "Gears"),
#'                             choiceValues = c("cyl", "am", "gear")),
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
#'
#'   observeEvent(input$btn1, {
#'     updateCheckboxGroupInput(session, "cb1", selected = character(0))
#'   })
#'   observeEvent(input$btn3, {
#'     updateDsmCheckboxGroupInput(session, "cb3", selected = c('am', 'gear'))
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#' }
dsmCheckboxGroupInput <- function(inputId, label, choices = NULL, selected = NULL,
                                  inline = FALSE, width = NULL, choiceNames = NULL, choiceValues = NULL){
  args <- normalizeChoicesArgs(choices, choiceNames, choiceValues)
  selected <- shiny::restoreInput(id = inputId, default = selected)
  print(selected)
  lab <- tolower(gsub("--+", "-", gsub(":", "", gsub(" |/", "-", label))))
  name <- paste0(lab, "-", args$choiceValues)
  v <- unlist(args$choiceValues)
  vname <- unlist(args$choiceNames)
  x <- sapply(seq_along(v), function(i){
    paste0("\n  <input type='checkbox' id='", name[i], "' name='", lab, "' value='", v[i], "'",
                if(v[i] %in% selected) " checked='checked'", "></input>",
              "\n  <label for='", name[i], "'>", vname[i], "</label>")
  })
  x <- paste(x, collapse = "\n  ")
  tagList(
    singleton(tags$head(includeScript(
      system.file("resources/input-binding-dsmcheckboxgroup.js", package = "shinyaccess")
    ))),
    HTML(
      paste0("<fieldset id='", inputId, "' class='dsm-input-checkboxgrp'>",
      "\n  <legend>", label, "</legend>", "\n  <div class='checkbox-inputgrp'>",
      x, "\n  </div>", "\n</fieldset>\n")
    )
  )
}

#' @rdname dsmCheckboxGroupInput
#' @export
updateDsmCheckboxGroupInput <- function(session, inputId, label = NULL,
                                        choices = NULL, selected = NULL,
                                        inline = FALSE, values = choices){
  message <- .dropnull(list(label = label, choices = choices, inline = inline,
                            value = selected))
  session$sendInputMessage(inputId, message)
}

.dropnull <- function(x) x[!vapply(x, is.null, FUN.VALUE = logical(1))]
