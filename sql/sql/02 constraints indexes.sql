-- Add keys, constraints, and useful indexes (MySQL)

-- babies PK
ALTER TABLE babies
  MODIFY baby_id INT NOT NULL,
  ADD PRIMARY KEY (baby_id);

-- vaccination_type PK
ALTER TABLE vaccination_type
  MODIFY vaccination_id INT NOT NULL,
  ADD PRIMARY KEY (vaccination_id);

-- daily tables: composite PK (baby_id, age_days)
ALTER TABLE excretion
  MODIFY baby_id INT NOT NULL,
  MODIFY age_days INT NOT NULL,
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_excretion_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

ALTER TABLE jaundice
  MODIFY baby_id INT NOT NULL,
  MODIFY age_days INT NOT NULL,
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_jaundice_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

ALTER TABLE size
  MODIFY baby_id INT NOT NULL,
  MODIFY age_days INT NOT NULL,
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_size_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

ALTER TABLE vitals
  MODIFY baby_id INT NOT NULL,
  MODIFY age_days INT NOT NULL,
  ADD PRIMARY KEY (baby_id, age_days),
  ADD CONSTRAINT fk_vitals_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE;

-- immunization: composite PK and FKs
ALTER TABLE immunization
  MODIFY baby_id INT NOT NULL,
  MODIFY vaccination_id INT NOT NULL,
  ADD PRIMARY KEY (baby_id, vaccination_id),
  ADD CONSTRAINT fk_immunization_baby
    FOREIGN KEY (baby_id) REFERENCES babies(baby_id)
    ON DELETE CASCADE,
  ADD CONSTRAINT fk_immunization_vaccine
    FOREIGN KEY (vaccination_id) REFERENCES vaccination_type(vaccination_id);

-- Helpful indexes for faster analysis
CREATE INDEX idx_vitals_day ON vitals (age_days);
CREATE INDEX idx_size_day ON size (age_days);
CREATE INDEX idx_excretion_day ON excretion (age_days);
CREATE INDEX idx_jaundice_day ON jaundice (age_days);
