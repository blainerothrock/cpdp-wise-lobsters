SELECT years_on_force, AVG(allegation_count)
FROM officer_subset
GROUP by years_on_force
ORDER BY years_on_force;