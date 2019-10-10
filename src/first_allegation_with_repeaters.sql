SELECT (
    SELECT COUNT(ofa.officer_id)
    FROM officer_first_allegation ofa
    JOIN repeater_allegations ra on ofa.allegation_id = ra.allegation_id
    WHERE NOT ra.officer_id = ofa.officer_id
        AND ra.allegation_id = ofa.allegation_id
    )::FLOAT / (
        SELECT COUNT(DISTINCT allegation_id)
        FROM officer_first_allegation
    )::FLOAT * 100.0 as percentage