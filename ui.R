ui <- fluidPage(
  tags$h2(
    '"With four parameters I can fit an elephant, and with five I can make him wiggle his trunk." - John von Neumann'
  ),
  shiny::column(6, 
  sliderInput(
    inputId = "dimension",
    label = "Number of parameters",
    min = 1,
    max = 300,
    value = 1
  )),
  column(6, fileInput("image", "Choose file")),
  plotOutput("fourier_transform")
)
