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
          (
       SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date AND o.appointed_date + INTERVAL'1 year'
    ) AS year_zero_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'1 year' AND o.appointed_date + INTERVAL'2 year'
    ) AS year_one_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'2 year' AND o.appointed_date + INTERVAL'3 year'
    ) AS year_two_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'3 year' AND o.appointed_date + INTERVAL'4 year'
    ) AS year_three_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'4 year' AND o.appointed_date + INTERVAL'5 year'
    ) AS year_four_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'5 year' AND o.appointed_date + INTERVAL'6 year'
    ) AS year_five_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'6 year' AND o.appointed_date + INTERVAL'7 year'
    ) AS year_six_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'7 year' AND o.appointed_date + INTERVAL'8 year'
    ) AS year_seven_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'8 year' AND o.appointed_date + INTERVAL'9 year'
    ) AS year_eight_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'9 year' AND o.appointed_date + INTERVAL'10 year'
    ) AS year_nine_allegation_count,
    (
       SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'10 year' AND o.appointed_date + INTERVAL'11 year'
    ) AS year_ten_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'11 year' AND o.appointed_date + INTERVAL'12 year'
    ) AS year_eleven_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'12 year' AND o.appointed_date + INTERVAL'13 year'
    ) AS year_twelve_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'13 year' AND o.appointed_date + INTERVAL'14 year'
    ) AS year_thirteen_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'14 year' AND o.appointed_date + INTERVAL'15 year'
    ) AS year_fourteen_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'15 year' AND o.appointed_date + INTERVAL'16 year'
    ) AS year_fifteen_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'16 year' AND o.appointed_date + INTERVAL'17 year'
    ) AS year_sixteen_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'17 year' AND o.appointed_date + INTERVAL'18 year'
    ) AS year_seventeen_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'18 year' AND o.appointed_date + INTERVAL'19 year'
    ) AS year_eighteen_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'19 year' AND o.appointed_date + INTERVAL'20 year'
    ) AS year_nineteen_allegation_count,
    (
        SELECT COUNT(oa.id)
        FROM data_officerallegation oa
        JOIN data_allegation da on oa.allegation_id = da.id
        WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'20 year' AND o.appointed_date + INTERVAL'21 year'
    ) AS year_twenty_allegation_count
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC;

SELECT
    COUNT(id) as subset_size,
    AVG(estimated_age) as average_age,
    AVG(years_on_force) as average_time_on_force,
    MIN(appointed_date) as earliest_start_date,
    MAX(appointed_date) as last_start_date,
    MIN(birth_year) as earliest_birth_year,
    MAX(birth_year) as last_birth_year,
    AVG(allegation_count) as avg_total,
    AVG(year_zero_allegation_count) as year_zero,
    AVG(year_one_allegation_count) as year_one,
    AVG(year_two_allegation_count)  as year_two,
    AVG(year_three_allegation_count) as year_three,
    AVG(year_four_allegation_count) as year_four,
    AVG(year_five_allegation_count) as year_five,
    AVG(year_six_allegation_count)  as year_six,
    AVG(year_seven_allegation_count) as year_seven,
    AVG(year_eight_allegation_count) as year_eight,
    AVG(year_nine_allegation_count) as year_nine,
    AVG(year_ten_allegation_count) as year_ten
FROM officer_subset;