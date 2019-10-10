SELECT age_group, COUNT(o.id) as officer_count
FROM officer_subset o
GROUP BY age_group
ORDER BY age_group;