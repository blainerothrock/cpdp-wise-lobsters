-- award types
SELECT DISTINCT award_type
FROM data_award;

-- allegation categories
SELECT DISTINCT category
FROM data_allegationcategory
WHERE category NOT IN ('Operation/Personnel Violations',
                       'Lockup Procedures',
                       'Traffic',
                       'Supervisory Responsibilities',
                       'Unknown',
                       'Medical');

-- relevant awards
WITH officer_subset AS (
    SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
          date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
          ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
          COUNT(a.id) as allegation_count
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC
) SELECT
       award.id as award_id,
       award.award_type,
       award.start_date as award_date,
       subset.id as officer_id
FROM data_award award
INNER JOIN officer_subset subset ON subset.id = award.officer_id
WHERE award.current_status = 'Final';

-- relevant allegations
WITH officer_subset AS (
    SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
          date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
          ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
          COUNT(a.id) as allegation_count
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC
) SELECT
--        officer_allegation.id as officer_allegation_id,
--        allegation.id as allegation_id,
--        subset.id as officer_id,
--        allegation.incident_date as incident_date,
--        category.category as category_type,
--        category.allegation_name as allegation_name
        COUNT(*)
FROM data_officerallegation officer_allegation
INNER JOIN data_allegation allegation on officer_allegation.allegation_id = allegation.id
INNER JOIN data_allegationcategory category on officer_allegation.allegation_category_id = category.id
INNER JOIN officer_subset subset ON subset.id = officer_allegation.officer_id
WHERE
      allegation.incident_date >= subset.appointed_date
      AND category.category NOT IN ('Operation/Personnel Violations',
                       'Lockup Procedures',
                       'Traffic',
                       'Supervisory Responsibilities',
                       'Unknown',
                       'Medical');

-- relevant promotions
WITH officer_subset AS (
    SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
          date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
          ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
          COUNT(a.id) as allegation_count
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC
) SELECT
       subset.id as officer_id,
       salary.spp_date as alt_promotion_date,
       salary.year as promotion_year,
       salary.rank
FROM data_salary salary
INNER JOIN officer_subset subset ON subset.id = salary.officer_id;


WITH officer_subset AS (SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
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
    ORDER BY years_on_force DESC)
SELECT award_type, count(*)
FROM data_award
INNER JOIN officer_subset subset ON subset.id = data_award.officer_id
GROUP BY award_type
ORDER BY count(*) DESC