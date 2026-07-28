library(shiny)
library(ggplot2)
library(latex2exp)

ui <- fluidPage(
  titlePanel("Sampling Distribution of a Sample Proportion"),
  fluidRow(
    column(4,
           sliderInput("n", label = "Sample size (n)", value = 100,
                       min = 20, max = 1000, step = 20)),
    column(4,
           sliderInput("p", label = "Population proportion (p)", value = 0.5,
                       min = 0, max = 1, step = 0.01)),
    column(4)
  ),
  fluidRow(
    column(4,
           numericInput("xmin", label = "x-axis min", value = 0,
                       min = 0, max = 1, step = 0.05)),
    column(4,
           numericInput("xmax", label = "x-axis max", value = 1,
                       min = 0, max = 1, step = 0.05)),
    column(4)
  ),
  br(),
  plotOutput("plot", width = "80%")
)

server <- function(input, output, session) {
  
  n <- reactive({ input$n })
  p <- reactive({ input$p })
  xmin <- reactive({ input$xmin })
  xmax <- reactive({ input$xmax })
  
  output$plot <- renderPlot({
    df <- data.frame(p_hat = rbinom(100000, n(), p()) / n())
    target_bins <- 100
    raw_bw <- diff(range(df$p_hat)) / target_bins
    bw <- max(round(raw_bw * n()) / n(), 1 / n())
    ggplot(df, aes(x = p_hat)) +
      geom_histogram(binwidth = bw, boundary = 0, color = "white") +
      coord_cartesian(xlim = c(xmin(), xmax())) +
      labs(title = TeX("Sampling distribution of $\\hat{p}$"),
           x = TeX("$\\hat{p}$"), y = "Count") +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.y = element_blank())
  })
}

shinyApp(ui, server)
