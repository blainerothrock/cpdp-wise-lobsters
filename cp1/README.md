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


# Queries by Question
* Question 1
    - `q1.sql`
        - creates a temp view that is a subset of active officers whom started on the force between 2000 and 2018
            - this view will be used in queries for questions 2-4
        - creates data points for
            * age group
            * years on the force
            * total number of allegations
            * allegation count year/year
        - returns aggregate data of the view
* Question 2
    - `q2_age.sql`
        - queries the officer subset and groups allegation count by age-group
    - `q2_years_on_force.sql`
        - queries the officer subset and group allegation count by years on the force
* Question 3
    - `q3.sql`
        - first creates a temp view which is a list of officers in the subset with first allegations
        - using that view, group allegations categories
        - view is used in question 4.
* Question 4
    - `q3.sql`
        - creates a temp view of officer allegation ids, allegation ids and officer ids of repeated officers.
            - includes a date when the officer becomes a "repeater"
        - Runs a aggregation query that divides the number of first allegations that occurred with a active repeater by the total number of first allegations (from view in question 3)
        - returns a percentage 

NOTE: disconnecting from the psql session will remove the temporary views, but to manually remove run the following:
- `DROP VIEW officer_subset`
- `DROP VIEW officer_first_allegation`
- `DROP VIEW repeater_allegations` 
    