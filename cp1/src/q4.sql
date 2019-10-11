CREATE TEMP VIEW repeater_allegations AS
    SELECT oa.id as officerallegation_id, oa.allegation_id, o.id as officer_id,
           (SELECT da.incident_date
               FROM data_officerallegation oa
               JOIN data_allegation da on oa.allegation_id = da.id
               WHERE o.id = oa.officer_id
               LIMIT 1
               OFFSET 15
            ) as repeater_start_date
    FROM data_officerallegation oa
    JOIN data_officer o ON o.id = oa.officer_id;

SELECT (
    SELECT COUNT(DISTINCT ofa.allegation_id)
    FROM officer_first_allegation ofa
    JOIN repeater_allegations ra on ofa.allegation_id = ra.allegation_id
    WHERE NOT ra.officer_id = ofa.officer_id
        AND ra.repeater_start_date IS NOT NULL
        AND ra.allegation_id = ofa.allegation_id
        AND ra.repeater_start_date < ofa.start_date
    )::FLOAT / (
        SELECT COUNT(DISTINCT allegation_id)
        FROM officer_first_allegation
    )::FLOAT * 100.0 as percentage;

DROP VIEW repeater_allegations;