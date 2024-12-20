# Load required library
library(ggplot2)

# Define a function to estimate an OLS model
ols_model <- function(n = 100, seed = 123) {
  set.seed(seed)
  
  # Step 1: Generate data
  x <- runif(n, -10, 10)  # Random x values between -10 and 10
  u <- rnorm(n, 0, 5)     # Random residuals from normal distribution
  beta0 <- 5
  beta1 <- 2
  beta2 <- -0.5
  y <- beta0 + beta1 * x + beta2 * x^2 + u  # Generate y based on the model
  
  # Step 2: Fit the OLS model
  model <- lm(y ~ x + I(x^2))  # Fit quadratic model
  
  # Step 3: Make a scatterplot with the linear fit
  data <- data.frame(x = x, y = y)
  ggplot(data, aes(x = x, y = y)) +
    geom_point(color = "blue", alpha = 0.6) +  # Scatterplot
    geom_smooth(method = "lm", formula = y ~ x + I(x^2), color = "red", se = FALSE) +
    labs(title = "Scatterplot with Quadratic Fit",
         x = "x",
         y = "y") +
    theme_minimal()
  
  # Step 4: Summary of the model
  summary(model)
}

# Call the function
ols_model()
