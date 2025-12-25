##### Visualizations #####
# Figure 1: Gender distribution (pie chart)

gender_counts <- babies %>%
  count(gender) %>%
  mutate(
    percent = round(n / sum(n) * 100, 1),
    label   = paste0(gender, " (", percent, "%)")
  )

p_gender <- ggplot(gender_counts, aes(x = "", y = n, fill = gender)) +
  geom_col(width = 1, color = "white") +
  coord_polar("y") +
  geom_text(aes(label = label),
            position = position_stack(vjust = 0.5),
            size = 5) +
  labs(title = "Gender Distribution of Newborns") +
  theme_void() +
  theme(legend.position = "none")

p_gender
