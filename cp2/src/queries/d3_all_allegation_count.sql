copy (SELECT ac.category, extract('year' from da.incident_date) as year, COUNT(d.allegation_id) as count
FROM data_allegationcategory ac
LEFT JOIN data_officerallegation d on ac.id = d.allegation_category_id
LEFT JOIN data_allegation da on d.allegation_id = da.id
WHERE da.incident_date >= '2000-01-01'
AND da.is_officer_complaint = FALSE
GROUP BY ac.category, year
ORDER BY category, year, count DESC) TO '/Users/blaine/Desktop/d3_scatter/data/all_by_cat.csv' DELIMITER ',' CSV HEADER;
