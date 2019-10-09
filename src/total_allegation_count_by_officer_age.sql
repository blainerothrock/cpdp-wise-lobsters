-- age of officers
SELECT age_group, COUNT(a.id) as allegation_count
FROM officer_subset o
JOIN data_officerallegation a ON a.officer_id = o.id
GROUP BY age_group
ORDER BY age_group;