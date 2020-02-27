#' Checkbox group input
#'
#' A Shiny checkbox group input.
#'
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param choices List of values to show checkboxes for. If elements of the
#' list are named then that name rather than the value is displayed to the user.
#' If this argument is provided, then choiceNames and choiceValues must not be
#' provided, and vice-versa. The values should be strings; other types (such as
#' logicals and numbers) will be coerced to strings.
#' @param selected The values that should be initially selected, if any.
#' @param color character, hex or R color name.
#' @param ncol number of columns when \code{inline = FALSE}. Will auto-truncate
#' to the number of choices if exceeded.
#' @param inline if \code{TRUE}, \code{ncol} is ignored.
#' @param width not in use
#' @param choiceNames,choiceValues See \code{shiny::checkboxgroup}.
#' Vector of names and values, must have same length.
#' @param session The session object passed to function given to shinyServer.
#'
#' @return A list of HTML elements that can be added to a UI definition.
#' @export
#' @importFrom shiny tagList tags singleton HTML includeScript
#'
#' @examples
#' if (interactive()) {
#' library(shiny)
#'
#' ui <- function(request) {
#' fluidPage(
#'   use_access(),
#'   fluidRow(bookmarkButton()),
#'   fluidRow(
#'     column(3,
#'       actionButton("btn1", "Reset checkbox group 1"),
#'       checkboxGroupInput(
#'         "cb1", "Shiny1 - Variables to show:",
#'         list("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear"),
#'         width = "1000px"),
#'       tableOutput("data1")
#'     ),
#'     column(3,
#'       checkboxGroupInput(
#'         "cb2", "Shiny2 - Variables to show:",
#'         list("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear"),
#'         inline = TRUE),
#'       tableOutput("data2")
#'     ),
#'     column(3,
#'       actionButton("btn3", "Reset checkbox group 3"),
#'       sa_checkboxgroup(
#'         "cb3", "SA1 - Variables to show:",
#'         c("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear", "A" = "a", "B" = "b"),
#'         selected = c("cyl", "am"), color = "dodgerblue", ncol = 3),
#'       tableOutput("data3")
#'     ),
#'     column(3,
#'     actionButton("btn4", "Set to transmission and gear"),
#'       sa_checkboxgroup(
#'         "cb4", "SA2 - Variables to show:",
#'         selected = c("cyl", "am"), color = "firebrick",
#'         choiceNames = c("Cylinders", "Transmission", "Gears"),
#'         choiceValues = c("cyl", "am", "gear"), inline = TRUE),
#'       tableOutput("data4")
#'     )
#'   )
#' )
#' }
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
#'     updateCheckboxgroup(session, "cb1", selected = character(0))
#'   })
#'   observeEvent(input$btn3, {
#'     update_sa_checkboxgroup(session, "cb3", selected = character(0))
#'   })
#'   observeEvent(input$btn4, {
#'     update_sa_checkboxgroup(session, "cb4", selected = c("am", "gear"))
#'   })
#' }
#'
#' shinyApp(ui, server, enableBookmarking = "url")
#'
#' }
sa_checkboxgroup <- function(inputId, label, choices = NULL, selected = NULL,
                             color = "#555555", ncol = 1, inline = FALSE,
                             width = NULL, choiceNames = NULL,
                             choiceValues = NULL){
  args <- normalizeChoicesArgs(choices, choiceNames, choiceValues)
  selected <- shiny::restoreInput(id = inputId, default = selected)
  v <- unlist(args$choiceValues)
  vname <- unlist(args$choiceNames)
  if(ncol < 1) stop("`ncol` must be >= 1.", call. = FALSE)
  ncol <- if(inline) 1 else min(ncol, length(v))
  if(!inline & ncol > 1){
    idx <- ceiling(seq_along(v) / ceiling(length(v) / ncol))
    v <- split(v, idx)
    vname <- split(vname, idx)
    x <- sapply(seq_along(v), function(i){
      .sa_cbg_opts(inputId, v[[i]], vname[[i]], selected, inline)
    })
    x <- paste0(x, collapse = "")
  } else {
    x <- .sa_cbg_opts(inputId, v, vname, selected, inline)
  }

  tagList(
    singleton(tags$head(includeScript(
      system.file("resources/input-binding-sa-checkboxgroup.js", package = "shinyaccess")
    ))),
    tags$style(paste0(
      "#", inputId, " input:checked + label:before { background-color: ", colorname_to_hex(color), "; }"
    )),
    HTML(
      paste0("<fieldset id='", inputId, "' class='sa-input-checkboxgrp' style='width:auto;'>",
      "\n  <legend>", label, "</legend>", x, "\n</fieldset>\n")
    )
  )
}

.sa_cbg_opts <- function(inputId, v, vname, selected, inline){
  x <- sapply(seq_along(v), function(i){
    paste0(
      '\n    <li class="sa-option-item"',
      if(inline) ' style="display:inline-block;"', '>',
      '\n      <input type="checkbox" id="sa-checkboxgroup-', v[i],
      '" name="sa-checkboxgroup-', inputId, '" value="', v[i], '"',
      if(v[i] %in% selected) ' checked="checked"', '></input>',
      '\n      <label for="sa-checkboxgroup-', v[i], '">', vname[i],
      '</label>\n    </li>'
    )
  })
  x <- paste(x, collapse = "\n      ")
  paste0('\n  <ul class="sa-options-group">', x, '\n  </ul>', sep = "\n")
}

#' @rdname sa_checkboxgroup
#' @export
update_sa_checkboxgroup <- function(session, inputId, label = NULL,
                                    choices = NULL, selected = NULL,
                                    inline = FALSE){
  message <- dropNulls(list(label = label, choices = choices, inline = inline,
                            value = selected))
  session$sendInputMessage(inputId, message)
}
