# Checkpoint 3: Data Integration

## Setup
* To run the below queries, settlement and arrests data need to be loaded.
* Integration queries can be found here:
    - `src/create_officer_map.sql` -- maps officers to settlement data
    - `src/create_case_map.sql` -- maps allegations to civil suits 

## Queries by Question
1. What is the average number of complaints against an officer with any type of settlement compared to officers with no settlements by years on the force?
    - `q1.sql`
        * Creates temp views for subset of offices and mapping cases & settlement data by years on the force
    - `q1_plotting.ipynb`
        * Used to create the plot in findings, used the same queries found in `q1.sql`
2. After a settlement, does the average number of allegations decrease?
    - `q2.sql`
        * Creates temp views (some are the same as q1), including a view that identifies the first settlement for an officer in our subset. Final query is an aggregation.
    - `q2_plotting.ipynb`
        * Used to create the plot in findings, used the same queries found in `q2.sql`
3. What is the average number of arrests per officer over years on the force and how many allegation occurred with an arrest?
    - TODO:
4. Does a high number of allegations with an arrest early in an officer's career lead to a higher average of allegations?
    - TODO: 