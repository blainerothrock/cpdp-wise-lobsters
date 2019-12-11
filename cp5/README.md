# Checkpoint 5: Natural Language Processing and Machine Learning

## setup
All code for this checkpoint is written in Python3 and requires some dependencies to be installed. We have listed our dependencies in `src/requirements.txt` and we suggest creating a virtual environment before starting. We suggest using Anconda to create a environment:

`conda create --name your_env_name`

then install our dependencies using:

`pip install -r requirements.txt` from the `src` directory.

here is a  [tutorial](https://towardsdatascience.com/getting-started-with-python-environments-using-conda-32e9f2779307) for getting started with Anaconda. Our code is located in jupyter notebooks, to start the juypter server run `jupyter notebook` in the python environment after install dependencies.


## Questions
* Question 1:
    - code: `src/q1.ipynb`
        - loads data from csv
    - sql: `src/q1.sql`
* Question 2:
    - code: `src/q2.ipynb`
        - update local database credentials in cell #2
    - sql: `src/q2.sql`
* Question 3:
    - prereq: `src/lda_load.sql`
        - loads document tags and results of the LDA model (needed for question #4)
    - code: `src/LDA Model.ipynb`
        - contains workflow for running the LDA model (also used in question #4)
    - sql: `src/q3.sql`
* Question 4:
    - prereq: same as #3
    - code: `src/q4 - plotting.ipynb`
        - update local database credentials in cell #2
    - sql: `src/q4.sql`
