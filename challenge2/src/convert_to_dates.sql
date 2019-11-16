UPDATE data_arrest SET bond_date=CONCAT_WS('-', SUBSTR(bond_date, 7, 4), SUBSTR(bond_date, 1, 2), SUBSTR(bond_date, 4, 2));
ALTER TABLE data_arrest ALTER COLUMN bond_date SET DEFAULT NULL;
UPDATE data_arrest SET bond_date = NULL WHERE bond_date = '--';
ALTER TABLE data_arrest ALTER COLUMN bond_date TYPE DATE USING bond_date::date;

UPDATE data_arrest SET photographed_date=CONCAT_WS('-', SUBSTR(photographed_date, 7, 4), SUBSTR(photographed_date, 1, 2), SUBSTR(photographed_date, 4, 2));
ALTER TABLE data_arrest ALTER COLUMN photographed_date SET DEFAULT NULL;
UPDATE data_arrest SET photographed_date = NULL WHERE photographed_date = '--';
ALTER TABLE data_arrest ALTER COLUMN photographed_date TYPE DATE USING photographed_date::date;

UPDATE data_arrest SET arrest_date=CONCAT_WS('-', SUBSTR(arrest_date, 7, 4), SUBSTR(arrest_date, 1, 2), SUBSTR(arrest_date, 4, 2));
ALTER TABLE data_arrest ALTER COLUMN arrest_date SET DEFAULT NULL;
UPDATE data_arrest SET arrest_date = NULL WHERE arrest_date = '--';
ALTER TABLE data_arrest ALTER COLUMN arrest_date TYPE DATE using arrest_date::date;

-- data_officerarrest

UPDATE data_officerarrest SET appointed_date=CONCAT_WS('-', SUBSTR(appointed_date, 7, 4), SUBSTR(appointed_date, 1, 2), SUBSTR(appointed_date, 4, 2));
ALTER TABLE data_officerarrest ALTER COLUMN appointed_date SET DEFAULT NULL;
UPDATE data_officerarrest SET appointed_date = NULL WHERE appointed_date = '--';
ALTER TABLE data_officerarrest ALTER COLUMN appointed_date TYPE DATE using appointed_date::date;

UPDATE data_officerarrest SET arrest_date=CONCAT_WS('-', SUBSTR(arrest_date, 7, 4), SUBSTR(arrest_date, 1, 2), SUBSTR(arrest_date, 4, 2));
ALTER TABLE data_officerarrest ALTER COLUMN arrest_date SET DEFAULT NULL;
UPDATE data_officerarrest SET arrest_date = NULL WHERE arrest_date = '--';
ALTER TABLE data_officerarrest ALTER COLUMN arrest_date TYPE DATE using arrest_date::date;

ALTER TABLE data_officerarrest ALTER COLUMN star SET DEFAULT NULL;