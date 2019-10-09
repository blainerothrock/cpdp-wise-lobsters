SELECT o.years_on_force, COUNT(o.id) as officer_count
FROM officer_subset o
GROUP BY years_on_force