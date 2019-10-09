SELECT age_group, AVG(allegation_count)
FROM officer_subset
GROUP BY age_group
ORDER BY age_group;