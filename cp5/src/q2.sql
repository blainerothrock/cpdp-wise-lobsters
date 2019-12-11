-- Officer Subset
DROP VIEW IF EXISTS cp5_officer_subset cascade;
CREATE VIEW cp5_officer_subset AS
    SELECT
           o.id,
           o.first_name,
           o.last_name,
           o.birth_year,
           o.appointed_date,
           date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
           ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
           COUNT(a.id) as allegation_count,
           COUNT(tt.id) as trr_count
        FROM data_officer o
        LEFT JOIN data_officerallegation a on o.id = a.officer_id
        LEFT JOIN trr_trr tt on o.id = tt.officer_id
        WHERE active = 'Yes'
            AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
        GROUP BY o.id
        ORDER BY years_on_force DESC;


-- Officer first allegation
DROP VIEW IF EXISTS cp5_officer_first_allegations;
CREATE VIEW cp5_officer_first_allegations AS
SELECT allegation.id as allegation_id,
           CASE
               WHEN allegation.crid LIKE 'C%' THEN SUBSTRING(crid, 2)::integer
               ELSE allegation.crid::integer
           END as crid,
           oa.id as officerallegation_id,
           officer.id as officer_id,
           officer.appointed_date as appointed_date,
            allegation.incident_date as incident_date,
           category.category as category,
           (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation d on data_officerallegation.allegation_id = d.id
            WHERE officer_id = officer.id
            AND d.incident_date > officer.appointed_date
            AND d.incident_date < (allegation.incident_date + interval '2 year')
            AND disciplined = True
            ) as disciplined,
           (SELECT COUNT(*)
               FROM trr_trr
               WHERE trr_trr.officer_id = officer.id
               AND trr_trr.trr_datetime < (allegation.incident_date + interval '2 year')) as trr_count,
           (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation d on data_officerallegation.allegation_id = d.id
            WHERE officer_id = officer.id
            AND d.incident_date > officer.appointed_date
            AND d.incident_date < (allegation.incident_date + interval '2 year')) as total_allegation_count,
           (CASE WHEN (SELECT civilian_allegation_percentile FROM data_officer WHERE data_officer.id = officer.id) > 90.0 THEN 1
            ELSE 0
            END) as percent_repeater_status,
            (CASE WHEN (
                SELECT
                       COUNT(*)
                FROM data_officerallegation
                JOIN data_allegation on data_officerallegation.allegation_id = data_allegation.id
                JOIN data_allegationcategory on data_officerallegation.allegation_category_id = data_allegationcategory.id
                WHERE data_officerallegation.officer_id = oa.officer_id
                AND data_allegation.incident_date < (officer.appointed_date + interval '10 year')
                AND data_allegationcategory.category NOT IN ('Operation/Personnel Violations',
                       'Lockup Procedures',
                       'Traffic',
                       'Supervisory Responsibilities',
                       'Unknown',
                       'Medical')) >= 10 THEN 1 ELSE 0 END) as repeater_status
    FROM cp5_officer_subset officer
    JOIN data_officerallegation oa ON oa.officer_id = officer.id
    JOIN data_allegation allegation on oa.allegation_id = allegation.id
    JOIN data_allegationcategory category on oa.allegation_category_id = category.id
    WHERE allegation.id IN (
        SELECT d.id
        FROM data_officerallegation
        JOIN data_allegation d on data_officerallegation.allegation_id = d.id
        WHERE d.is_officer_complaint = False
        AND officer_id = officer.id
        AND d.incident_date > (officer.appointed_date)
        AND d.incident_date < (officer.appointed_date + interval '2 year')
        ORDER BY d.incident_date LIMIT 1);


SELECT * from cp5_officer_first_allegations
order by officer_id

SELECT COUNT(*) FROM cp5_officer_first_allegations

SELECT percent_repeater_status, COUNT(*)
from cp5_officer_first_allegations
group by percent_repeater_status

SELECT category, count(*)
from data_allegationcategory
group by category
order by count(*) desc