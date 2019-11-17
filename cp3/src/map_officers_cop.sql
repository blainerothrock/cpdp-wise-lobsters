CREATE TABLE cop_officer_map(
    cop_id INTEGER REFERENCES cops_cop(id),
    officer_id INTEGER REFERENCES data_officer(id)
);

INSERT INTO cop_officer_map(cop_id, officer_id)
SELECT c.id AS cop_id, o.id AS officer_id
FROM data_officer o
INNER JOIN cops_cop c
    ON lower(c.first_name) = lower(o.first_name)
           AND lower(c.last_name) = lower(o.last_name)
           AND c.appointed_date = o.appointed_date
           AND c.dob_year = o.birth_year;

SELECT
       (SELECT count(*) from cops_cop) as cop_count,
       (SELECT count(*) from cop_officer_map) as cop_map_count,
       (SELECT count(*) from data_officer) as officer_count;
