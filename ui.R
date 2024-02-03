ui <- fluidPage(
  tags$h2(
    '"With four parameters I can fit an elephant, and with five I can make him wiggle his trunk." - John von Neumann'
  ),
  sliderInput(
    inputId = "dimension",
    label = "Number of parameters",
    min = 1,
    max = 300,
    value = 1
  ),
  plotOutput("fourier_transform")
)
