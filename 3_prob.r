# Define the function
plot_and_find_min <- function(x, y) {
  if (length(x) != length(y)) {
    stop("Vectors x and y must be of equal size.")
  }
  
  # Calculate x^2 - y
  result <- x^2 - y
  
  # Plot x vs (x^2 - y)
  plot(x, result, type = "b", col = "blue", pch = 16, lwd = 2,
       main = "Plot of x vs (x^2 - y)",
       xlab = "x",
       ylab = expression(x^2 - y))
  
  # Find the minimum value of x^2 - y
  min_value <- min(result)
  min_x <- x[which.min(result)]
  
  cat("Minimum value of x^2 - y is", min_value, "at x =", min_x, "\n")
  
  return(list(min_value = min_value, min_x = min_x))
}

# Example usage
x <- seq(0.1, 1, by = 0.1)  # x starts at 0.1, increases by 0.1 until 1
y <- rep(0.05, length(x))   # y is a vector of 0.05 with the same length as x

# Call the function and display the results
result <- plot_and_find_min(x, y)
