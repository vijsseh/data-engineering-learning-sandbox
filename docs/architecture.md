# Iteration 1 Infrastructure Architecture

## 1. Scope

Iteration 1 is a local Linux environment for one instructor/developer user. It demonstrates a complete PySpark workflow against S3-compatible storage. The environment is educational and intended for small datasets; it is not a production or multi-tenant deployment.

Included services:

- Garage for S3-compatible object storage;
- Apache Spark Standalone Master;
- two Apache Spark Workers;
- JupyterLab with PySpark support;
- Docker Compose for orchestration.

Excluded from Iteration 1:

- frontend and backend application;
- multi-user authentication;
- JupyterHub;
- per-student lab isolation;
- cloud Spark;
- production TLS, public exposure, and high availability.

## 2. Logical Architecture

```text
                         Host browser
                              |
              +---------------+----------------+
              |                                |
              v                                v
      Garage S3 API                        JupyterLab
           :3900                              :8888
              ^                                |
              |                                | PySpark
              |                                v
              |                         Spark Master
              |                         RPC :7077
              |                         UI  :8080
              |                                |
              |                 +--------------+--------------+
              |                 |                             |
              |                 v                             v
              +---------- Spark Worker 1              Spark Worker 2
                         UI :8081                    UI :8082
                         1 CPU / 1 GB                1 CPU / 1 GB
```

All containers use one private Docker network. Containers address one another by Compose service name, not by host IP.

## 3. Service Responsibilities

### Garage

- Stores input datasets and Spark output objects.
- Exposes an S3-compatible API to Spark and JupyterLab.
- Exposes the S3 API for Spark and JupyterLab; Garage has no MinIO-style web Console in this setup.
- Uses a named persistent volume.
- Provides one administrator account and one student account in the first iteration.
- Credentials are supplied through environment variables and must not be committed.

### Spark Master

- Runs the Spark Standalone scheduler.
- Accepts worker registrations on RPC port `7077`.
- Exposes the Spark Master UI on port `8080`.
- Does not store student data.

### Spark Workers

- Execute tasks scheduled by the Spark Master.
- Two workers are used to demonstrate distributed execution.
- Each worker is limited to one CPU and 1 GB RAM.
- Worker UI ports are exposed locally as `8081` and `8082`.

### JupyterLab

- Provides the interactive browser interface for PySpark notebooks.
- Connects to the Spark Master using the Docker service name.
- Uses PySpark and preinstalled S3A-compatible Hadoop dependencies to access Garage; runtime Maven downloads are not required.
- Uses one configured Jupyter account in Iteration 1.
- May use a named volume for notebooks and local workspace data.

## 4. Docker Compose Topology

Expected service names:

```text
garage
spark-master
spark-worker-1
spark-worker-2
jupyter
```

All services attach to a private network, for example:

```text
sandbox-net
```

Expected startup dependency direction:

```text
garage healthy
    |
    +--> jupyter

spark-master healthy
    |
    +--> spark-worker-1
    +--> spark-worker-2
    +--> jupyter
```

Compose dependencies control startup order and basic readiness. They do not replace functional integration tests.

## 5. Local Ports

| Service           | Container port | Host port | Purpose                           |
| ----------------- | -------------: | --------: | --------------------------------- |
| Garage S3 API     |           3900 |      3900 | S3-compatible API                 |
| Garage Admin API  |           3903 |      3903 | Local administration API          |
| Spark Master RPC  |           7077 |      7077 | Worker and application connection |
| Spark Master UI   |           8080 |      8080 | Master status and workers         |
| Spark Worker 1 UI |           8081 |      8081 | Worker status                     |
| Spark Worker 2 UI |           8082 |      8082 | Worker status                     |
| JupyterLab        |           8888 |      8888 | Notebook interface                |

These ports are intended for local access only. They should not be exposed directly to the public internet.

## 6. Persistent Storage

Expected named volumes:

