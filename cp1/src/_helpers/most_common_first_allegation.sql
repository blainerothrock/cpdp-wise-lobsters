SELECT category, COUNT(officer_id) as count
FROM officer_first_allegation
WHERE officer_id IN (SELECT id FROM officer_subset)
GROUP BY category
ORDER BY count DESC;