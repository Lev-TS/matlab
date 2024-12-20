# Step 1: Import the dataset
library(readxl)

# Read the data and clean up the headers
data <- read_excel("sts_inpr_for_import.xlsx", skip = 1)

# Rename columns for better clarity (example: change 'TIME' to 'Industry')
colnames(data)[1] <- "Industry"
colnames(data)[2] <- "Geography"

# Filter for individual countries (exclude aggregates like EU, Euro area)
individual_countries <- data[!grepl("European Union|Euro area", data$Geography), ]

# Step 2: Print industry breakdown and count countries
print("Industry breakdown:")
print(unique(individual_countries$Industry))

num_countries <- length(unique(individual_countries$Geography))
print(paste("Number of countries included:", num_countries))

# Step 3: Ensure production volumes are numeric
# Convert columns starting from year 2014 to numeric
cols_to_numeric <- grep("^\\d{4}$", colnames(data))
for (col in cols_to_numeric) {
  individual_countries[[col]] <- as.numeric(individual_countries[[col]])
}

# Step 4: Compute percentage change in production volume (2022 vs 2019)
individual_countries$Change_2022_2019 <- 
  ((individual_countries$`2022` - individual_countries$`2019`) / individual_countries$`2019`) * 100

print("Percentage change in production volume (2022 vs 2019):")
print(individual_countries[, c("Geography", "Industry", "Change_2022_2019")])

# Step 5: Find the highest and lowest changes
highest_change <- individual_countries[which.max(individual_countries$Change_2022_2019), ]
lowest_change <- individual_countries[which.min(individual_countries$Change_2022_2019), ]

print("Country with highest change:")
print(highest_change)

print("Country with lowest change:")
print(lowest_change)

# Step 6: Plot the distribution of changes
library(ggplot2)
ggplot(individual_countries, aes(x = Change_2022_2019)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Production Volume Changes (2022 vs 2019)",
       x = "Percentage Change",
       y = "Frequency")

# Step 7: Compute average change by industry
avg_change_by_industry <- aggregate(Change_2022_2019 ~ Industry, data = individual_countries, mean)
print("Average percentage change by industry:")
print(avg_change_by_industry)

# Step 8: Barplot of average percentage change
ggplot(avg_change_by_industry, aes(x = reorder(Industry, Change_2022_2019), y = Change_2022_2019)) +
  geom_bar(stat = "identity", fill = "orange") +
  theme_minimal() +
  coord_flip() +
  labs(title = "Average Change in Production Volume by Industry",
       x = "Industry",
       y = "Average Percentage Change")

# Step 9: Create a new variable for Baltics (Latvia, Lithuania, Estonia)
individual_countries$Baltics <- ifelse(individual_countries$Geography %in% c("Latvia", "Lithuania", "Estonia"), 1, 0)

# Step 10: Plot production volume over time for Baltics vs rest
individual_countries$Group <- ifelse(individual_countries$Baltics == 1, "Baltics", "Rest")

# Reshape data for time series plotting
library(tidyr)
time_series_data <- individual_countries %>%
  pivot_longer(cols = `2014`:`2023`, names_to = "Year", values_to = "Production_Volume")

time_series_summary <- time_series_data %>%
  group_by(Year, Group) %>%
  summarise(Average_Production = mean(Production_Volume, na.rm = TRUE))

# Plot
ggplot(time_series_summary, aes(x = as.numeric(Year), y = Average_Production, color = Group)) +
  geom_line(size = 1) +
  theme_minimal() +
  labs(title = "Production Volume Over Time",
       x = "Year",
       y = "Average Production Volume",
       color = "Group")