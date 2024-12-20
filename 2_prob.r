# Load necessary libraries
library(readxl)
library(ggplot2)

# Load the dataset
file_path <- "/mnt/data/sts_inpr_for_import.xlsx"
data <- read_excel(file_path)

# Examine the dataset
head(data)

# Assume column names: 'x' and 'u' are available in the dataset, adapt as needed.
x <- data$x  # Replace 'x' with the actual column name for independent variable
u <- data$u  # Replace 'u' with the actual column name for residual

# 1. Generate y using the given model: yt = β0 + β1xt + β2x^2t + ut
set.seed(123)  # For reproducibility
beta_0 <- 2  # Intercept
beta_1 <- 3  # Linear coefficient
beta_2 <- -0.5  # Quadratic coefficient

y <- beta_0 + beta_1 * x + beta_2 * x^2 + u

# 2. Define the OLS model function
ols_model <- function(x, y) {
  # Create a design matrix for the regression
  X <- cbind(1, x, x^2)
  # Compute coefficients using the OLS formula: β = (X'X)^(-1) X'y
  beta <- solve(t(X) %*% X) %*% t(X) %*% y
  # Return coefficients
  return(as.vector(beta))
}

# Estimate coefficients
coefficients <- ols_model(x, y)
cat("Estimated coefficients:", coefficients, "\n")

# 3. Scatterplot with linear fit
# Create a dataframe for ggplot
plot_data <- data.frame(x = x, y = y)

# Add fitted values to the data
plot_data$y_fit <- coefficients[1] + coefficients[2] * plot_data$x + coefficients[3] * plot_data$x^2

# Plot scatterplot and linear fit
ggplot(plot_data, aes(x = x, y = y)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_line(aes(y = y_fit), color = "red", size = 1) +
  labs(title = "Scatterplot with Quadratic Fit",
       x = "x",
       y = "y") +
  theme_minimal()

# 4. Interpretation
cat("Does the quadratic fit describe the association well?\n")
cat("Answer: Yes, because the quadratic model captures the curvature in the relationship between x and y.")
