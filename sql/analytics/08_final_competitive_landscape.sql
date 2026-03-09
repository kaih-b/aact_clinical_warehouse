-- Determines completed and terminated trials for all corporate sponsors
WITH SponsorBase AS (
    SELECT 
        i.sponsor_name,
        COUNT(p.nct_id) as total_historical_p3,
        SUM(CASE WHEN p.overall_status = 'COMPLETED' THEN 1 ELSE 0 END) as total_completed,
        SUM(CASE WHEN p.overall_status = 'TERMINATED' THEN 1 ELSE 0 END) as total_terminated,
        AVG(p.completion_date - p.start_date) as avg_trial_duration_days
    FROM vw_industry_sponsors i
    INNER JOIN vw_phase3_designs p ON i.nct_id = p.nct_id
    WHERE p.overall_status IN ('COMPLETED', 'TERMINATED')
      AND p.completion_date > p.start_date
    GROUP BY i.sponsor_name
)
-- Main query: display top 20 corporate sponsors by total phase 3 trials with success/failure rates and avg trial durations
SELECT 
    sponsor_name,
    total_historical_p3,
    ROUND((total_completed::numeric / total_historical_p3) * 100, 1) AS success_rate_pct,
    ROUND((total_terminated::numeric / total_historical_p3) * 100, 1) AS failure_rate_pct,
    ROUND(avg_trial_duration_days, 0) AS avg_duration_days
FROM SponsorBase
WHERE total_historical_p3 > 20 -- Filter for established companies
ORDER BY total_historical_p3 DESC
LIMIT 20;