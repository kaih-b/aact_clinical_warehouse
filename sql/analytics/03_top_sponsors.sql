-- Find and display the top 15 industry sponsors of phase 3 trials
WITH SponsorVolume AS (
    SELECT 
        i.sponsor_name,
        COUNT(p.nct_id) AS total_phase3_trials
    FROM vw_industry_sponsors i
    INNER JOIN vw_phase3_designs p ON i.nct_id = p.nct_id
    GROUP BY i.sponsor_name
)
SELECT * FROM SponsorVolume
ORDER BY total_phase3_trials DESC
LIMIT 15;