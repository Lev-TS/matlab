# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)

# 1. Import the dataset into R
file_path <- "sts_inpr_for_import.xlsx"
data <- read_excel(file_path)

# Select individual countries from geographies and change a column name
data <- data %>%
  filter(str_detect(geo, "^[A-Z]{2}$")) %>%  # Assuming 'geo' represents countries (e.g., "DE", "FR")
  rename(Country = geo)

# 2. Industry breakdown and number of countries
industry_breakdown <- unique(data$industry)
num_countries <- length(unique(data$Country))

cat("Industry breakdown:", industry_breakdown, "\n")
cat("Number of countries:", num_countries, "\n")

# 3. Ensure production volumes are numeric
numeric_columns <- names(data)[grep("^[0-9]{4}$", names(data))] # Identify columns with year names
data[numeric_columns] <- lapply(data[numeric_columns], as.numeric)

# 4. Compute change in production volume from 2019 to 2022
data <- data %>%
  mutate(Change_2019_2022 = (`2022` - `2019`) / `2019` * 100)

# 5. Find the country with the highest and lowest change
highest_change <- data %>%
  filter(Change_2019_2022 == max(Change_2019_2022, na.rm = TRUE)) %>%
  select(Country, Change_2019_2022)

lowest_change <- data %>%
  filter(Change_2019_2022 == min(Change_2019_2022, na.rm = TRUE)) %>%
  select(Country, Change_2019_2022)

cat("Highest change:\n", highest_change, "\n")
cat("Lowest change:\n", lowest_change, "\n")

# 6. Plot the distribution of the change
ggplot(data, aes(x = Change_2019_2022)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Production Volume Change (2019-2022)",
       x = "Change in Production Volume (%)",
       y = "Frequency")

# 7. Compute the average change for each industry
avg_change_per_industry <- data %>%
  group_by(industry) %>%
  summarise(Average_Change = mean(Change_2019_2022, na.rm = TRUE))

print(avg_change_per_industry)

# 8. Barplot of the computed average percentage change
ggplot(avg_change_per_industry, aes(x = reorder(industry, Average_Change), y = Average_Change)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Average Production Volume Change by Industry (2019-2022)",
       x = "Industry",
       y = "Average Change (%)")

# 9. Create a new variable for Baltic countries
baltic_countries <- c("EE", "LV", "LT")
data <- data %>%
  mutate(Baltic = ifelse(Country %in% baltic_countries, 1, 0))

# 10. Plot production volume over time for two groups
data_long <- data %>%
  pivot_longer(cols = numeric_columns, names_to = "Year", values_to = "Production_Volume") %>%
  mutate(Year = as.numeric(Year))

grouped_data <- data_long %>%
  group_by(Baltic, Year) %>%
  summarise(Average_Production = mean(Production_Volume, na.rm = TRUE))

ggplot(grouped_data, aes(x = Year, y = Average_Production, color = factor(Baltic))) +
  geom_line(size = 1) +
  labs(title = "Production Volume Over Time: Baltic vs Rest",
       x = "Year",
       y = "Average Production Volume",
       color = "Group") +
  scale_color_manual(labels = c("Rest of Europe", "Baltics"), values = c("red", "blue"))
