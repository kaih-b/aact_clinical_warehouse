-- Filters academic and medical sponsors out; isolates biopharma corporations
CREATE OR REPLACE VIEW vw_industry_sponsors AS
SELECT 
    nct_id,
    name AS sponsor_name
FROM sponsors
WHERE lead_or_collaborator = 'lead'
  AND name NOT ILIKE '%University%'
  AND name NOT ILIKE '%Hospital%'
  AND name NOT ILIKE '%Institute%'
  AND name NOT ILIKE '%National%';