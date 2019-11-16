\set ECHO all

-- this script depends on successfully loading data_officerarrest
\set matches_file '''/Users/blaine/dev/ds/cpdp-wise-lobsters/challenge2/data/_data_officerarrests_challengeII.csv'''


DROP TABLE IF EXISTS arrest_officer_matches;
DROP TABLE IF EXISTS arrest_officer_matches_staging;

CREATE TEMP TABLE arrest_officer_matches_staging (
       officerarrest_id varchar,
       officer_id varchar);

COPY arrest_officer_matches_staging FROM :matches_file
  DELIMITER ',' CSV HEADER;

-- CREATE TABLE arrest_officer_matches (
--     officerarrest_id INTEGER REFERENCES data_arrest(id),
--     officer_id INTEGER REFERENCES data_officer(id));
 



SELECT officerarrest_id::integer officerarrest_id , officer_id::integer officer_id
INTO arrest_officer_matches
FROM arrest_officer_matches_staging;

ALTER TABLE arrest_officer_matches ADD CONSTRAINT aoid_fkey FOREIGN KEY(officerarrest_id) REFERENCES data_officerarrest(id);
ALTER TABLE arrest_officer_matches ADD CONSTRAINT oid_fkey FOREIGN KEY(officer_id) REFERENCES data_officer(id);
