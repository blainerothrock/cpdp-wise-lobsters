DROP TABLE IF EXISTS allegation_keys;
CREATE TABLE allegation_keys AS (SELECT id, CASE WHEN crid LIKE 'C%' THEN SUBSTRING(crid, 2)::integer
   ELSE crid::integer END crid, summary
   FROM data_allegation);

SELECT category.category, ddtm.topic1_id, count(*)
FROM data_officerallegation officerallegation
JOIN data_allegation allegation on officerallegation.allegation_id = allegation.id
JOIN data_allegationcategory category on officerallegation.allegation_category_id = category.id
JOIN allegation_keys keys ON keys.id = allegation.id
INNER JOIN data_document_tags AS doc_tag on keys.crid = doc_tag.allegation_id
JOIN data_document_topic_map ddtm on doc_tag.id = ddtm.document_id
-- WHERE ddtm.topic1_prob > 0.75
GROUP BY category.category, ddtm.topic1_id
HAVING count(*) > 10
ORDER BY count(*) desc