```text
garage-meta       -> Garage metadata directory
garage-data       -> Garage data directory
jupyter-work     -> Jupyter notebooks and workspace (if persistence is enabled)
```

The source datasets and generated Spark results must be stored in Garage. A notebook filesystem is not a substitute for object-storage persistence.

## 7. Credentials and Configuration

Configuration must be provided through an untracked `.env` file created from `.env.example`.

The configuration should define, at minimum:

- Garage admin access key and secret key;
- Garage student access key and secret key;
- bucket permissions for both keys;
- Jupyter password or token configuration;
- Garage endpoint used by Spark and Jupyter;
- Spark master URL.

No real credentials may be committed to GitHub. The local-only example values in documentation must be clearly marked as examples.

## 8. Data Flow

The reference teaching workflow is:

```text
1. Upload a small CSV or Parquet dataset to Garage.
2. Open JupyterLab.
3. Create a PySpark session targeting spark://spark-master:7077.
4. Read the dataset through the Garage S3A endpoint.
5. Transform and aggregate the data.
6. Write the result back to a Garage output prefix.
7. Inspect the result through Garage or a follow-up notebook.
```

Spark and Jupyter must use the internal service endpoint, for example:

```text
http://garage:3900
```

The browser uses the host-mapped Jupyter port; S3 operations use the Garage API or an S3 client.

## 9. Healthchecks and Readiness

Every Iteration 1 service must have a Docker healthcheck.

### Garage

Use the Garage CLI status command against the configured node as the container healthcheck. The S3 API may return an authorization response for an unauthenticated request, which proves network reachability but does not replace an authenticated S3 test.

### Spark Master

Check that the Spark Master process is listening and that its local UI or RPC endpoint responds. The exact probe may use an image-provided utility or a TCP check, depending on the selected Spark image.

### Spark Workers

Check that each worker process is running and reachable. A healthy worker process alone is insufficient; the smoke test must also verify that both workers are registered with the Master.

### JupyterLab

Check that the Jupyter HTTP endpoint responds on port `8888`. The probe should not expose credentials in logs.

Healthchecks must be used with Compose readiness dependencies where supported. They must not be treated as proof that the complete Spark-to-Garage workflow works; that requires a functional PySpark smoke test.

## 10. Verification Layers

### Container-level verification

- All services reach a healthy state.
- The private network exists.
- Named volumes are mounted.
- Worker CPU and memory limits are applied.

### Service-level verification

- Garage status and S3 API are reachable.
- Spark Master UI is reachable.
- Two workers are shown as registered.
- JupyterLab is reachable with the configured access method.

### Functional verification

- A PySpark notebook connects to the Master.
- Spark reads a dataset from Garage.
- Spark writes an output to Garage.
- The output remains available after a restart.

## 11. Iteration 2 Extension Path

Iteration 2 should preserve the service boundaries while adding a platform layer:

```text
Frontend + Backend API
          |
          +--> JupyterHub / DockerSpawner
          |       +--> student-1 lab container
          |       +--> student-2 lab container
          |       +--> ...
          |
          +--> Garage student buckets/prefixes
          +--> task and submission metadata
```

JupyterHub/DockerSpawner is the preferred first isolation option because it can create one container per student and apply per-container resource limits. Garage isolation must later be evaluated as separate buckets, prefixes, or credentials/policies.

## 12. Architecture Definition of Done

- [ ] Service responsibilities are documented.
- [ ] Docker network and service names are defined.
- [ ] Local ports are defined.
- [ ] Persistent volumes are defined.
- [ ] Garage, Spark, and Jupyter data flow is documented.
- [ ] Garage admin and student access assumptions are documented.
- [ ] Spark worker limits are documented as one CPU and 1 GB RAM each.
- [ ] Healthcheck requirements are documented for every service.
- [ ] Healthchecks are distinguished from functional smoke tests.
- [ ] Iteration 2 isolation direction is documented.
