CREATE TEMP VIEW officer_subset AS
    SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
          date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
          ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
          COUNT(a.id) as allegation_count,
           (SELECT da.incident_date
               FROM data_officerallegation oa
               JOIN data_allegation da on oa.allegation_id = da.id
                JOIN data_allegationcategory category on oa.allegation_category_id = category.id
               WHERE o.id = oa.officer_id
                AND category.category NOT IN ('Operation/Personnel Violations',
                       'Lockup Procedures',
                       'Traffic',
                       'Supervisory Responsibilities',
                       'Unknown',
                       'Medical')
               LIMIT 1
               OFFSET 10
            ) as repeater_start_date
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC

SELECT * FROM officer_subset

DROP VIEW officer_subset CASCADE


CREATE TEMP VIEW officer_first_allegation AS
    SELECT da.id as allegation_id,
           o.id as officer_id,
           dc.category as category,
           da.incident_date as incident_date
    FROM officer_subset o
    JOIN data_officerallegation oa ON oa.officer_id = o.id
    JOIN data_allegation da on oa.allegation_id = da.id
    JOIN data_allegationcategory dc on oa.allegation_category_id = dc.id
    WHERE da.incident_date = (
        SELECT d.incident_date
        FROM data_officerallegation
        JOIN data_allegation d on data_officerallegation.allegation_id = d.id
        WHERE officer_id = o.id
        ORDER BY d.incident_date LIMIT 1)
        AND dc.category NOT IN ('Operation/Personnel Violations',
                       'Lockup Procedures',
                       'Traffic',
                       'Supervisory Responsibilities',
                       'Unknown',
                       'Medical');

SELECT allegation_id, COUNT(*)
FROM data_officerallegation
WHERE allegation_id IN (SELECT allegation_id FROM officer_first_allegation)
GROUP BY allegation_id
ORDER by COUNT(*) DESC

SELECT COUNT(*) FROM officer_first_allegation;

DROP VIEW officer_first_allegation;

CREATE TEMP VIEW repeaters AS
    SELECT
           officer.id as officer_id,
           (SELECT da.incident_date
               FROM data_officerallegation oa
               JOIN data_allegation da on oa.allegation_id = da.id
                JOIN data_allegationcategory category on oa.allegation_category_id = category.id
               WHERE officer.id = oa.officer_id
                AND category.category NOT IN ('Operation/Personnel Violations',
                       'Lockup Procedures',
                       'Traffic',
                       'Supervisory Responsibilities',
                       'Unknown',
                       'Medical')
               LIMIT 1
               OFFSET 10
            ) as repeater_start_date
    FROM data_officer officer
    WHERE officer.id NOT IN (SELECT id FROM officer_subset)

SELECT COUNT(*) FROM repeaters WHERE repeater_start_date is not null
SELECT COUNT(*) FROM officer_subset

DROP VIEW repeaters

