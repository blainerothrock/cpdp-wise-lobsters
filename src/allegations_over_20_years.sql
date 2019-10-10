SELECT o.id, o.age_group, o.years_on_force,
       (
           SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date AND o.appointed_date + INTERVAL'1 year'
        ) AS year_zero,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'1 year' AND o.appointed_date + INTERVAL'2 year'
        ) AS year_one,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'2 year' AND o.appointed_date + INTERVAL'3 year'
        ) AS year_two,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'3 year' AND o.appointed_date + INTERVAL'4 year'
        ) AS year_three,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'4 year' AND o.appointed_date + INTERVAL'5 year'
        ) AS year_four,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'5 year' AND o.appointed_date + INTERVAL'6 year'
        ) AS year_five,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'6 year' AND o.appointed_date + INTERVAL'7 year'
        ) AS year_six,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'7 year' AND o.appointed_date + INTERVAL'8 year'
        ) AS year_seven,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'8 year' AND o.appointed_date + INTERVAL'9 year'
        ) AS year_eight,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'9 year' AND o.appointed_date + INTERVAL'10 year'
        ) AS year_nine,
        (
           SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'10 year' AND o.appointed_date + INTERVAL'11 year'
        ) AS year_ten,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'11 year' AND o.appointed_date + INTERVAL'12 year'
        ) AS year_eleven,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'12 year' AND o.appointed_date + INTERVAL'13 year'
        ) AS year_twelve,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'13 year' AND o.appointed_date + INTERVAL'14 year'
        ) AS year_thirteen,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'14 year' AND o.appointed_date + INTERVAL'15 year'
        ) AS year_fourteen,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'15 year' AND o.appointed_date + INTERVAL'16 year'
        ) AS year_fifteen,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'16 year' AND o.appointed_date + INTERVAL'17 year'
        ) AS year_sixteen,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'17 year' AND o.appointed_date + INTERVAL'18 year'
        ) AS year_seventeen,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'18 year' AND o.appointed_date + INTERVAL'19 year'
        ) AS eighteen,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'19 year' AND o.appointed_date + INTERVAL'20 year'
        ) AS year_nineteen,
        (
            SELECT COUNT(oa.id)
            FROM data_officerallegation oa
            JOIN data_allegation da on oa.allegation_id = da.id
            WHERE officer_id = o.id AND da.incident_date BETWEEN o.appointed_date + INTERVAL'20 year' AND o.appointed_date + INTERVAL'21 year'
        ) AS year_twenty
FROM officer_subset o
ORDER BY o.allegation_count DESC;