-- Calculate trial durations for top 15 sponsors
WITH TrialDurations AS (
    SELECT 
        i.sponsor_name,
        p.nct_id,
        (p.completion_date - p.start_date) AS duration_days
    FROM vw_industry_sponsors i
    INNER JOIN vw_phase3_designs p ON i.nct_id = p.nct_id
    INNER JOIN vw_top_15_sponsors ts ON i.sponsor_name = ts.sponsor_name 
    WHERE p.overall_status = 'COMPLETED'
      AND p.start_date IS NOT NULL
      AND p.completion_date IS NOT NULL
      AND p.completion_date > p.start_date
),

-- Use FIRST_VALUE() window function to find the extremes for each company
SponsorExtremes AS (
    SELECT DISTINCT
        sponsor_name,
        
        -- fastest trial: least days
        FIRST_VALUE(nct_id) OVER (
            PARTITION BY sponsor_name 
            ORDER BY duration_days ASC, nct_id ASC
        ) AS fastest_trial_id,
        FIRST_VALUE(duration_days) OVER (
            PARTITION BY sponsor_name 
            ORDER BY duration_days ASC, nct_id ASC
        ) AS fastest_duration_days,

        -- slowest trial: most days
        FIRST_VALUE(nct_id) OVER (
            PARTITION BY sponsor_name 
            ORDER BY duration_days DESC, nct_id ASC
        ) AS slowest_trial_id,
        FIRST_VALUE(duration_days) OVER (
            PARTITION BY sponsor_name 
            ORDER BY duration_days DESC, nct_id ASC
        ) AS slowest_duration_days

    FROM TrialDurations
)

-- Display results with IDs attached for further exploration
SELECT 
    sponsor_name,
    fastest_trial_id,
    fastest_duration_days,
    slowest_trial_id,
    slowest_duration_days
FROM SponsorExtremes
ORDER BY sponsor_name;