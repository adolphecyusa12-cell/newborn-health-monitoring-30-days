-- Add keys & constraints after CTAS

-- Babies: primary key
ALTER TABLE babies
  ADD PRIMARY KEY (baby_id);

-- For “daily” tables, use composite primary key (baby_id + age_days)
ALTER TABLE excretion
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_excretion_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

ALTER TABLE jaundice
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_jaundice_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

ALTER TABLE size
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_size_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

ALTER TABLE vitals
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_vitals_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

-- Vaccine type: primary key
ALTER TABLE vaccination_type
  ADD PRIMARY KEY (vaccination_id);

-- Immunization: key + foreign keys
ALTER TABLE immunization
  ADD PRIMARY KEY (baby_id, vaccination_id),
  ADD CONSTRAINT fk_immunization_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE,
  ADD CONSTRAINT fk_immunization_vaccine
    FOREIGN KEY (vaccination_id) REFERENCES vaccination_type(vaccination_id);
