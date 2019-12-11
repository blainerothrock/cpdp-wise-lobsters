DROP TABLE IF EXISTS officer_first_allegation;
CREATE TABLE officer_first_allegation as
    SELECT o.id as officer_id, da.id as allegation_id, dc.category as category, dc.id as category_id, dc.allegation_name as name, oa.start_date, da.incident_date
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
    AND dc.category NOT IN (
       'Operation/Personnel Violations',
       'Lockup Procedures',
       'Traffic',
       'Supervisory Responsibilities',
       'Unknown',
       'Medical'
    )
    ORDER BY da.incident_date;

DROP TABLE IF EXISTS officer_allegations_years_on_force;
CREATE TABLE officer_allegations_years_on_force AS
    SELECT
        officerallegation.id,
        officerallegation.allegation_id,
        officerallegation.allegation_category_id,
        officerallegation.officer_id,
        category.category,
        ((allegation.incident_date::DATE - officer.appointed_date) / 365) as year_on_force,
        ((allegation.incident_date::DATE - firstallegation.incident_date::DATE) / 365) as year_since_first
    FROM data_officerallegation officerallegation
    JOIN data_officer officer on officerallegation.officer_id = officer.id
    JOIN data_allegation allegation on officerallegation.allegation_id = allegation.id
    JOIN data_allegationcategory category on officerallegation.allegation_category_id = category.id
    INNER JOIN officer_first_allegation firstallegation on firstallegation.officer_id = officerallegation.officer_id


SELECT year_on_force, COUNT(id)::DECIMAL / COUNT(DISTINCT officer_id)::DECIMAL AS avg
FROM officer_allegations_years_on_force
WHERE year_on_force >= 0 AND year_on_force < 10
GROUP BY year_on_force
ORDER BY year_on_force ASC;

SELECT year_since_first, COUNT(id)::DECIMAL / COUNT(DISTINCT officer_id)::DECIMAL AS avg
FROM officer_allegations_years_on_force
WHERE year_since_first >= 0 AND year_since_first < 10
GROUP BY year_since_first
ORDER BY year_since_first ASC;


DROP VIEW IF EXISTS officer_subset;
CREATE VIEW officer_subset AS
    SELECT
           o.id,
           o.first_name,
           o.last_name,
           o.birth_year,
           o.appointed_date,
           date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
           ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
           COUNT(a.id) as allegation_count
        FROM data_officer o
        LEFT JOIN data_officerallegation a on o.id = a.officer_id
        WHERE active = 'Yes'
            AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
        GROUP BY o.id
        ORDER BY years_on_force DESC;


DROP VIEW IF EXISTS officer_first_allegation_percent;
CREATE VIEW officer_first_allegation_percent AS
    SELECT
            officer.id,
            first_allegation.category,
            ((COUNT(*) FILTER (WHERE first_allegation.category = allegation_category.category)::DECIMAL /
            COUNT(*) FILTER (WHERE not first_allegation.category = allegation_category.category)::DECIMAL) * 100) percent_first_allegation
    FROM officer_subset officer
    JOIN officer_first_allegation first_allegation ON first_allegation.officer_id = officer.id
    JOIN data_officerallegation officer_allegation on first_allegation.officer_id = officer_allegation.officer_id
    JOIN data_allegationcategory allegation_category on officer_allegation.allegation_category_id = allegation_category.id
    WHERE officer.allegation_count > 10 AND allegation_category.category NOT IN (
       'Operation/Personnel Violations',
       'Lockup Procedures',
       'Traffic',
       'Supervisory Responsibilities',
       'Unknown',
       'Medical'
    )
    GROUP BY officer.id, first_allegation.category

SELECT AVG(percent_first_allegation) FROM officer_first_allegation_percent