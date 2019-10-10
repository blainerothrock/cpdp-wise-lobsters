CREATE VIEW repeater_allegations AS
    SELECT oa.id as officerallegation_id, oa.allegation_id, subset.id as officer_id
    FROM data_officerallegation oa
    JOIN officer_subset subset ON subset.id = oa.officer_id
    WHERE subset.allegation_count > 10
    ORDER BY officer_id;