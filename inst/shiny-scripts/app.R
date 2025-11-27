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
      tags$p("Instructions: Upload the dataset you want analyzed, or use the example
              dataset provided. Select whether you want the transcript composition
              table or the canonical transcript table displayed, or both. If both
              options are 'No', then the plot of the canonical transcript composition
              will be displayed. Then press 'Run' to see your desired result."),

      # br() element to introduce extra vertical spacing ----
      br(),

      # input
      shinyalert::useShinyalert(force = TRUE),  # Set up shinyalert
      uiOutput("tab1"),
      uiOutput("tab2"),
      br(),
      fileInput(inputId = "file1",
                label = "Select an transcript dataset to visualize.
                File should be in .csv format with gene and exon ID, genomic coordinates, and sample numbers.",
                accept = c(".csv")),
      fileInput(inputId = "file2",
                label = "(Optional) Select an transcript dataset to visualize if want to compare both datasets.
                File should be in .csv format with gene and exon ID, genomic coordinates, and sample numbers.",
                accept = c(".csv")),
      textInput(inputId = "plotName",
                label = "Enter the name you would like the plot to be titled:", "Example"),
      selectInput(inputId = "inTC",
                  label = "Would you like to see the transcript composition data?",
                  choices = c("Yes", "No"), selected = "Yes"),
      selectInput(inputId = "inCT",
                  label = "Would you like to see the canonical transcript data?",
                  choices = c("Yes", "No"), selected = "Yes"),


      # br() element to introduce extra vertical spacing ----
      br(),

      # actionButton
      actionButton(inputId = "button1",
                   label = "Run")

    ),

    # Main Panel for Display Outputs -----
    mainPanel(
      h4("Data overview"),
      DT::DTOutput("outComm"),
      plotOutput("plot"),
      DT::DTOutput("outTC"),
      br(),
      DT::DTOutput("outCT")
    )

  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # URLs for downloading data
  url1 <- a("Example BRCA2 and TP53 Transcript Dataset",
            href="https://raw.githubusercontent.com/xsabrin/TransComp/master/inst/extdata/example_data.csv"
  )
  output$tab1 <- renderUI({
    tagList("Download Example Dataset:", url1)
  })

  # URLs for downloading data
  url2 <- a("Example BRCA2 Transcript Dataset",
            href="https://raw.githubusercontent.com/xsabrin/TransComp/master/inst/extdata/example_data2.csv"
  )
  output$tab2 <- renderUI({
    tagList("Download Example Dataset:", url2)
  })

  # Load and get data overview for the input data type
  results <- eventReactive(eventExpr = input$button1, {
    transComp::loadAndCleanData(transFile = input$file1$datapath)
  })

  # Load and get data overview for the input data type
  results2 <- eventReactive(eventExpr = input$button1, {
    if (!is.null(input$file2$datapath)) {
      transComp::loadAndCleanData(transFile = input$file2$datapath)
    }
  })

  # Get plot name
  plotTitle <- eventReactive(eventExpr = input$button1, {
    input$plotName})

  # Output data overview and plot
  observeEvent(input$button1, {
    req(results())
    if (!is.null(results2())) {
      output$outComm <- renderDataTable({data.frame("Common Transcripts"=transComp::CompTransc(results(), results2()))})
    } else {
      if (!is.null(results())) {
        if (input$inTC == "No" && input$inCT == "No") {
          # only get plot if don't get tables
          output$plot <- renderPlot({
            if (!is.null(results())) {
              transComp::plotTransCan(results(), "none")
            }
          })
        } else if (input$inTC == "Yes" && input$inCT == "Yes") {
          # get transcripts
          output$outTC <- renderDataTable({transComp::TransComp(results())})

          # get canonical transcripts
          output$outCT <- renderDataTable({data.frame("ensembl_gene_id"=transComp::CanTrans(results()))})

        } else if (input$inTC == "Yes" && input$inCT == "No") {
          output$outTC <- renderDataTable({transComp::TransComp(results())})
        } else if (input$inCT == "Yes" && input$inTC == "No") {
          output$outCT <- renderDataTable({data.frame("ensembl_gene_id"=transComp::CanTrans(results()))})
        }
      }
    }
  })

}

# Create Shiny app ----
shiny::shinyApp(ui, server)

# [END]
