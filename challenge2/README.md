# Challenge 2

## Submission
* `data/submission.csv`

## what we did:
* Left joined `data_officers` to the `data_officerarrests` table from challenge 1 in Trifacfa
    - Trifacta flow `flow_216_cbdbcda0-0805-11ea-86d4-0d4b6c8b54cf.json`
* Loaded the newly joined `data_officerarrests` table locally
    - We experienced an issue with loading dates, so we did the following:
        * created tables with date fields as `varchar`
        * loaded from `.csv`s exported from Trifacta
        * updated date format from `MM/dd/yyyy` to `MM-dd-yyyy`
        * updated table date columns from `varchar` to `date`
    - code:
        * `src/create_table_no_dates.sql`
        * `src/convert_to_dates.sql` 
* Joined `data_officerbadgenumber` with `data_officerarrest`
    - Used a series of views, code: `src/star_view.sql`