-- Build normalized tables from a single wide table: all_data (MySQL)

DROP TABLE IF EXISTS vitals;
DROP TABLE IF EXISTS size;
DROP TABLE IF EXISTS jaundice;
DROP TABLE IF EXISTS excretion;
DROP TABLE IF EXISTS immunization;
DROP TABLE IF EXISTS vaccination_type;
DROP TABLE IF EXISTS babies;

-- 1) babies (one row per baby)
CREATE TABLE babies AS
SELECT DISTINCT
  baby_id,
  name,
  gender,
  gestational_age_weeks
FROM all_data;

-- 2) excretion (many rows per baby per day)
CREATE TABLE excretion AS
SELECT
  baby_id,
  age_days,
  urine_output_count,
  stool_count
FROM all_data;

-- 3) jaundice (separate table; your original code overwrote excretion)
CREATE TABLE jaundice AS
SELECT
  baby_id,
  age_days,
  jaundice_level_mg_dl
FROM all_data;

-- 4) immunization
CREATE TABLE immunization AS
SELECT
  baby_id,
  vaccination_id,
  immunized
FROM all_data;

-- 5) vaccination_type lookup (unique list)
CREATE TABLE vaccination_type AS
SELECT DISTINCT
  vaccination_id,
  vaccination_name
FROM all_data
WHERE vaccination_id IS NOT NULL;

-- 6) size / growth
CREATE TABLE size AS
SELECT
  baby_id,
  age_days,
  birth_weight_kg,
  birth_length_cm,
  birth_head_circumference_cm,
  weight_kg
FROM all_data;

-- 7) vitals
CREATE TABLE vitals AS
SELECT
  baby_id,
  age_days,
  temperature_c,
  heart_rate_bpm,
  respiratory_rate_bpm,
  oxygen_saturation
FROM all_data;
