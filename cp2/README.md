## Checkpoint 1

# Question 1 (d3 inteactive)
- [CPDP First Civilian Allegation Count By Category and Name](https://observablehq.com/@blainerothrock/cpdp-first-allegation-by-category-and-name)
- [CPDP All Civilian Allegation Count by Category and Name](https://observablehq.com/@blainerothrock/zoomable-circle-packing)
- supporting queries `src/queries/d3_packed_all.sql` & `src/queries/d3_packed_first.sql`
- python transformation script `src/data/tojson.py`
- data files `src/data/allegation_cat_name.csv` & `src/data/allegation_cat_first_name.csv`

# Questions 1 - 3
For questions 1 - 3 please see the following Tableau Workbooks
- `src/tableau/Question1.twbx`
- `src/tableau/Question2.twbx`

# Question 4 (d3 Interactive)
- In Terminal, navigate to `src/`
- Start a webserver with either `node` or `Python3`
  - Python: `python -m http.server` (installed with Python3 by default)
  - Node: `http-server` ([install](https://www.npmjs.com/package/http-server))
- Navigate to localhost:[PORT] (usually 8000 or 8080, depending on the webserver used)

* **NOTE**: supporing data can be found in `src/data/` and queries that created the data can be found in `src/queries`
* **NOTE**: first draft (non-filtering) Observable notebook is included, [link](https://observablehq.com/@blainerothrock/untitled) to hosted version 
