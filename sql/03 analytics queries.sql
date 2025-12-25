
--30-Day Newborn Health Monitoring: Analytics Queries
--MySQL


-- 0) Quick checks: row counts
SELECT 'babies' AS table_name, COUNT(*) AS rows_count FROM babies
UNION ALL SELECT 'vitals', COUNT(*) FROM vitals
UNION ALL SELECT 'size', COUNT(*) FROM size
UNION ALL SELECT 'excretion', COUNT(*) FROM excretion
UNION ALL SELECT 'jaundice', COUNT(*) FROM jaundice
UNION ALL SELECT 'immunization', COUNT(*) FROM immunization
UNION ALL SELECT 'vaccination_type', COUNT(*) FROM vaccination_type;


-- 1) Total babies + gender distribution
SELECT
  COUNT(*) AS total_babies,
  SUM(gender = 'Male') AS male_count,
  SUM(gender = 'Female') AS female_count
FROM babies;


-- 2) Missing daily vitals records (expected 31 days: day 0–30)
SELECT
  v.baby_id,
  COUNT(*) AS days_recorded,
  (31 - COUNT(*)) AS days_missing
FROM vitals v
GROUP BY v.baby_id
HAVING days_missing > 0
ORDER BY days_missing DESC;


-- 3) Average vitals by day (population trend)
SELECT
  age_days,
  ROUND(AVG(temperature_c), 2) AS avg_temp_c,
  ROUND(AVG(heart_rate_bpm), 0) AS avg_hr_bpm,
  ROUND(AVG(respiratory_rate_bpm), 0) AS avg_rr_bpm,
  ROUND(AVG(oxygen_saturation), 1) AS avg_spo2
FROM vitals
WHERE age_days BETWEEN 0 AND 30
GROUP BY age_days
ORDER BY age_days;


-- 4) Flag potential fever episodes (temperature >= 38.0°C)
SELECT
  baby_id,
  age_days,
  temperature_c
FROM vitals
WHERE temperature_c >= 38.0
ORDER BY baby_id, age_days;


-- 5) Weight change from day 0 to day 30 (growth indicator)
SELECT
  s0.baby_id,
  s0.weight_kg AS weight_day0,
  s30.weight_kg AS weight_day30,
  ROUND(s30.weight_kg - s0.weight_kg, 2) AS weight_gain_kg
FROM size s0
JOIN size s30
  ON s0.baby_id = s30.baby_id
WHERE s0.age_days = 0
  AND s30.age_days = 30
ORDER BY weight_gain_kg DESC;


-- 6) Babies with weight loss at any time (day-to-day decrease)
SELECT
  baby_id,
  age_days,
  weight_kg,
  LAG(weight_kg) OVER (PARTITION BY baby_id ORDER BY age_days) AS prev_weight,
  ROUND(weight_kg - LAG(weight_kg) OVER (PARTITION BY baby_id ORDER BY age_days), 2) AS delta_kg
FROM size
WHERE age_days BETWEEN 0 AND 30
QUALIFY delta_kg < 0;
-- NOTE: MySQL doesn't support QUALIFY.
-- If this errors, use the alternative query below instead.


-- 6B) Alternative for MySQL (no QUALIFY): weight loss days
SELECT *
FROM (
  SELECT
    baby_id,
    age_days,
    weight_kg,
    LAG(weight_kg) OVER (PARTITION BY baby_id ORDER BY age_days) AS prev_weight,
    ROUND(weight_kg - LAG(weight_kg) OVER (PARTITION BY baby_id ORDER BY age_days), 2) AS delta_kg
  FROM size
  WHERE age_days BETWEEN 0 AND 30
) t
WHERE t.delta_kg < 0
ORDER BY baby_id, age_days;


-- 7) Jaundice risk: max jaundice per baby (peak in 0–30 days)
SELECT
  baby_id,
  MAX(jaundice_level_mg_dl) AS max_jaundice_mg_dl
FROM jaundice
WHERE age_days BETWEEN 0 AND 30
GROUP BY baby_id
ORDER BY max_jaundice_mg_dl DESC;


-- 8) Excretion summary (avg urine/stool by day)
SELECT
  age_days,
  ROUND(AVG(urine_output_count), 2) AS avg_urine_count,
  ROUND(AVG(stool_count), 2) AS avg_stool_count
FROM excretion
WHERE age_days BETWEEN 0 AND 30
GROUP BY age_days
ORDER BY age_days;


-- 9) Immunization coverage: percent immunized by vaccine
SELECT
  i.vaccination_id,
  vt.vaccination_name,
  COUNT(*) AS total_records,
  SUM(i.immunized = 1) AS immunized_count,
  ROUND(100 * SUM(i.immunized = 1) / COUNT(*), 1) AS immunized_pct
FROM immunization i
LEFT JOIN vaccination_type vt
  ON vt.vaccination_id = i.vaccination_id
GROUP BY i.vaccination_id, vt.vaccination_name
ORDER BY immunized_pct DESC;


-- 10) Baby-level risk summary: fever OR high jaundice (example thresholds)
-- Fever: temp >= 38.0
-- High jaundice: >= 12 mg/dL 
SELECT
  b.baby_id,
  b.gender,
  b.gestational_age_weeks,
  MAX(CASE WHEN v.temperature_c >= 38.0 THEN 1 ELSE 0 END) AS had_fever,
  MAX(CASE WHEN j.jaundice_level_mg_dl >= 12.0 THEN 1 ELSE 0 END) AS high_jaundice
FROM babies b
LEFT JOIN vitals v ON v.baby_id = b.baby_id
LEFT JOIN jaundice j ON j.baby_id = b.baby_id
GROUP BY b.baby_id, b.gender, b.gestational_age_weeks
ORDER BY had_fever DESC, high_jaundice DESC;
