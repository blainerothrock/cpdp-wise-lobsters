-- OFFICER SUBSET
CREATE TEMP VIEW officer_subset AS
    SELECT o.id, o.first_name, o.last_name, o.birth_year, o.appointed_date,
          date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
          ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
          COUNT(a.id) as allegation_count
    FROM data_officer o
    LEFT JOIN data_officerallegation a on o.id = a.officer_id
    WHERE active = 'Yes'
        AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
    GROUP BY o.id
    ORDER BY years_on_force DESC;


-- CITY SETTLEMENTS
CREATE TEMP VIEW officer_subsetsettlementpayment AS
    SELECT o.id as officer_id, payment.id as payment_id
        FROM officer_subset o
    INNER JOIN cop_officer_map cop ON cop.officer_id = o.id
    INNER JOIN cops_casecop case_cop ON case_cop.cop_id = cop.cop_id
    INNER JOIN cases_case case_case ON case_case.id = case_cop.case_id
    INNER JOIN cases_payment payment ON payment.case_id = case_case.id;

-- CIVIL CASES
CREATE TEMP VIEW officer_subsetcivilcase AS
    SELECT o.id as officer_id, civil_case.id as civil_case_id
        FROM officer_subset o
    INNER JOIN data_officerallegation officerallegation ON officerallegation.officer_id = o.id
    INNER JOIN case_map ON case_map.allegation_id = officerallegation.allegation_id
    INNER JOIN cases_ipracase civil_case ON civil_case.id = case_map.case_id;


-- officers settlements
SELECT officer_subset.id,
       officer_subset.first_name,
       officer_subset.last_name,
       officer_subset.birth_year,
       officer_subset.appointed_date,
       officer_subset.years_on_force,
       officer_subset.allegation_count,
       COUNT(payment.id) as payment_count,
       COALESCE(SUM(payment.payment),0) as payment_total
FROM officer_subset
LEFT JOIN officer_subsetsettlementpayment as payment_map ON payment_map.officer_id = officer_subset.id
LEFT JOIN cases_payment payment ON payment.id = payment_map.payment_id
GROUP by officer_subset.id,
         officer_subset.first_name,
         officer_subset.last_name,
         officer_subset.birth_year,
         officer_subset.appointed_date,
         officer_subset.years_on_force,
         officer_subset.allegation_count
ORDER BY payment_total DESC;

-- average number of allegations for officers with at least one settlement
SELECT years_on_force, AVG(allegation_count) as avg_allegation_count, AVG(payment_count) as avg_settlement_count, AVG(payment_total) as average_settlement_amount
FROM (
    SELECT officer_subset.id,
           officer_subset.years_on_force as years_on_force,
        officer_subset.allegation_count as allegation_count,
       COUNT(payment.id) as payment_count,
       COALESCE(SUM(payment.payment),0) as payment_total
    FROM officer_subset
    LEFT JOIN officer_subsetsettlementpayment as payment_map ON payment_map.officer_id = officer_subset.id
    LEFT JOIN cases_payment payment ON payment.id = payment_map.payment_id
    GROUP by officer_subset.id, officer_subset.years_on_force, officer_subset.allegation_count
    HAVING COUNT(payment.id) > 0 AND AVG(allegation_count) > 0
    ORDER BY payment_total DESC
) as settlement_aggregate
GROUP BY years_on_force;

-- average number of allegations for officer with no settlements
SELECT years_on_force, AVG(allegation_count) as avg_allegation_count, AVG(payment_count) as avg_settlement_count, AVG(payment_total) as average_settlement_amount
FROM (
    SELECT officer_subset.id,
           officer_subset.years_on_force as years_on_force,
        officer_subset.allegation_count as allegation_count,
       COUNT(payment.id) as payment_count,
       COALESCE(SUM(payment.payment),0) as payment_total
    FROM officer_subset
    LEFT JOIN officer_subsetsettlementpayment as payment_map ON payment_map.officer_id = officer_subset.id
    LEFT JOIN cases_payment payment ON payment.id = payment_map.payment_id
    GROUP by officer_subset.id, officer_subset.years_on_force, officer_subset.allegation_count
    HAVING COUNT(payment.id) = 0
    ORDER BY payment_total DESC
) as settlement_aggregate
GROUP BY years_on_force;

-- average number of allegations for officer with at least 1 civil suit
SELECT years_on_force, AVG(allegation_count) as avg_allegation_count, AVG(case_count) as avg_civil_case_count
FROM (
    SELECT officer_subset.id,
           officer_subset.years_on_force as years_on_force,
           officer_subset.allegation_count as allegation_count,
           COUNT(civil_case.civil_case_id) as case_count
    FROM officer_subset
    LEFT JOIN officer_subsetcivilcase civil_case ON civil_case.officer_id = officer_subset.id
    GROUP by officer_subset.id, officer_subset.years_on_force, officer_subset.allegation_count
    HAVING COUNT(civil_case.civil_case_id) > 0
) as settlement_aggregate
GROUP BY years_on_force;


-- average number of allegations for officer with no civil suit
SELECT years_on_force, AVG(allegation_count) as avg_allegation_count, AVG(case_count) as avg_civil_case_count
FROM (
    SELECT officer_subset.id,
           officer_subset.years_on_force as years_on_force,
           officer_subset.allegation_count as allegation_count,
           COUNT(civil_case.civil_case_id) as case_count
    FROM officer_subset
    LEFT JOIN officer_subsetcivilcase civil_case ON civil_case.officer_id = officer_subset.id
    GROUP by officer_subset.id, officer_subset.years_on_force, officer_subset.allegation_count
    HAVING COUNT(civil_case.civil_case_id) = 0
) as settlement_aggregate
GROUP BY years_on_force;


DROP VIEW officer_subset;
DROP VIEW officer_subsetsettlementpayment;
DROP VIEW officer_subsetcivilcase;