# Purpose: Code for Shiny App for TransComp
# Author: Sabrina Xi
# Date: 2025-11-23
# Version: 0.2.0
# Bugs and Issues: None

# This example is adapted from
# Grolemund, G. (2015). Learn Shiny - Video Tutorials. URL:https://shiny.rstudio.com/tutorial/

library(shiny)
library(shinyalert)

# Define UI
ui <- fluidPage(

  # Change title
  titlePanel("TransComp: Identifying Transcript Composition Based on Genomic
             Coordinates"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      tags$p("TransComp is an R package for analysis and visualization of transcript
             datasets using genomic coordinates. This Shiny app provides the user
             interface for TransComp."),

      # br() element to introduce extra vertical spacing ----
      br(),

      # input
      tags$p("Instructions: Below, enter or select values required to perform the analysis. Default
             values are shown. Then press 'Run'. Navigate through
             the different tabs to the right to explore the results."),

      # br() element to introduce extra vertical spacing ----
      br(),

      # input
      shinyalert::useShinyalert(force = TRUE),  # Set up shinyalert
      uiOutput("tab1"),
      br(),
      fileInput(inputId = "file1",
                label = "Select an transcript dataset to visualize.
                File should be in .csv format with gene and exon ID, genomic coordinates, and sample numbers.",
                accept = c(".csv")),
      textInput(inputId = "plotName",
                label = "Enter the name you would like the plot to be titled:", "Example"),


      # br() element to introduce extra vertical spacing ----
      br(),

      # actionButton
      actionButton(inputId = "button1",
                   label = "Run"),

    ),

    # Main panel for displaying outputs ----
    mainPanel(
      h4("Data overview"),
      verbatimTextOutput("textOutOverview"),
      br(),
      plotOutput("plot")
    )

  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Load and get data overview for the input data type
  results <- eventReactive(eventExpr = input$button1, {
    transComp::loadAndCleanData(transFile = input$file1$datapath)
  })

  # Get plot name
  plotTitle <- eventReactive(eventExpr = input$button1, {
    input$plotName})

  # Output data overview and plot
  observeEvent(input$button1, {
    req(results())
    if (!is.null(results())) {
      output$plot <- renderPlot({
        if (!is.null(results())) {
          transComp::plotTransCan(results(), "none")
        }
      })
    }
  })

  # URLs for downloading data
  url1 <- a("Example BRCA2 and TP53 Transcript Dataset",
            href="https://raw.githubusercontent.com/xsabrin/TransComp/master/inst/extdata/example_data.csv"
  )
  output$tab1 <- renderUI({
    tagList("Download Example Dataset:", url1)
  })

}

# Create Shiny app ----
shiny::shinyApp(ui, server)

# [END]
