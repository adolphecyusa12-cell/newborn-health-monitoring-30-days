##### Build Daily Integrated Dataset (daily_data) #####

# Join all daily tables
daily_data <- size %>%
  left_join(babies, by = "baby_id") %>%
  left_join(excretion, by = c("baby_id", "age_days")) %>%
  left_join(vitals, by = c("baby_id", "age_days")) %>%
  left_join(illness, by = c("baby_id", "age_days")) %>%
  left_join(immunization, by = c("baby_id", "age_days")) %>%
  left_join(vaccination_type, by = "vaccination_id")

# Create weight gain metrics
daily_data <- daily_data %>%
  group_by(baby_id) %>%
  arrange(age_days, .by_group = TRUE) %>%
  mutate(
    prev_weight_kg  = lag(weight_kg),
    daily_gain_kg   = weight_kg - prev_weight_kg,
    gain_30_days_kg = if_else(age_days == 30,
                              weight_kg - birth_weight_kg,
                              NA_real_)
  ) %>%
  ungroup()

# Low birth weight group
daily_data <- daily_data %>%
  mutate(
    lbw_group = if_else(birth_weight_kg < 2.5,
                        "LBW (<2.5kg)",
                        "Normal (>=2.5kg)")
  )

# Immunization flag (Yes/No -> 1/0)
daily_data <- daily_data %>%
  mutate(
    immunized_flag = case_when(
      tolower(immunized) %in% c("yes", "y") ~ 1,
      tolower(immunized) %in% c("no", "n")  ~ 0,
      TRUE ~ NA_real_
    )
  )
