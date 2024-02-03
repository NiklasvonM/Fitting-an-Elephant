library(shiny)
library(data.table)
library(ggplot2)
library(imager)

# Decrease for quicker runtime but a less pretty image.
# Is capped to the number of data points of the extracted information from
# the image.
NUMBER_POINTS_TO_FIT <- 10000
