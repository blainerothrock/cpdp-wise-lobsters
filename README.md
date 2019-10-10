## Checkpoint 1 Questions
* How can officers be categorized to show allegation count over time (year/year)?
    * Group officers that started on the force around the time of the complete dataset (2000)
        * What are the age groups
    * Split allegation count over time (year/year, quarter/quarter, month/month, etc)
* What is the average number of allegations for different age groups of officers?
    * Group by officer age
    * Group by years on the force
* What is the most common first allegation for officers overall?
    * What is the most common first allegation among repeaters?
* What percentage of officer's first/early allegations are reported with repeaters?
    * Group by type of allegation
    * Does this type of incident repeat again, with or without the group?


## Prerequisites 
* Create views - required for running queries
    - run `subset_view.sql`
        - creates a subset of active officers whom started on the force between 2000 and 2018
        - `subset_aggregate.sql` provides aggregated detailed information about the subset of officers
    - run `first_allegation_view.sql`
        - creates a view that lists the first allegation of all officers.
    - run `repeaters_allegation_view.sql`
        - creates a view that lists all allegations reported on a repeater. A repeater is defined as officer that has at least 10 allegation and is a member of the officer subset.
* Queries for Question 1: How can officers be categorized to show allegation count over time

## Queries by Question
* Question 1
    - `total_allegations_by_years_on_force.sql`
        - total allegation count grouped by years on the force
    - `total_allegation_count_by_officer_age.sql`
        - total allegation count group by officer age
    - `allegation_yearly_averages.sql`
        - allegations averages by year on force over first 10 years
* Question 2
    - `average_allegation_count_by_age.sql`
        - queries the officer subset and groups allegation count by age-group
    - `average_allegation_count_by_years_on_force.sql`
        - queries the officer subset and group allegation count by years on the force
* Question 3
    - `most_common_allegation_category.sql`
        - all allegations grouped by allegation count, sorted by number of allegations
    - `most_common_first_allegation.sql`
        - first allegations of officers in the subset grouped by allegation category
        - modify for all officers by removing clause `WHERE officer_id IN (SELECT id FROM officer_subset)`
    - `total_first_allegation.sql`
        - unique allegation that were a first allegation for at least 1 officer
* Question 4
    - `most_common_first_allegation_repeaters.sql`
        - first allegations of repeaters (>= 10 allegations in career) in the subset grouped by allegation category
        - modify for all officers by removing clause `WHERE officer_id IN (SELECT id FROM officer_subset WHERE allegation_count >= 10)`
    - `first_allegation_with_repeaters.sql`
        - percentage of first allegation that were reported with a repeater (>= 10 allegations in total career)
    