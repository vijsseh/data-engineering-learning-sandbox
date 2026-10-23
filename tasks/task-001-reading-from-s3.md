# Task 001 — Read and Aggregate Data from S3

## Objective

Use PySpark to read a dataset from MinIO through the S3A connector, calculate a simple aggregation, and write the result back to MinIO.

## Prerequisites

- Iteration 1 Docker Compose environment is running.
- JupyterLab is available.
- The sample dataset is available in the `datasets` bucket.

## Student Deliverables

1. A notebook that reads the input dataset.
2. A transformation and aggregation by `category`.
3. Results written to `student-results/task-001/`.
4. A short Markdown explanation of the solution.

## Acceptance Criteria

- The notebook creates a Spark session using the configured Spark Master.
- The input is read from an `s3a://datasets/...` path.
- The result contains one row per category.
- The result is written to MinIO.
- The notebook runs without hard-coded credentials.

## Suggested Starting Point

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import count, sum as sum_

spark = (
    SparkSession.builder
    .appName("task-001")
    .master("spark://spark-master:7077")
    .getOrCreate()
)

input_df = spark.read.option("header", True).option("inferSchema", True).csv(
    "s3a://datasets/sample.csv"
)

result_df = input_df.groupBy("category").agg(
    count("*").alias("row_count"),
    sum_("amount").alias("total_amount"),
)

result_df.write.mode("overwrite").parquet(
    "s3a://student-results/task-001/"
)
```

Use environment-provided configuration for credentials and the MinIO endpoint. Do not commit secrets.
