library(shiny)
library(data.table)
library(ggplot2)
library(imager)

image <- load.image("fancy_elephant.png")
cont <- contours(image, nlevels = 2)
cont_data <- cont$c.1[[1]]
x <- cont_data$x
y <- cont_data$y

data <- data.table(
  x = x,
  y = -y + max(y)
)

# Decrease for quicker runtime but a less pretty image
NUMBER_POINTS_TO_FIT <- nrow(data)
