library(shiny)
library(RPostgres)
library(tidyverse)

con <- dbConnect(
  Postgres(),
  user = "bety",
  password = "bety",
  host = "localhost",
  port = 7999
)

get_models_from_host <- function(hostname) {
  models <- dbSendQuery(
    con,
    paste(
      "SELECT models.* FROM models, dbfiles, machines",
      "WHERE machines.hostname = $1",
      "AND dbfiles.container_id = models.id",
      "AND dbfiles.machine_id = machines.id",
      "AND dbfiles.container_type = 'Model'",
      "ORDER BY models.model_name DESC, models.revision DESC"
    )
  )
  dbBind(models, list(hostname))
  dbFetch(models)
}

if (FALSE) {
  machine <- tbl(con, "machines") %>%
    filter(machine == "docker")

  

}

ui <- fluidPage(
  titlePanel("Introduction"),
  mainPanel(
    # Select a machine
    selectInput("machines", "Machine", NULL),
    selectInput("model", "Model", NULL),
    selectInput("sitegroup", "Site group", NULL),
    selectInput("site", "Site", NULL)
  )
)

server <- function(input, output, session) {
  selected_machine <- reactive({ input$machines })
  model_table <- reactive({

  })
  selected_model <- reactive
  observeEvent(input$bety_table, {
    selected_table <- input$bety_table
    result_table <- try(tbl(con, selected_table) %>% collect())
    if (is.data.frame(result_table)) {
      output$table_preview <- renderDataTable(result_table)
    }
  })
}

shinyApp(ui = ui, server = server)
