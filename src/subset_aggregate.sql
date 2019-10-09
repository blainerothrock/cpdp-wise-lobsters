SELECT
    COUNT(id) as subset_size,
    AVG(date_part('year', CURRENT_DATE) - birth_year) as average_age,
    AVG(CURRENT_DATE::DATE - appointed_date) as average_time_on_force,
    MIN(appointed_date) as earliest_start_date,
    MAX(appointed_date) as last_start_date,
    MIN(birth_year) as earliest_birth_year,
    MAX(birth_year) as last_birth_year
FROM data_officer
WHERE active = 'Yes'
    AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31';