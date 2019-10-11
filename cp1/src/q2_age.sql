CREATE TEMP VIEW officer_subset AS
    SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
          date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
          ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
          CASE
            WHEN date_part('year', CURRENT_DATE) - o.birth_year < 24 THEN '>24'
            WHEN date_part('year', CURRENT_DATE) - o.birth_year BETWEEN 25 AND 34 THEN '25 - 34'
            WHEN date_part('year', CURRENT_DATE) - o.birth_year BETWEEN 35 AND 44 THEN '35 - 44'
            WHEN date_part('year', CURRENT_DATE) - o.birth_year BETWEEN 45 AND 54 THEN '45 - 54'
            WHEN date_part('year', CURRENT_DATE) - o.birth_year BETWEEN 55 AND 65 THEN '55 - 65'
            WHEN date_part('year', CURRENT_DATE) - o.birth_year > 65 THEN '>65'
          END as age_group,
          COUNT(a.id) as allegation_count,
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC;

SELECT age_group, AVG(allegation_count)
FROM officer_subset
GROUP BY age_group
ORDER BY age_group;

DROP VIEW officer_subset;