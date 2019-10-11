SELECT a.category, COUNT(oa.id) as allegation_count
FROM data_officerallegation oa
LEFT JOIN data_allegationcategory a ON oa.allegation_category_id = a.id
WHERE oa.officer_id in (SELECT id FROM officer_subset)
GROUP BY a.category
ORDER BY allegation_count DESC;
