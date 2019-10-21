SELECT d.id, COUNT(oa.id) as allegation_count FROM
data_officer d
JOIN data_officerallegation oa on d.id = oa.officer_id
GROUP BY d.id
HAVING COUNT(oa.id) >= 10