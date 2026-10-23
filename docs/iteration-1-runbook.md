# Iteration 1 Runbook

## Prerequisites

- Linux host.
- Docker Engine.
- Docker Compose v2 (`docker compose`).
- At least 4 CPU cores and approximately 6 GB available RAM for the initial test configuration.
- Ports `7077`, `8080`, `8081`, `8082`, `8888`, `9000`, and `9001` available locally.

## Initial Setup

From the repository root:

```bash
cp infra/.env.example infra/.env
```

Edit `infra/.env` and replace all example passwords and the Jupyter token. Do not commit `infra/.env`.

## Start the Environment

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml up -d --build
```

The first build may download Spark, Python, and Hadoop dependencies. Jupyter's PySpark configuration downloads the Hadoop AWS package when the first Spark session starts unless it is already cached.

## Local URLs

- MinIO Console: `http://localhost:9001`
- MinIO S3 API: `http://localhost:9000`
- Spark Master UI: `http://localhost:8080`
- Spark Worker 1 UI: `http://localhost:8081`
- Spark Worker 2 UI: `http://localhost:8082`
- JupyterLab: `http://localhost:8888`

Use the credentials configured in `infra/.env`.

## Check Service State

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml ps
```

All long-running services should report a healthy state. The one-shot `minio-init` service should exit successfully.

Confirm in the Spark Master UI that both workers are registered.

## Run the Smoke Test

From the repository root:

```bash
sh scripts/smoke-test.sh
```

The smoke test validates Compose configuration and checks MinIO, Spark Master, registered workers, and JupyterLab endpoints.

## Run the Example Notebook

1. Open JupyterLab.
2. Open `notebooks/hello-minio-spark.ipynb`.
3. Execute the cells in order.
4. Confirm that the input is read from `s3a://datasets/sample.csv`.
5. Confirm that the output is written to `s3a://student-results/hello-minio-spark/`.
6. Inspect the result in MinIO Console if required.

## Stop the Environment

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml down
```

Named volumes are preserved by `down`, so MinIO data remains available for the next start.

To remove the local data volumes intentionally:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml down -v
```

This permanently removes the local MinIO and Jupyter volume data and must not be run casually.

## Troubleshooting

### A service is unhealthy

Inspect logs:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml logs <service-name>
```

### Spark workers are not visible

Check the Master and worker logs and verify that all services use the Compose network and that the Master URL is `spark://spark-master:7077`.

### S3A access fails

Verify the student credentials, the MinIO endpoint `http://minio:9000`, path-style access configuration, and that the `datasets` bucket exists.

### A port is already in use

Change the host-side port in `infra/.env`; do not change the internal service ports without updating the related configuration.

## Iteration 1 Verification Checklist

- [ ] All long-running services are healthy.
- [ ] MinIO Console and S3 API respond.
- [ ] Both Spark workers are registered.
- [ ] JupyterLab is accessible.
- [ ] The notebook reads from MinIO.
- [ ] The notebook writes to MinIO.
- [ ] The result remains available after a stop/start cycle.
