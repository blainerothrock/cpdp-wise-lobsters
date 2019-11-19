-- step 1 : Creating view of subset of officers appointed between 2000 and 2007 and extracting years.

create view officer_subset as select first_name, middle_initial, last_name, cb_number,arrest_year,
appointed_date,EXTRACT(year FROM appointed_date) as appointed_year, arrest_date, arrest_id, doa.id
as allegation_id , doa.officer_id , disciplined from data_officerarrest doa
left join data_officerallegation doal on doal.allegation_id = doa.id and EXTRACT(year FROM appointed_date)
between 2000 and 2007 order by doa.officer_id limit 200000;

-- step 2 : Counting the number of allegations for officers for every arresting year and creating another view accordingly.

create view arrested_officer_with_allegation_count as select officer_id ,
arrest_year, count(allegation_id) as no_of_allegation , appointed_year
from officer_subset group by officer_id , arrest_year , appointed_year
order by officer_id , arrest_year ;

-- step 3 : counted the number of allegations for first three arresting years of officers as early allegation count. We created another view accordingly.

create view arrestedOfficer_with_earlyallegation_count as select officer_id ,
arrest_year, no_of_allegation from arrested_officer_with_allegation_count where
arrest_year between appointed_year and appointed_year+3  order by officer_id , arrest_year;

-- step 4
-- On next step, we figure out the maximum count value of officer for early allegation count which will provide us maximum value amoung the early allegation count.

create view max_value_of_early_allgetion_officer as SELECT max(no_of_allegation)
AS max_count_allegation, officer_id FROM arrestedOfficer_with_earlyallegation_count
GROUP BY officer_id;

-- step 5
-- on next step, We find out average allegation count of each officer through out career here through-out career means considering all arrest years come across during a officer
--career for finding average for allegation count for officer throught out career.

create view avg_officer_allegation_throughout_career as select officer_id,
avg(no_of_allegation) as average_allegation_count from arrested_officer_with_allegation_count
group by officer_id order by officer_id;

-- step 6
--on next step, We find out the officers having higher number of allegation than the early number of allegation.

create view officers_having_higher_early_allegations as
select mva.officer_id , mva.max_count_allegation from max_value_of_early_allgetion_officer mva
inner join avg_officer_allegation_throughout_career aoc on mva.officer_id = aoc.officer_id
where mva.max_count_allegation > aoc.average_allegation_count;

-- step 7
-- on next step, we find out officers having higher average number of allegation count than the early allegation count.

create view officers_having_lesser_early_allegation as
select aoc.officer_id , aoc.average_allegation_count from max_value_of_early_allgetion_officer mva
inner join avg_officer_allegation_throughout_career aoc on mva.officer_id = aoc.officer_id
where mva.max_count_allegation < aoc.average_allegation_count;

-- step 8
--on the next step,  we find the count for officers having higher number of allegation count than the early allegation count.

select count(officer_id) from officers_having_higher_early_allegations;

--step 9:  on the next step, we find out the count for officers having lesser allegation count than the early allegation count.

select count(officer_id) from officers_having_lesser_early_allegation;

--step 10
-- Removing all views

drop view arrested_officer_with_allegation_count;
drop view officer_subset;
drop view arrestedOfficer_with_earlyallegation_count;
drop view max_value_of_early_allgetion_officer;
drop view avg_officer_allegation_throughout_career;
drop view officers_having_higher_early_allegations;
drop view officers_having_lesser_early_allegation;