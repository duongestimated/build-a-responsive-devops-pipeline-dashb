# Load necessary libraries
library(plumber)
library(jsonlite)
library(shiny)
library(ggplot2)
library(DT)

# Define API endpoint for pipeline data
pipeline_data_endpoint <- plumb("pipeline_data") %>%
  get(function(req, res) {
    # Simulate pipeline data from a fictional API
    pipeline_data <- data.frame(
      stage = c("Build", "Test", "Deploy"),
      status = c("Success", "Failed", "Success"),
      timestamp = c("2023-02-20 14:30:00", "2023-02-20 14:35:00", "2023-02-20 14:40:00")
    )
    res BODY <- toJSON(pipeline_data, simplifyVector = TRUE)
  })

# Define Shiny UI for dashboard
ui <- fluidPage(
  titlePanel("DevOps Pipeline Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("stage", "Select Stage:", c("All", "Build", "Test", "Deploy"))
    ),
    mainPanel(
      DT::dataTableOutput("pipeline_table"),
      plotOutput("pipeline_plot")
    )
  )
)

# Define Shiny server for dashboard
server <- function(input, output) {
  pipeline_data <- reactive({
    # Simulate pipeline data from a fictional API
    data.frame(
      stage = c("Build", "Test", "Deploy"),
      status = c("Success", "Failed", "Success"),
      timestamp = c("2023-02-20 14:30:00", "2023-02-20 14:35:00", "2023-02-20 14:40:00")
    )
  })
  
  output$pipeline_table <- DT::renderDataTable({
    pipeline_data() %>% 
      filter(stage == input$stage | input$stage == "All") %>% 
      DT::datatable()
  })
  
  output$pipeline_plot <- renderPlot({
    pipeline_data() %>% 
      filter(stage == input$stage | input$stage == "All") %>% 
      ggplot(aes(x = timestamp, fill = status)) + 
      geom_bar(position = "dodge") + 
      labs(x = "Timestamp", y = "Count", fill = "Status")
  })
}

# Run Shiny app
shinyApp(ui = ui, server = server)