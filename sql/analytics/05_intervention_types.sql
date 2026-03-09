-- What types of interventions are driving the most late-stage clinical trials?
WITH InterventionCounts AS (
    SELECT 
        p.nct_id,
        i.intervention_type
    FROM vw_phase3_designs p
    INNER JOIN interventions i ON p.nct_id = i.nct_id
)
SELECT 
    intervention_type,
    COUNT(nct_id) AS total_applications
FROM InterventionCounts
GROUP BY intervention_type
ORDER BY total_applications DESC;