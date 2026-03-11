-- Filters academic and medical sponsors out; isolates biopharma corporations
CREATE OR REPLACE VIEW vw_industry_sponsors AS
SELECT 
    nct_id,
    -- Fixes duplicates (e.g. "Novartis Pharmaceuticals" & "Novartis" would be separate entities)
    CASE 
        WHEN name ILIKE '%Novartis%' THEN 'Novartis'
        WHEN name ILIKE '%Johnson & Johnson%' OR name ILIKE '%Janssen%' OR name ILIKE '%J&J%' THEN 'Johnson & Johnson'
        WHEN name ILIKE '%Merck%' THEN 'Merck'
        WHEN name ILIKE '%Hoffmann-La Roche%' OR name ILIKE '%Roche%' THEN 'Roche'
        WHEN name ILIKE '%GlaxoSmithKline%' THEN 'GSK'
        ELSE name 
    END AS sponsor_name
    name AS sponsor_name
FROM sponsors
WHERE lead_or_collaborator = 'lead'
  AND name NOT ILIKE '%University%'
  AND name NOT ILIKE '%Hospital%'
  AND name NOT ILIKE '%Institute%'
  AND name NOT ILIKE '%National%'
  AND name not ILIKE '%School%'
  AND name not ILIKE '%Clinic%'
  AND name not ILIKE '%Centers for%'
  AND name not ILIKE '%Hospices%'
  AND name not ILIKE '%Public%'
  AND name not ILIKE '%Publique%'
  AND name NOT ILIKE '%Cancer Center%'
  AND name NOT ILIKE '%Medical Center%'