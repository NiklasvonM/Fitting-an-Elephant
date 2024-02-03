server <- function(input, output, session) {
  # fourier transformation fitting the complex vector v
  #
  # v: vector of complex numbers
  # M: winding parameter (greater value corresponds to more precise fit)
  # returns: inverse discrete fourier transform as function of time t
  fourier <- function(v, M) {
    DFT <- function(k) {
      res <- as.complex(0)
      for (m in seq_len(NUMBER_POINTS_TO_FIT)) {
        res <-
          res + v[m] * exp(complex(
            real = 0,
            imaginary = -2 * pi * m * k / NUMBER_POINTS_TO_FIT
          ))
      }
      res
    }
    
    IDFT <- function(t) {
      res <- as.complex(0)
      for (k in ((1:M) - round(M / 2))) {
        res <-
          res + DFT(k) * exp(complex(
            real = 0,
            imaginary = 2 * pi * t * k / NUMBER_POINTS_TO_FIT
          ))
      }
      res / M
    }
    return(IDFT)
  }
  
  output$fourier_transform <- renderPlot({
    # Subset data
    indices <-
      seq(1, nrow(data), by = floor(nrow(data) / NUMBER_POINTS_TO_FIT))[seq_len(NUMBER_POINTS_TO_FIT)]
    points <- data[indices]
    original_points <- complex(real      = points$x,
                               imaginary = points$y)
    f_hat <- fourier(original_points, M = input$dimension)
    # "time": rotation parameter for drawing points
    time <- seq(0, NUMBER_POINTS_TO_FIT, by = 1)
    # fitted points (complex numbers)
    approximation_points <- f_hat(time)
    # fitted points as data.table
    approximation <- data.table(x = Re(approximation_points),
                                y = Im(approximation_points))
    ggplot(approximation, aes(x, y)) +
      geom_point() +
      theme_minimal() +
      theme(axis.text = element_blank(), panel.grid = element_blank()) +
      xlab("") +
      ylab("")
  })
  
}
