CREATE TEMP VIEW officer_subset AS
    SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
          date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
          ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
          COUNT(a.id) as allegation_count
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC;

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

DROP VIEW officer_first_allegation;
DROP VIEW officer_subset;