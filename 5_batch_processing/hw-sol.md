## Week 5 Homework 

In this homework we'll put what we learned about Spark in practice.

For this homework we will be using the FHVHV 2021-06 data found here. [FHVHV Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhvhv/fhvhv_tripdata_2021-06.csv.gz )


### Question 1: 

**Install Spark and PySpark** 

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

What's the output?
- 3.3.2 - __Answer__
- 2.1.4
- 1.2.3
- 5.4
</br></br>

```bash
scala> spark.version
res0: String = 3.3.2
```

### Question 2: 

**HVFHW June 2021**

Read it with Spark using the same schema as we did in the lessons.</br> 
We will use this dataset for all the remaining questions.</br>
Repartition it to 12 partitions and save it to parquet.</br>
What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.</br>


- 2MB
- 24MB - __Answer__
- 100MB
- 250MB
</br></br>

```bash
$ ls -lh notebooks/fhv
total 191M
-rw-r--r-- 1 anku anku   0 Mar  6 05:08 _SUCCESS
-rw-r--r-- 1 anku anku 25M Mar  6 05:08 part-00000-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
-rw-r--r-- 1 anku anku 24M Mar  6 05:08 part-00001-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
-rw-r--r-- 1 anku anku 25M Mar  6 05:08 part-00002-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
-rw-r--r-- 1 anku anku 24M Mar  6 05:08 part-00003-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
-rw-r--r-- 1 anku anku 24M Mar  6 05:08 part-00004-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
-rw-r--r-- 1 anku anku 24M Mar  6 05:08 part-00005-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
-rw-r--r-- 1 anku anku 25M Mar  6 05:08 part-00006-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
-rw-r--r-- 1 anku anku 24M Mar  6 05:08 part-00007-e4aeb106-f662-44d3-af96-2350635bfd01-c000.snappy.parquet
```


### Question 3: 

**Count records**  

How many taxi trips were there on June 15?</br></br>
Consider only trips that started on June 15.</br>

- 308,164
- 12,856
- 452,470 - __Answer__
- 50,982
</br></br>

```python
df_process \
    .select('pickup_date') \
    .where(df_process.pickup_date=='2021-06-15') \
    .count()

# Output
# 452470
```

### Question 4: 

**Longest trip for each day**  

Now calculate the duration for each trip.</br>
How long was the longest trip in Hours?</br>

- 66.87 Hours - __Answer__
- 243.44 Hours
- 7.68 Hours
- 3.32 Hours
</br></br>

```python
df_process.select('pickup_date').where(df_process.pickup_date=='2021-06-15').count()df_process \
    .groupBy("pickup_date") \
    .agg((F.max("trip_duration") / 3600 ).alias("trip_duration_sum")) \
    .orderBy(F.desc("trip_duration_sum")) \
    .show(1)

# Output
# 66.878
```


### Question 5: 

**User Interface**

 Spark’s User Interface which shows application's dashboard runs on which local port?</br>

- 80
- 443
- 4040 - __Answer__
- 8080
</br></br>


### Question 6: 

**Most frequent pickup location zone**

Load the zone lookup data into a temp view in Spark</br>
[Zone Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv)</br>

Using the zone lookup data and the fhvhv June 2021 data, what is the name of the most frequent pickup location zone?</br>

- East Chelsea
- Astoria
- Union Sq
- Crown Heights North
</br></br>

```python
spark.sql("""
    SELECT 
        Zone as most_pickup_zone
    FROM t_zone 
    WHERE LocationID = (
        SELECT
            PULocationID
        FROM
            t_trips
        GROUP BY 
            PULocationID
        ORDER BY COUNT(*) desc LIMIT 1
    )
""").show()

# Output
# Crown Heights North
```

## Submitting the solutions

* Form for submitting: https://forms.gle/EcSvDs6vp64gcGuD8
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 06 March (Monday), 22:00 CET


## Solution

We will publish the solution here