-- age of officers
SELECT o.years_on_force, COUNT(a.id) as allegation_count
FROM data_officerallegation a
JOIN officer_subset o ON o.id = a.officer_id
GROUP BY years_on_force