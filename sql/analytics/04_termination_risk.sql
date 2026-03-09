-- Is there a relationship between trial design (masking level) and chance of termination?
WITH TrialOutcomes AS (
    SELECT 
        masking,
        COUNT(nct_id) AS total_trials,
        SUM(CASE WHEN overall_status = 'TERMINATED' THEN 1 ELSE 0 END) AS terminated_trials
    FROM vw_phase3_designs
    WHERE overall_status IN ('COMPLETED', 'TERMINATED')
      AND masking IS NOT NULL
    GROUP BY masking
)
SELECT 
    masking,
    total_trials,
    terminated_trials,
    ROUND((terminated_trials::numeric / total_trials) * 100, 2) AS termination_pct
FROM TrialOutcomes
WHERE total_trials > 50
ORDER BY termination_pct DESC;