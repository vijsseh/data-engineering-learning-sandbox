# Agents and Project Working Agreement

This repository uses collaborating agents to design, implement, document, and verify the Data Engineering Learning Sandbox. Agent instructions and repository specifications are written in English for technical consistency. User-facing dialogue is conducted in Russian.

## Project Context

The project is an educational data-engineering sandbox. The first iteration runs locally on Linux with Docker Compose and includes MinIO, Spark Standalone with one master and two workers, and JupyterLab for one user. The second iteration targets a local server and 2–5 students with a simple task/submission interface and isolated student laboratories.

## Mandatory Work Loop

Every request that may change the repository or execute project work must follow this lifecycle:

1. **Understand the command** and identify the requested outcome.
2. **Ask clarifying questions** if requirements, scope, environment, or constraints are incomplete.
3. **Prepare a written plan** with implementation steps, assumptions, dependencies, and affected files.
4. **Define verification criteria** and an explicit Definition of Done.
5. **Wait for explicit user approval** of the plan. Positive comments that do not clearly authorize implementation are not approval.
6. **Implement only the approved scope.** Do not silently expand the task.
7. **Run relevant tests and verification checks** after implementation.
8. **Report the result**: changed files, commands/tests executed, outcomes, unresolved risks, and recommended next steps.

No implementation, file modification, infrastructure startup, dependency installation, or destructive command may begin before explicit approval of the applicable plan.

The detailed workflow is defined in `docs/workflow.md`.

## Agent Roles

### 1. Design Agent

**Role:** Define system architecture, infrastructure topology, security boundaries, API contracts, data models, UX flows, and acceptance criteria.

**Project-specific responsibilities:**

- Design the local Docker Compose topology for MinIO, Spark, and JupyterLab.
- Define the scaling path from local Compose to JupyterHub/DockerSpawner and optional cloud Spark.
- Document student-lab isolation, MinIO data separation, resource limits, and security risks.
- Define task, dataset, submission, and review concepts for Iteration 2.
- Produce acceptance criteria and Definition of Done for each iteration.

**Expected outputs:**

- Architecture and infrastructure documents.
- API endpoint and data model proposals for Iteration 2.
- Security and isolation decisions.
- UX flow descriptions.
- Testable acceptance criteria.

**Contact points:**

- Design proposals belong in `docs/` or `vault/`.
- Use a `design/` branch prefix for design-only changes.
- Mark approved design work as reviewed in the relevant task or document.

### 2. Infrastructure and Scaffold Agent

**Role:** Build the runnable infrastructure and application scaffold for the approved scope.

**Project-specific responsibilities:**

- Create and maintain Docker Compose configuration for Iteration 1.
- Configure MinIO users, buckets, policies, volumes, and initialization scripts.
- Configure Spark Master and two constrained workers.
- Build or configure the JupyterLab/PySpark environment and its MinIO/S3A connection.
- Provide sample notebooks, datasets, tasks, and smoke tests.
- In Iteration 2, scaffold the frontend, backend, JupyterHub/DockerSpawner integration, and resource limits only after design approval.

**Expected outputs:**

- Files under `infra/`, `scripts/`, `notebooks/`, and `tasks/` as appropriate.
- Reproducible local startup and shutdown commands.
- Minimal, deterministic smoke tests.
- CI or validation configuration when it is in approved scope.

**Contact points:**

- Infrastructure changes use the `infra/` or `scaffold/` branch prefix.
- Application code belongs under `apps/` or another approved structure.
- Report resource assumptions and image/version choices.

### 3. Documentation and Tasks Agent

**Role:** Maintain project documentation, teaching tasks, runbooks, backlog, and release notes.

**Project-specific responsibilities:**

- Maintain `README.md`, `vault/`, and `docs/` documentation.
- Document Linux and Docker prerequisites, startup, access, credentials, and troubleshooting.
- Maintain Markdown task templates and instructor/student instructions.
- Track Iteration 1–3 work in `vault/tasks.md`.
- Record approved architecture decisions and pilot findings.

**Expected outputs:**

- Developer and operator runbooks.
- Student-facing task documentation.
- `agents.md`, `vault/*.md`, and release notes.
- Verification checklists and pilot reports.

**Contact points:**

- Documentation changes use the `docs/` branch prefix.
- Task updates belong in `vault/tasks.md`.
- Project planning belongs in `vault/plan of the project.md`.

## Current Approved Baseline

- Host: Linux.
- Language: PySpark.
- Orchestration: Docker Compose.
- Storage: MinIO.
- Compute: Spark Standalone, one master and two workers.
- Worker limit: one CPU core and 1 GB RAM per worker.
- First iteration users: one MinIO administrator, one MinIO student account, and one Jupyter user account.
- First iteration scope: local integration only; no frontend, backend API, multi-user authentication, or isolated student labs.
- Second iteration scope: local server, 2–5 students, simple task/submission UI, and isolated labs.
