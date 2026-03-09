-- Filters academic and medical sponsors out; isolates biopharma corporations
CREATE OR REPLACE VIEW vw_industry_sponsors AS
SELECT 
    nct_id,
    name AS sponsor_name
FROM sponsors
WHERE lead_or_collaborator = 'lead'
AND name NOT ILIKE ANY (ARRAY[
    '%University%',
    '%School%',
    '%Hospital%',
    '%Hospices%',
    '%Public%',
    '%Publique%',
    '%Institute%',
    '%National%',
    '%Cancer Center%',
    '%Medical Center%',
    '%Clinic%',
    '%Centers for%'
]);