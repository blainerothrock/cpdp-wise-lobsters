# CPDP Data Science Challenge #1

## Submission
* [Trifacta Flow](https://northwestern.amer.trifacta.net/flows/37)
    - We used one flow to simplify navigating Trifacta.
* [data_arrest.csv](s3://northwestern.amer.trifacta.net/trifacta/queryResults/blainerothrock2020@u.northwestern.edu/data_arrest.csv)
* [data_officerarrest.csv](
s3://northwestern.amer.trifacta.net/trifacta/queryResults/blainerothrock2020@u.northwestern.edu/data_officerarrest.csv)


## How we Did it
**2.1 File-at-a-time preparation** (Trifacta)

For each dataset, we did some initial cleaning which included removing metadata rows, naming columns and removing unused columms. We also added the `arrest_year` column which was parsed from the file name. We kept this step to a minimum number of steps since it needed to be repeated for each dataset. 

**2.2 Assembling and cleaning the tables**

First, we created two union recipes, one for `data_arrests` and one for `data_officerarrests` these unions combined all the year datasets into one table. In some cases we manually matched the columns in the union as a few tables are inconsistent. From here we started cleaning the data to match the provided schema, set missing/mismatched values to null and formatted dates.

For `data_officerarrest` we created a additional recipe that joined the `arresting-officers-update` dataset which added the `arrest_date` field.

**2.3 Extracting the officer names**

To accomplish the correct formatting we exported the completed `data_officerarrest` data set and ran cleaning script provided from invisible institute [chicago-police-data](https://github.com/invinst/chicago-police-data) repo. We copied [clean_name_utils.py](https://github.com/invinst/chicago-police-data/blob/master/share/src/clean_name_utils.py) and ran on names in the `data_officerarrest` dataset. We saved the output to a csv which included the original full name field and the split fields for `first_name`, `last_name`, `middle_initial` and `suffix_name` and uploaded into our Trifacta flow. The last step in our final join recipe is to join the separated name fields into our `data_officerarrest` output.

Our code can found in `src/`, for simplicity we used a Jupyter notebook to do the processing. We did not include any data files in the upload.

**2.4 Linking the officers to their arrests**

We joined our final cleaned `data_arrest` dataset with our final cleaned `data_officerarrest` table using `cb_number` and our generated `arrest_year` field. 