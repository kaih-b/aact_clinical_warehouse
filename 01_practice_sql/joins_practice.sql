-- EX 1: Combining trial status with design; one-to-one
SELECT
    studies.nct_id,
    studies.overall_status
    studies.phase,
    designs.allocation,
    designs.masking
FROM studies
INNER JOIN designs 
    ON studies.nct_id = designs.nct_id -- identifies columns to act as bridge between two tables as they are being joined
LIMIT 10;

-- EX 2: Finding all sponsors for a trial
SELECT
    studies.nct_id
    studies.brief_title
    sponsors.name AS sponsor_name
    sponsors.lead_or_collaborator
FROM studies
LEFT JOIN sponsors
    ON studies.nct_id = sponsors.nct_id
WHERE studies.nct_id = "XXXXX";

-- EX 3: Counting late-stage trials by disease with aggregation
SELECT
    conditions.name AS condition_name
    COUNT(studies.nct_id) AS total_phase_3_trials
FROM studies
INNER JOIN conditions -- attaches disease name to trial
    ON studies.nct_id = conditions.nct_id
WHERE studies.phase = 'Phase 3' 
  AND studies.overall_status = 'Recruiting'
GROUP BY conditions.name -- outputs cleanly with the number of stage 3 trials by disease name
ORDER BY total_phase_3_trials DESC
LIMIT 10;

-- EX 4: Find specific drugs tested by a certain sponsor using multi-table joining
SELECT
    studies.nct_id
    studies.phase,
    sponsors.name AS sponsor_name,
    interventions.name AS drug_name
FROM studies
INNER JOIN sponsors 
    ON studies.nct_id = sponsors.nct_id
INNER JOIN interventions -- combined id, phase, sponsors, and drug name into one table
    ON studies.nct_id = interventions.nct_id
WHERE sponsors.name ILIKE '%ex_sponsor%' -- ILIKE works as LIKE, but case insensitive
  AND interventions.intervention_type = 'Drug'
LIMIT 10;

-- EX 5: QA; find missing data (anti-join method)
SELECT 
    studies.nct_id,
    studies.start_date,
    studies.overall_status
FROM studies
LEFT JOIN facilities 
    ON studies.nct_id = facilities.nct_id
WHERE facilities.name IS NULL
  AND studies.overall_status = 'Recruiting'; -- finds studies that claim to be recruiting but have no facilities listed
-- relevant more logistically (e.g. as an administrator at a facility or sponsor) than strategically, but still relevant in data analytics workflows