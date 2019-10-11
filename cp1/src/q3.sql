CREATE TEMP VIEW officer_first_allegation as
    SELECT o.id as officer_id, da.id as allegation_id, dc.category as category, oa.start_date
    FROM officer_subset o
    JOIN data_officerallegation oa ON oa.officer_id = o.id
    JOIN data_allegation da on oa.allegation_id = da.id
    JOIN data_allegationcategory dc on oa.allegation_category_id = dc.id
    WHERE da.incident_date = (
        SELECT d.incident_date
        FROM data_officerallegation
        JOIN data_allegation d on data_officerallegation.allegation_id = d.id
        WHERE officer_id = o.id
        ORDER BY d.incident_date LIMIT 1
    )
    ORDER BY o.id;

SELECT category, COUNT(officer_id) as count
FROM officer_first_allegation
GROUP BY category
ORDER BY count DESC;