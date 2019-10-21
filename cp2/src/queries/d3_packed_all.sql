copy (
    SELECT dc.category, dc.allegation_name, COUNT(DISTINCT oa.allegation_id)
    FROM data_officerallegation oa
    JOIN data_allegation da on da.id = oa.allegation_id
    JOIN data_allegationcategory dc on oa.allegation_category_id = dc.id
    WHERE da.is_officer_complaint = FALSE
    GROUP BY dc.category, dc.allegation_name
) TO '/Users/blaine/dev/ds/allegation_cat_name.csv' DELIMITER ',' CSV HEADER;
