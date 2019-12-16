#' shinyaccess: Accessibility in Shiny
#'
#' This package provides functions and other resources for enhancing web accessibility in Shiny apps.
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
  includeScript(system.file("inst/resources/access.js", package = "shinyaccess"))
}
