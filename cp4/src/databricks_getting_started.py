# connect to the data base and create read method
url = "jdbc:postgresql://cpdb-databricks.cgod7egsd6vr.us-east-2.rds.amazonaws.com/cpdb"
user = "data_sci"
pwd = "dataSci4lyf"
driver = "org.postgresql.Driver"

reader = spark.read.format("jdbc")\
  .option("driver", driver)\
  .option("url", url)\
  .option("user", user)\
  .option("password", pwd)\

def cpdp_read(query):
  return reader.option("dbtable", query).load()


# table -> data frame
data_officers_df = cpdp_read("data_officer")

# query -> data frame
data_officer_subset_query = """
  (SELECT o.id, 
    o.first_name, 
    o.last_name, 
    o.birth_year, 
    o.appointed_date,
    date_part('year', '2018-01-01'::DATE) - o.birth_year as estimated_age,
    ('2018-01-01'::DATE - o.appointed_date) / 365 as years_on_force,
    COUNT(a.id) as allegation_count
  FROM data_officer o
  LEFT JOIN data_officerallegation a on o.id = a.officer_id
  WHERE active = 'Yes'
    AND appointed_date BETWEEN '2000-01-01' AND '2007-12-31'
  GROUP BY o.id
  ORDER BY years_on_force DESC) officer_subset
"""
data_officer_subset_df = cpdp_read(data_officer_subset_query)