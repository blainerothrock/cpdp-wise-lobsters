# Checkpoint 4: Graph Analytics

## Setup
It takes a very long to construct the edges of our graph in databricks (~1.5 hours for question 1 & ~3.5 hours for question 2), so we have provided the .csv files with our edges and vertices that can be loaded into databricks. For reviewing the provided notebooks should be enough to view what we did. We are providing SQL files of queries we ran on the CPDP database.

## Questions
1. How often are repeaters co-accused with an officer's first allegation of misconduct? Does this pattern form a network?
    - [databricks published notebook]()
    - code can be found in ... & `src/q1.sql`
2. Do allegations of a certain type/name tend to draw a path to a certain award?
    - [databricks published notebook](https://databricks-prod-cloudfront.cloud.databricks.com/public/4027ec902e239c93eaaa8714f173bcfc/6912744444517995/1575454452639307/718492600659211/latest.html)
    - code can be found in `src/q2_analysis.ipynb` (exported databricks notebook) & `src/q2.sql`

