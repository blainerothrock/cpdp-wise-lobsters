CREATE VIEW officer_first_allegation as
    SELECT o.id as officer_id, da.id as allegation_id, dc.category as category, oa.start_date
    FROM data_officer o
    JOIN data_officerallegation oa ON oa.officer_id = o.id
    JOIN data_allegation da on oa.allegation_id = da.id
    JOIN data_allegationcategory dc on oa.allegation_category_id = dc.id
    WHERE oa.start_date = (SELECT start_date FROM data_officerallegation WHERE officer_id = o.id ORDER BY start_date LIMIT 1)
    ORDER BY o.id;