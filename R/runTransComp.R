# Purpose: Launch the Shiny App
# Author: Sabrina Xi
# Date: 2025-11-25
# Version: 0.2.0
# Bugs and Issues: None

#' Launch Shiny App for TransComp
#'
#' A function that launches the Shiny app for TransComp.
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
#' Attali D, Edwards T (2024). _shinyalert: Easily Create Pretty Popup Messages
#' (Modals) in 'Shiny'_. doi:10.32614/CRAN.package.shinyalert
#' <https://doi.org/10.32614/CRAN.package.shinyalert>, R package version 3.1.0,
#'<https://CRAN.R-project.org/package=shinyalert>.
#'
#' Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J, McPherson
#' J, Dipert A, Borges B (2025). _shiny: Web Application Framework for R_.
#' doi:10.32614/CRAN.package.shiny <https://doi.org/10.32614/CRAN.package.shiny>,
#' R package version 1.11.1, <https://CRAN.R-project.org/package=shiny>.
#'
#' Xie Y, Cheng J, Tan X, Aden-Buie G (2025). _DT: A Wrapper of the JavaScript
#' Library 'DataTables'_. doi:10.32614/CRAN.package.DT
#' <https://doi.org/10.32614/CRAN.package.DT>, R package version 0.34.0,
#' <https://CRAN.R-project.org/package=DT>.
#'
#'
#' @export
#'
#' @importFrom shiny runApp
#' @import shinyalert
#' @import DT

runTransComp <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "transComp")
  actionShiny <- shiny::runApp(appDir, display.mode = "normal")

  return(actionShiny)
}

# [END]
