drop table if exists data_document_tags cascade;
create table data_document_tags
(
    id                                       serial not null
        constraint data_document_tags_pk
            primary key,
    allegation_id                            integer,
    document_text                            varchar,
    url                                      varchar(255),
    text_bad                                 varchar(255),
    incident_date                            varchar(255),
    allegation_name                          varchar(255),
    title                                    varchar(255),
    allegation_category                      varchar(255),
    organization                             varchar(3),
    nudity_penetration                       varchar(255),
    sexual_harassment_remarks                varchar(255),
    sexual_humiliation_extortion_or_sex_work varchar(255),
    tasers                                   varchar(255),
    trespass                                 varchar(255),
    racial_slurs                             varchar(255),
    planting_drugs_guns                      varchar(255),
    neglect_of_duty                          varchar(255),
    refuse_medical_assistance                varchar(255),
    irrational_aggressive_unstable           varchar(255),
    searching_arresting_minors               varchar(255)
);
COPY data_document_tags(allegation_id, title, document_text, url, text_bad, incident_date, allegation_name, allegation_category, organization, nudity_penetration, sexual_harassment_remarks, sexual_humiliation_extortion_or_sex_work, tasers, trespass, racial_slurs, planting_drugs_guns, neglect_of_duty, refuse_medical_assistance, irrational_aggressive_unstable, searching_arresting_minors)
FROM '/Users/blaine/dev/ds/cpdp-wise-lobsters/cp5/src/document_tags.csv' DELIMITER ',' CSV HEADER;
UPDATE data_document_tags SET incident_date = NULL WHERE incident_date = '';
ALTER TABLE data_document_tags ALTER COLUMN incident_date TYPE DATE USING incident_date::date;

drop table if exists data_document_topics cascade;
create table data_document_topics
(
	id int
		constraint data_document_topics_pk
			primary key,
	term1 varchar,
	term2 varchar,
	term3 varchar,
	term4 varchar,
	term5 varchar,
	term6 varchar,
	term7 varchar,
	term8 varchar,
	term9 varchar,
	term10 varchar
);
COPY data_document_topics(id, term1, term2, term3, term4, term5, term6, term7, term8, term9, term10)
FROM '/Users/blaine/dev/ds/cpdp-wise-lobsters/cp5/src/document_topics.csv' DELIMITER ',' CSV HEADER;

drop table if exists data_document_topic_map;
create table data_document_topic_map
(
	id serial
		constraint data_document_topic_map_pk
			primary key,
	document_id int not null references data_document_tags(id),
	topic1_id int references data_document_topics(id),
	topic1_prob double precision,
	topic2_id int references data_document_topics(id),
	topic2_prob double precision,
	topic3_id int references data_document_topics(id),
	topic3_prob double precision
);
COPY data_document_topic_map(document_id, topic1_id, topic1_prob, topic2_id, topic2_prob, topic3_id, topic3_prob)
FROM '/Users/blaine/dev/ds/cpdp-wise-lobsters/cp5/src/document_topics_map.csv' DELIMITER ',' CSV HEADER;
