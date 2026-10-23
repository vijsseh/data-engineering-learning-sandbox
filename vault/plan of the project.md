# Data Engineering Learning Sandbox — Project Plan

## 1. Project Goal

Build a reproducible teaching platform where students can practice data engineering tools through small, guided tasks. The platform will begin as a locally hosted Docker environment and later evolve into a multi-user service with isolated student laboratories and a simple task/submission interface.

The initial teaching stack is:

- MinIO as S3-compatible object storage;
- Apache Spark for distributed computation;
- JupyterLab as the interactive student workspace;
- Docker Compose for local orchestration.

The project is intended for education and small datasets, not high-volume production data processing.

## 2. Confirmed Constraints and Decisions

- Host operating system: Linux.
- First iteration user: one platform administrator/instructor.
- First iteration language: PySpark only.
- First iteration Spark mode: Spark Standalone with one master and two workers.
- Worker resources: one CPU core and 1 GB RAM per worker.
- First iteration MinIO accounts: one administrator account and one student account.
- First iteration Jupyter access: one user account.
- First iteration persistence: Docker named volumes for MinIO data and relevant workspace data.
- First iteration orchestration: Docker Compose.
- First iteration frontend/backend application: explicitly out of scope.
- Second iteration target: local server installation tested with 2–5 students.
- Future student isolation: one Jupyter environment per student, preferably through JupyterHub with DockerSpawner or an equivalent container-spawning mechanism.
- Future Spark deployment: may move to a small cloud-based Spark setup if local server resources become insufficient.

## 3. Iteration 1 — Local Data Engineering Sandbox

### Objective

Prove that one user can run a complete local data-engineering workflow using MinIO, Spark, and JupyterLab.

### Target services

```text
minio
spark-master
spark-worker-1
spark-worker-2
jupyter
```

All services communicate over a private Docker network.

### Required capabilities

1. Start and stop the environment with Docker Compose.
2. Open the MinIO Console and S3 API.
3. Open the Spark Master UI and verify both workers are registered.
4. Open JupyterLab with a single configured user account.
5. Connect PySpark from JupyterLab to the Spark Master.
6. Read a CSV or Parquet dataset from MinIO through S3A.
7. Perform a simple transformation and aggregation.
8. Write the result back to MinIO.
9. Preserve MinIO data after service restarts.
10. Provide one runnable example notebook and one introductory task.

### Planned repository deliverables

```text
infra/
  docker-compose.yml
  .env.example
  minio/
  spark/
  jupyter/
notebooks/
  hello-minio-spark.ipynb
tasks/
  task-001-reading-from-s3.md
scripts/
  init-minio.sh
  smoke-test.sh
docs/
  architecture.md
  iteration-1-runbook.md
  workflow.md
```

### Iteration 1 Definition of Done

- [ ] The full stack starts on Linux using one documented Docker Compose command.
- [ ] MinIO is reachable through its Console and S3 API.
- [ ] MinIO has one administrator account and one student account as documented configuration.
- [ ] MinIO data persists across container restarts.
- [ ] Spark Master is reachable and shows two registered workers.
- [ ] Each worker is configured with one CPU core and 1 GB RAM.
- [ ] JupyterLab is reachable and protected by the configured single-user access method.
- [ ] A PySpark notebook connects to Spark and reads from MinIO.
- [ ] The notebook writes a transformed result to MinIO.
- [ ] A smoke-test procedure verifies MinIO, Spark, and Jupyter connectivity.
- [ ] The runbook documents prerequisites, startup, access URLs, credentials configuration, shutdown, and troubleshooting.
- [ ] No frontend, backend API, multi-user authentication, or per-student isolation is required for completion of this iteration.

## 4. Iteration 2 — Local Multi-Student Platform Prototype

### Objective

Deploy the platform on a local server and test it with 2–5 students.

### Planned capabilities

- Simple frontend for browsing available tasks.
- Simple backend API for task metadata and solution submissions.
- Student login or another explicit identity mechanism.
- Separate Jupyter environment for each student.
- Student-specific workspace and result area.
- Instructor view of submitted solutions.
- Basic CPU and memory limits for student environments.
- Basic task lifecycle: draft, published, submitted, reviewed.

### Preferred isolation direction

Evaluate JupyterHub with DockerSpawner first. Each student should receive a separate container, filesystem/home directory, and resource limit. MinIO data should be separated by student bucket or prefix, with a later evaluation of per-student credentials and policies.

### Iteration 2 Definition of Done

- [ ] A local server hosts the platform for 2–5 test students.
- [ ] Students can see published tasks through the simple interface.
- [ ] Each student can open a separate Jupyter environment.
- [ ] Students cannot access another student's workspace.
- [ ] Students have isolated result locations in MinIO.
- [ ] Students can submit solutions.
- [ ] The instructor can inspect submitted solutions.
- [ ] Lab CPU/RAM limits are documented and tested.
- [ ] Restarting or recreating one student lab does not destroy other student data.
- [ ] A manual pilot with 2–5 students is completed and documented.

## 5. Iteration 3 — Small-Scale Hosted Teaching Platform

### Objective

Prepare the platform for repeatable teaching sessions and optional cloud deployment.

### Candidate capabilities

- Cloud or managed Spark with small resource allocations.
- S3-compatible cloud storage or hosted MinIO.
- Authentication and role-based authorization.
- Automatic creation and cleanup of student labs.
- Idle environment shutdown.
- Resource quotas and cost controls.
- Monitoring and logs.
- Backups of tasks, datasets, and submissions.
- Automated validation for selected assignments.

### Iteration 3 Definition of Done

- [ ] Student environments can be provisioned and removed predictably.
- [ ] Authentication and authorization are implemented.
- [ ] Resource and cost limits are enforced.
- [ ] Task and submission data are backed up.
- [ ] Basic monitoring and troubleshooting information are available.
- [ ] A deployment and operations runbook exists.

## 6. Project Work Sequence

Every implementation request follows the workflow defined in `docs/workflow.md` and summarized in `agents.md`:

1. Understand the command.
2. Ask clarifying questions when necessary.
3. Write an implementation plan.
4. Define verification criteria and Definition of Done.
5. Wait for explicit user approval.
6. Implement only the approved scope.
7. Run relevant tests and verification checks.
8. Report changes, test results, and remaining risks.

No implementation begins before explicit approval of the plan.

## 7. Open Decisions for Future Iterations

- Whether Iteration 2 should use JupyterHub immediately or start with a simpler custom container launcher.
- Whether student data should use separate MinIO buckets, prefixes, or credentials.
- Which frontend and backend stack should be used for the task/submission interface.
- Whether the second-iteration backend needs a database or can initially use Markdown/object storage.
- Which cloud Spark option is appropriate after local resource limits are measured.
