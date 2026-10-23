# Iteration 1 Runbook

## Prerequisites

- Linux host.
- Docker Engine.
- Docker Compose v2 (`docker compose`).
- At least 4 CPU cores and approximately 6 GB available RAM for the initial test configuration.
- Ports `3900`, `3903`, `7077`, `8080`, `8081`, `8082`, and `8888` available locally.
- Access to `docker.io` for Spark/Jupyter images and `dxflrs/garage:v1.0.0`.

## Initial Setup

From the repository root:

```bash
cp infra/.env.example infra/.env
```

Edit `infra/.env` and replace the example Garage secrets and Jupyter token. Do not commit `infra/.env`.

Garage requires a one-time local initialization after the server starts. The initialization creates a single local node layout, two S3 access keys, and the `datasets` and `student-results` buckets.

## Start the Environment

Start Garage first:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml up -d garage
sh scripts/init-garage.sh
```

Then start Spark and JupyterLab:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml up -d --build
```

The first build may download Spark, Python, and Hadoop dependencies. Jupyter's PySpark configuration downloads the Hadoop AWS package when the first Spark session starts unless it is already cached.

## Local URLs

- Garage S3 API: `http://localhost:3900`
- Garage Admin API: `http://localhost:3903`
- Spark Master UI: `http://localhost:8080`
- Spark Worker 1 UI: `http://localhost:8081`
- Spark Worker 2 UI: `http://localhost:8082`
- JupyterLab: `http://localhost:8888`

Garage does not provide a MinIO-style web Console in this setup. Use the Garage CLI through the container and the S3 API for storage operations.

Use the credentials configured in `infra/.env` for S3 access.

## Check Service State

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml ps
```

All long-running services should report a healthy state. Confirm in the Spark Master UI that both workers are registered.

To inspect Garage status:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml exec garage \
  /garage -c /etc/garage.toml status
```

## Run the Smoke Test

From the repository root:

```bash
sh scripts/smoke-test.sh
```

The smoke test validates Compose configuration, Garage status, Spark Master, registered workers, and JupyterLab availability.

## Run the Example Notebook

1. Open JupyterLab.
2. Open `notebooks/hello-minio-spark.ipynb`.
3. Execute the cells in order; the first cell uploads the sample dataset to Garage.
4. Confirm that the input is read from `s3a://datasets/sample.csv`.
5. Confirm that the output is written to `s3a://student-results/hello-garage-spark/`.
6. Verify the result through an S3 client or a follow-up notebook.

## Stop the Environment

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml down
```

Named volumes are preserved by `down`, so Garage data remains available for the next start.

To remove the local data volumes intentionally:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml down -v
```

This permanently removes the local Garage and Jupyter volume data and must not be run casually.

## Troubleshooting

### A service is unhealthy

Inspect logs:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml logs <service-name>
```

### Garage is not ready

Check the Garage status and logs:

```bash
docker compose --env-file infra/.env -f infra/docker-compose.yml exec garage \
  /garage -c /etc/garage.toml status
docker compose --env-file infra/.env -f infra/docker-compose.yml logs garage
```

### Spark workers are not visible

Check the Master and worker logs and verify that all services use the Compose network and that the Master URL is `spark://spark-master:7077`.

### S3A access fails

Verify the student credentials, the Garage endpoint `http://garage:3900`, path-style access configuration, and that the `datasets` bucket exists.

### A port is already in use

Change the host-side port in `infra/.env`; do not change the internal service ports without updating the related configuration.

## Iteration 1 Verification Checklist

- [ ] Garage reports a healthy single-node layout.
- [ ] Garage S3 API responds to authenticated requests.
- [ ] Both Spark workers are registered.
- [ ] JupyterLab is accessible.
- [ ] The notebook reads from Garage.
- [ ] The notebook writes to Garage.
- [ ] The result remains available after a stop/start cycle.
