#' shinyaccess: Accessibility in Shiny
#'
#' This package provides functions and other resources for enhancing web
#' accessibility in Shiny apps.
#' @docType package
#' @name shinyaccess
NULL

#' Initialize shinyaccess
#'
#' Initialize shinyaccess in Shiny UI.
#'
#' @return nothing returned
#' @export
#'
#' @examples
#' if(interactive()){
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       use_access(),
#'       h3("App title")
#'     ),
#'     server = function(input, output, session){
#'       set_lang(session, "en")
#'     }
#'   )
#' }
use_access <- function(){
  shiny::tagList(
    shiny::tags$head(shiny::includeScript(
      system.file("inst/resources/access.js", package = "shinyaccess")
    )),
    shiny::tags$head(shiny::includeScript(
      system.file("inst/resources/toggle-action.js", package = "shinyaccess")
    )),
    shiny::tags$head(shiny::includeCSS(
      system.file("inst/resources/styles.css", package = "shinyaccess")
    ))
  )
}
