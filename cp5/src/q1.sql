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
           COUNT(a.id) as allegation_count
        FROM data_officer o
        LEFT JOIN data_officerallegation a on o.id = a.officer_id
        WHERE active = 'Yes'
            AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
        GROUP BY o.id
        ORDER BY years_on_force DESC;

DROP VIEW IF EXISTS cp5_officer_allegation_type
CREATE VIEW cp5_officer_allegation_type AS
    SELECT
        category.category,
        (allegation.incident_date::DATE - officer.appointed_date::DATE) / 365 as years_on_force,
        (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation da on data_officerallegation.allegation_id = da.id
            WHERE data_officerallegation.allegation_category_id = category.id
            AND officer_id = officer.id
            AND da.incident_date < allegation.incident_date) as number_since_same_type,
        (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation da on data_officerallegation.allegation_id = da.id
            WHERE officer_id = officer.id
            AND da.incident_date < allegation.incident_date) as number_since_total,
        (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation da on data_officerallegation.allegation_id = da.id
            WHERE data_officerallegation.allegation_category_id = category.id
            AND officer_id = officer.id
            AND da.incident_date > allegation.incident_date) as number_same_type_after
    FROM data_officerallegation officerallegation
    JOIN data_allegationcategory category on officerallegation.allegation_category_id = category.id
    INNER JOIN cp5_officer_subset officer on officerallegation.officer_id = officer.id
    JOIN data_allegation allegation on officerallegation.allegation_id = allegation.id
    WHERE allegation.incident_date > officer.appointed_date

COPY (
    SELECT
        category.category,
        (allegation.incident_date::DATE - officer.appointed_date::DATE) / 365 as years_on_force,
        (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation da on data_officerallegation.allegation_id = da.id
            WHERE data_officerallegation.allegation_category_id = category.id
            AND officer_id = officer.id
            AND da.incident_date < allegation.incident_date) as number_since_same_type,
        (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation da on data_officerallegation.allegation_id = da.id
            WHERE officer_id = officer.id
            AND da.incident_date < allegation.incident_date) as number_since_total,
        (SELECT COUNT(*)
            FROM data_officerallegation
            JOIN data_allegation da on data_officerallegation.allegation_id = da.id
            WHERE data_officerallegation.allegation_category_id = category.id
            AND officer_id = officer.id
            AND da.incident_date > allegation.incident_date) as number_same_type_after
    FROM data_officerallegation officerallegation
    JOIN data_allegationcategory category on officerallegation.allegation_category_id = category.id
    INNER JOIN cp5_officer_subset officer on officerallegation.officer_id = officer.id
    JOIN data_allegation allegation on officerallegation.allegation_id = allegation.id
    WHERE allegation.incident_date > officer.appointed_date
    AND allegation.is_officer_complaint = FALSE
) TO '/Users/blaine/dev/ds/cpdp-wise-lobsters/cp5/src/data/q1_officer_allegation_type.csv' DELIMITER ',' CSV HEADER;