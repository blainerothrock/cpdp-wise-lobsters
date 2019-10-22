CREATE VIEW officer_first_allegation as
    SELECT o.id as officer_id, da.id as allegation_id, dc.category as category, dc.allegation_name as name, oa.start_date, da.incident_date
    FROM data_officer o
    JOIN data_officerallegation oa ON oa.officer_id = o.id
    JOIN data_allegation da on oa.allegation_id = da.id
    JOIN data_allegationcategory dc on oa.allegation_category_id = dc.id
    WHERE o.appointed_date >= '2000-01-01' AND da.incident_date = (
        SELECT d.incident_date
        FROM data_officerallegation
        JOIN data_allegation d on data_officerallegation.allegation_id = d.id
        WHERE officer_id = o.id AND d.incident_date >= '2000-01-01'
        ORDER BY d.incident_date LIMIT 1
    )
    AND da.is_officer_complaint = FALSE
    ORDER BY da.incident_date;