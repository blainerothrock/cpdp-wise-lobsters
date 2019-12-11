-- Officer Subset
DROP VIEW IF EXISTS cp5_officer_subset cascade;
CREATE VIEW cp5_officer_subset AS
    SELECT
           o.id,
           o.first_name,
           o.last_name,
           o.birth_year,
           o.appointed_date,
           date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
           ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
           COUNT(a.id) as allegation_count
        FROM data_officer o
        LEFT JOIN data_officerallegation a on o.id = a.officer_id
        WHERE active = 'Yes'
            AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
        GROUP BY o.id
        ORDER BY years_on_force DESC;

-- Officer first allegation
DROP VIEW IF EXISTS cp5_officer_first_uof_allegation;
CREATE VIEW cp5_officer_first_uof_allegation AS
    SELECT da.id as allegation_id,
           CASE
               WHEN da.crid LIKE 'C%' THEN SUBSTRING(crid, 2)::integer
               ELSE da.crid::integer
           END as crid,
           oa.id as officerallegation_id,
           o.id as officer_id,
           dc.category as category,
           da.incident_date as incident_date
    FROM cp5_officer_subset o
    JOIN data_officerallegation oa ON oa.officer_id = o.id
    JOIN data_allegation da on oa.allegation_id = da.id
    JOIN data_allegationcategory dc on oa.allegation_category_id = dc.id
    WHERE da.id = (
        SELECT d.id
        FROM data_officerallegation
        JOIN data_allegation d on data_officerallegation.allegation_id = d.id
        WHERE officer_id = o.id
        AND lower(dc.category) IN (
            lower('Use Of Force'),
            lower('illegal search'),
            lower('False Arrest'),
            lower('Criminal Misconduct'),
            lower('Verbal Abuse'),
            lower('Domestic')
        )
        ORDER BY d.incident_date LIMIT 1);

SELECT * FROM cp5_officer_first_uof_allegation;


-- allegation keys
DROP TABLE IF EXISTS allegation_keys;
CREATE TABLE allegation_keys AS (SELECT id, CASE WHEN crid LIKE 'C%' THEN SUBSTRING(crid, 2)::integer
   ELSE crid::integer END crid, summary
   FROM data_allegation);

SELECT data_document_tags.allegation_id, summary
FROM data_document_tags, allegation_keys
WHERE allegation_id = crid AND summary <> '';


SELECT
       first_allegation.allegation_id,
       first_allegation.officer_id,
       doc_tag.id,
       first_allegation.category,
       ddtm.topic1_id,
       ddtm.topic2_id,
       ddtm.topic3_id
FROM cp5_officer_first_uof_allegation AS first_allegation
LEFT JOIN data_document_tags AS doc_tag on first_allegation.crid = doc_tag.allegation_id
LEFT JOIN data_document_topic_map ddtm on doc_tag.id = ddtm.document_id
JOIN data_document_topics topic on topic.id = ddtm.topic1_id
WHERE doc_tag.id IS NOT NULL;

SELECT
    data_officerallegation.id as officeallegation_id,
    data_allegation.id as allegation_id,
    data_officerallegation.officer_id,
    keys.crid,
    keys.id,
    doc_tag.id,
    CASE
        WHEN doc_tag.allegation_id
FROM data_officerallegation
LEFT JOIN data_allegation ON data_allegation.id = data_officerallegation.allegation_id
LEFT JOIN allegation_keys keys ON keys.id = data_allegation.id
LEFT JOIN data_document_tags AS doc_tag on keys.crid = doc_tag.allegation_id
WHERE officer_id IN (SELECT id FROM cp5_officer_subset);


 SELECT category.category, ddtm.topic1_id,  date_part('year', allegation.incident_date) as year, count(*)
 FROM data_officerallegation officerallegation
 JOIN data_allegation allegation on officerallegation.allegation_id = allegation.id
 JOIN data_allegationcategory category on officerallegation.allegation_category_id = category.id
 JOIN allegation_keys keys ON keys.id = allegation.id
 INNER JOIN data_document_tags AS doc_tag on keys.crid = doc_tag.allegation_id
 JOIN data_document_topic_map ddtm on doc_tag.id = ddtm.document_id
 WHERE lower(category.category) = 'use of force'
--  AND allegation.incident_date::DATE > '2003-01-01' AND allegation.incident_date::DATE < '2003-12-31'
 GROUP BY category.category, ddtm.topic1_id, year
 HAVING count(*) > 10
 ORDER BY count(*) desc

