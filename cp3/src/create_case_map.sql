CREATE TABLE case_map(
    case_id INTEGER REFERENCES cases_ipracase(id),
    allegation_id INTEGER REFERENCES data_allegation(id));

INSERT into case_map(case_id, allegation_id)
SELECT c.id as case_id, da.id as allegation_id
FROM cases_ipracase c
INNER JOIN data_allegation da on c.cr_no::varchar = da.crid;


drop table case_map;