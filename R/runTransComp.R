# Purpose: Launch the Shiny App
# Author: Sabrina Xi
# Date: 2025-11-25
# Version: 0.2.0
# Bugs and Issues: None

#' Launch Shiny App for TransComp
#'
#' A function that launches the Shiny app for TransComp
#' The purpose of this app is to provide an interactive interface for the user
#' to make use of TransComp's functions. The code has been placed in
#' \code{./inst/shiny-scripts}.
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#' transComp::runTransComp()
#' }
#'
#' @references
#' Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J, McPherson
#' J, Dipert A, Borges B (2025). _shiny: Web Application Framework for R_.
#' doi:10.32614/CRAN.package.shiny <https://doi.org/10.32614/CRAN.package.shiny>,
#' R package version 1.11.1, <https://CRAN.R-project.org/package=shiny>.
#'
#' @export
#'
#' @importFrom shiny runApp

runTransComp <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "transComp")
  actionShiny <- shiny::runApp(appDir, display.mode = "normal")

  return(actionShiny)
}

# [END]
