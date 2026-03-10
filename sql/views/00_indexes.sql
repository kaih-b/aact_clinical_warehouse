-- Optimize database performance for commonly used JOINs and WHEREs

-- Index the primary and foreign keys
CREATE INDEX IF NOT EXISTS idx_studies_nct_id ON studies(nct_id);
CREATE INDEX IF NOT EXISTS idx_sponsors_nct_id ON sponsors(nct_id);
CREATE INDEX IF NOT EXISTS idx_designs_nct_id ON designs(nct_id);
CREATE INDEX IF NOT EXISTS idx_interventions_nct_id ON interventions(nct_id);

-- Index the commonly filtered columns
CREATE INDEX IF NOT EXISTS idx_studies_phase ON studies(phase);
CREATE INDEX IF NOT EXISTS idx_studies_status ON studies(overall_status);
CREATE INDEX IF NOT EXISTS idx_sponsors_name ON sponsors(name);