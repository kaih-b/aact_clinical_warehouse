-- Create a table of late-stage trials with key design and logistical info
CREATE OR REPLACE VIEW vw_phase3_designs AS
SELECT 
    s.nct_id,
    s.brief_title,
    s.overall_status,
    s.start_date::date,
    s.completion_date::date,
    d.allocation,
    d.masking
FROM studies s
LEFT JOIN designs d ON s.nct_id = d.nct_id
WHERE s.phase = 'Phase 3'
  AND s.start_date IS NOT NULL;