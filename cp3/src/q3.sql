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

CREATE VIEW officerarrest_years AS
    SELECT o.id as officer_id, officer_arrest.id as arrest_id, (officer_arrest.arrest_year - date_part('year', o.appointed_date)) as date_diff
    FROM data_officerarrest officer_arrest
    INNER JOIN officer_subset o on officer_arrest.officer_id = o.id

CREATE VIEW officerallegation_years AS
    SELECT o.id as officer_id, o.appointed_date, allegation.incident_date, allegation.id as allegation_id, (date_part('year', allegation.incident_date) - date_part('year', o.appointed_date)) as date_diff
    FROM officer_subset o
    INNER JOIN data_officerallegation officer_allegation ON officer_allegation.officer_id = o.id
    INNER JOIN data_allegation allegation ON allegation.id = officer_allegation.allegation_id;


SELECT date_diff, COUNT(arrest_id)
    FROM officerarrest_years
    WHERE date_diff >= 0
    GROUP BY date_diff;

SELECT date_diff, COUNT(allegation_id)
    FROM officerallegation_years
    WHERE date_diff >= 0
    GROUP BY date_diff
    ORDER BY date_diff ASC;

select doa.first_name, doa.last_name, doa.officer_id, count(doa.arrest_id), os.years_on_force, count(arrest_id)/ os.years_on_force as avg_arrest_over_years from data_officerarrest doa
 join officer_subset os on doa.officer_id = os.id
group by doa.officer_id, doa.first_name, doa.last_name, os.years_on_force order by avg_arrest_over_years desc

DROP VIEW officer_subset;
DROP VIEW officerarrest_years;
DROP VIEW officerallegation_years;

