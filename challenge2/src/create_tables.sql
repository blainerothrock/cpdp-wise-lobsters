CREATE TABLE data_arrest (id integer PRIMARY KEY,
                          arrest_year integer,
                          arrest_id integer,
                          charge_code integer,
                          arrest_event character varying,
                          first_name character varying,
                          middle_initial character varying,
                          last_name text,
                          age integer,
                          sex character varying,
                          race character varying,
                          cb_number integer,
                          fbi_code character varying,
                          hour_ integer,
                          street_number character varying,
                          direction character varying,
                          street_name character varying,
                          beat integer,
                         district character varying,
                         area integer,
                         arrest_charge_id integer,
                         statute character varying,
                         statute_description character varying,
                         release_date date,
                         bond_amount double precision,
                         bond_type character varying,
                         bond_date date,
                         photographed_date date,
                         arrest_date date );

CREATE TABLE data_officerarrest (
    id INTEGER PRIMARY KEY,
    arrest_year integer,
    first_name character varying,
    middle_initial character varying,
    last_name character varying,
    suffix_name character varying,
    officer_role character varying,
    star character varying,
    cb_number integer,
    appointed_date date,
    arrest_date date,
    arrest_id integer REFERENCES data_arrest(id),
    officer_id integer REFERENCES data_officer(id));