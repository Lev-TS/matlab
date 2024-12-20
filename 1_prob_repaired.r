# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

# Step 1: Import the dataset
file_path <- "/mnt/data/sts_inpr_for_import.xlsx"
data <- read_excel(file_path)

# Change a column name (e.g., rename `geo` to `Country`)
data <- data %>%
  rename(Country = geo)

# Step 2: Industry breakdown and number of countries
# Select only individual countries (assume they are 2-character codes)
data <- data %>%
  filter(nchar(Country) == 2)

industry_breakdown <- unique(data$industry)
num_countries <- length(unique(data$Country))

cat("Industry breakdown:\n", industry_breakdown, "\n")
cat("Number of countries:", num_countries, "\n")

# Step 3: Ensure production volumes are numeric
# Find numeric columns (assume year columns are in "YYYY" format)
numeric_columns <- names(data)[grep("^[0-9]{4}$", names(data))]
data[numeric_columns] <- lapply(data[numeric_columns], as.numeric)

# Step 4: Compute change in production volume (2022 vs 2019)
data <- data %>%
  mutate(Change_2019_2022 = (`2022` - `2019`) / `2019` * 100)

# Step 5: Find the country with the highest and lowest change
highest_change <- data %>%
  filter(Change_2019_2022 == max(Change_2019_2022, na.rm = TRUE)) %>%
  select(Country, industry, Change_2019_2022)

lowest_change <- data %>%
  filter(Change_2019_2022 == min(Change_2019_2022, na.rm = TRUE)) %>%
  select(Country, industry, Change_2019_2022)

cat("Country with the highest change:\n", highest_change, "\n")
cat("Country with the lowest change:\n", lowest_change, "\n")

# Step 6: Plot the distribution of the change
ggplot(data, aes(x = Change_2019_2022)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Production Volume Change (2019-2022)",
       x = "Change in Production Volume (%)",
       y = "Frequency") +
  theme_minimal()

# Step 7: Compute average change per industry
avg_change_per_industry <- data %>%
  group_by(industry) %>%
  summarise(Average_Change = mean(Change_2019_2022, na.rm = TRUE))

cat("Average change per industry:\n")
print(avg_change_per_industry)

# Step 8: Barplot of the average percentage change by industry
ggplot(avg_change_per_industry, aes(x = reorder(industry, Average_Change), y = Average_Change)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Average Production Volume Change by Industry (2019-2022)",
       x = "Industry",
       y = "Average Change (%)") +
  theme_minimal()

# Step 9: Create a new variable for Baltic countries
baltic_countries <- c("EE", "LV", "LT")  # Estonia, Latvia, Lithuania
data <- data %>%
  mutate(Baltic = ifelse(Country %in% baltic_countries, 1, 0))

# Step 10: Plot production volume over time for Baltic vs non-Baltic
# Convert data to long format
data_long <- data %>%
  pivot_longer(cols = numeric_columns, names_to = "Year", values_to = "Production_Volume") %>%
  mutate(Year = as.numeric(Year))

# Compute average production volume for each group (Baltic vs non-Baltic)
grouped_data <- data_long %>%
  group_by(Baltic, Year) %>%
  summarise(Average_Production = mean(Production_Volume, na.rm = TRUE))

# Plot the production volume over time for both groups
ggplot(grouped_data, aes(x = Year, y = Average_Production, color = factor(Baltic))) +
  geom_line(size = 1) +
  labs(title = "Production Volume Over Time: Baltic vs Rest",
       x = "Year",
       y = "Average Production Volume",
       color = "Group") +
  scale_color_manual(labels = c("Rest of Europe", "Baltics"), values = c("red", "blue")) +
  theme_minimal()
