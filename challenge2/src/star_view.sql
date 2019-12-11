CREATE TEMP VIEW star_officer AS
(
    SELECT b.star, d.id as officer_id, d.first_name, d.last_name, d.middle_initial, d.suffix_name, d.appointed_date
    FROM data_officerbadgenumber b
    INNER JOIN data_officer d on b.officer_id = d.id
--     WHERE b.current = TRUE
);

SELECT COUNT(*) FROM star_officer;

CREATE TEMP VIEW data_officerarrest_missing AS
(
    SELECT * FROM data_officerarrest
    WHERE officer_id IS NULL
    AND not star = ''
);

SELECT count(*) FROM data_officerarrest_missing;
SELECT * FROM star_officer;

CREATE TEMP VIEW matching_stars AS
(
    SELECT oa.id as missing_id, oa.first_name, oa.last_name, so.officer_id
    FROM data_officerarrest_missing oa
    LEFT JOIN star_officer so on oa.star = so.star
    WHERE lower(oa.first_name) = lower(so.first_name)
    AND lower(oa.last_name) = lower(so.last_name)
);

CREATE TABLE new_data_officerarrest AS
(
    SELECT * FROM data_officerarrest
);

UPDATE new_data_officerarrest as doa set officer_id = ms.officer_id
FROM matching_stars ms
WHERE ms.missing_id = doa.id;

SELECT (SELECT count(*) FROM new_data_officerarrest WHERE officer_id IS NOT NULL) as new,
(SELECT COUNT(*) FROM data_officerarrest WHERE officer_id IS NOT NULL) as old,
(SELECT count(*) FROM data_officerarrest) as all;

SELECT count(*)
FROM new_data_officerarrest oa
JOIN data_officer o ON lower(o.first_name) = lower(oa.first_name) AND lower(o.last_name) = lower(oa.last_name)
WHERE officer_id IS NULL;

SELECT first_name, last_name, appointed_date, arrest_year, COUNT(*) as arrest_data_count
FROM new_data_officerarrest
WHERE officer_id IS NULL
GROUP BY first_name, last_name, appointed_date, arrest_year
ORDER BY arrest_data_count desc;


COPY new_data_officerarrest(id, arrest_id)  TO '/Users/blaine/dev/ds/cpdp-wise-lobsters/challenge2/data/new_submission.csv' DELIMITER ',' CSV HEADER

-- update gc_entretien.trace as tr
--   set time_diff = nv.diff
-- from new_values nv
-- where nv.gid = tr.gid;



-- DROP VIEW star_officer;
-- DROP VIEW data_officerarrest_missing;
-- DROP VIEW matching_stars;

-- DROP TABLE  data_officerarrest CASCADE;