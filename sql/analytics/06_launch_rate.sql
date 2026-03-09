-- Gather trial dates and calculate the row-level gaps (days between) using window functions
WITH VelocityData AS (
    SELECT 
        i.sponsor_name,
        p.start_date,
        LAG(p.start_date) OVER (PARTITION BY i.sponsor_name ORDER BY p.start_date) AS prev_trial_date,
        -- Calculate the raw gap in days
        (p.start_date - LAG(p.start_date) OVER (PARTITION BY i.sponsor_name ORDER BY p.start_date)) AS days_between_launches
    FROM vw_industry_sponsors i
    INNER JOIN vw_phase3_designs p ON i.nct_id = p.nct_id
    INNER JOIN vw_top_15_sponsors ts ON i.sponsor_name = ts.sponsor_name 
    WHERE p.start_date IS NOT NULL
)

-- Main Query: Aggregate the gaps into actionable business metrics
SELECT 
    sponsor_name,
    COUNT(start_date) AS total_trials_analyzed,
    ROUND(AVG(days_between_launches), 1) AS avg_days_between_launches,
    MAX(days_between_launches) AS longest_gap_days
FROM VelocityData
WHERE days_between_launches IS NOT NULL -- avoids first trials (no time between the first trial)
  AND days_between_launches >= 0 -- filters errors (< 0 gaps between trials)
GROUP BY sponsor_name
ORDER BY avg_days_between_launches ASC;