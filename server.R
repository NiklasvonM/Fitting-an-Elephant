server <- function(input, output, session) {
  processImage <- function() {
    image_path <- if(is.null(input$image$datapath)) {
      "fancy_elephant.png"
    } else {
      input$image$datapath
    }
    image <- load.image(image_path)
    cont <- contours(image, nlevels = 2)
    cont_data <- cont$c.1[[1]]
    x <- cont_data$x
    y <- cont_data$y
    
    data <- data.table(
      x = x,
      y = -y + max(y)
    )
    return(data)
  }

  # fourier transformation fitting the complex vector v
  #
  # v: vector of complex numbers
  # M: winding parameter (greater value corresponds to more precise fit)
  # returns: inverse discrete fourier transform as function of time t
  fourier <- function(v, M, number_points_to_fit) {
    DFT <- function(k) {
      res <- as.complex(0)
      for (m in seq_len(number_points_to_fit)) {
        res <-
          res + v[m] * exp(complex(
            real = 0,
            imaginary = -2 * pi * m * k / number_points_to_fit
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
            imaginary = 2 * pi * t * k / number_points_to_fit
          ))
      }
      res / M
    }
    return(IDFT)
  }
  
  output$fourier_transform <- renderPlot({
    data <- processImage()
    # Subset data
    number_points_to_fit <- min(nrow(data), NUMBER_POINTS_TO_FIT)
    indices <-
      seq(1, nrow(data), by = floor(nrow(data) / number_points_to_fit))[seq_len(number_points_to_fit)]
    points <- data[indices]
    original_points <- complex(real      = points$x,
                               imaginary = points$y)
    f_hat <- fourier(original_points, M = input$dimension, number_points_to_fit = number_points_to_fit)
    # "time": rotation parameter for drawing points
    time <- seq(0, number_points_to_fit, by = 1)
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
