estimate_ols_model <- function(n = 100, seed = 123) {
  set.seed(seed) # Set seed for reproducibility

  # Generate data
  x <- runif(n, -10, 10) # Random x values
  u <- rnorm(n, mean = 0, sd = 5) # Random residuals

  # Define parameters
  beta0 <- 5
  beta1 <- 2
  beta2 <- -0.5

  # Generate y based on the model
  y <- beta0 + beta1 * x + beta2 * x^2 + u

  # Create data frame
  data <- data.frame(x = x, y = y)

  # Estimate OLS model
  model <- lm(y ~ x + I(x^2), data = data)

  # Scatterplot with fitted line
  plot(data$x, data$y, main = "Scatterplot with Fitted Line",
       xlab = "x", ylab = "y", pch = 19, col = "blue")
  curve(coef(model)[1] + coef(model)[2] * x + coef(model)[3] * x^2,
        from = min(data$x), to = max(data$x), add = TRUE, col = "red", lwd = 2)

  # Print summary of the model
  print(summary(model))

  # Return model and data
  return(list(model = model, data = data))
}

# Run the function
results <- estimate_ols_model()
