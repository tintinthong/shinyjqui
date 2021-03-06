library(shiny)
library(highcharter)

## used in ui
jqui_resizable(actionButton('btn', 'Button'))
jqui_draggable(plotOutput('plot', width = '400px', height = '400px'),
                options = list(axis = 'x'))
jqui_selectable(
  div(
    id = 'sel_plots',
    highchartOutput('highchart', width = '300px'),
    plotOutput('ggplot', width = '300px')
  ),
  options = list(
    classes = list(`ui-selected` = 'ui-state-highlight')
  )
)
jqui_sortable(tags$ul(
  id = 'lst',
  tags$li('A'),
  tags$li('B'),
  tags$li('C')
))

## used in server
\dontrun{
  jqui_draggable('#foo', options = list(grid = c(80, 80)))
  jqui_droppable('.foo', operation = "enable")
}

## use shiny input
if (interactive()) {
  shinyApp(
    server = function(input, output) {
      output$foo <- renderHighchart({
        hchart(mtcars, "scatter", hcaes(x = cyl, y = mpg))
      })
      output$position <- renderPrint({
        print(input$foo_position)
      })
    },
    ui = fluidPage(
      verbatimTextOutput('position'),
      jqui_draggable(highchartOutput('foo', width = '200px', height = '200px'))
    )
  )
}

## custom shiny input
func <- JS('function(event, ui){return $(event.target).offset();}')
options <-  list(
  shiny = list(
    abs_position = list(
      dragcreate = func, # send returned value back to shiny when interaction is created.
      drag = func # send returned value to shiny when dragging.
    )
  )
)
jqui_draggable(highchartOutput('foo', width = '200px', height = '200px'),
                options = options)


