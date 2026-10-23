# Project Work Workflow

## Purpose

This document defines how requests are converted into approved, implemented, and verified changes. It applies to agents and any human contributor working on the Data Engineering Learning Sandbox.

## Language Policy

- User-facing conversation: Russian.
- Repository documentation, technical specifications, code comments, configuration, and agent instructions: English unless a task explicitly requires another language.

## Lifecycle

### 1. Command Understanding

Identify:

- the requested outcome;
- the affected iteration;
- whether the request is documentation, infrastructure, application code, or operations;
- the expected deliverables;
- whether the request may modify files or run commands.

Do not infer permission to implement from a general discussion about an idea.

### 2. Clarifying Questions

Ask only the questions needed to remove material ambiguity. Typical topics include:

- target iteration and scope;
- host environment and resource constraints;
- security and access requirements;
- persistence and backup expectations;
- compatibility requirements;
- acceptance criteria.

Record important answers in the project plan or relevant design document.

### 3. Implementation Plan

Before implementation, present a plan containing:

- objective and scope;
- assumptions and constraints;
- step-by-step changes;
- affected files or directories;
- dependencies and risks;
- verification commands and manual checks;
- Definition of Done.

The plan must clearly separate included work from explicitly excluded work.

### 4. User Verification and Approval

Wait for explicit user approval before modifying files, installing dependencies, starting containers, or running project operations.

Examples of approval:

- `План утверждаю`;
- `Можно начинать реализацию`;
- `Approve the plan`;
- `Начинай Iteration 1`.

Questions, suggestions, or statements such as `выглядит хорошо` do not automatically authorize implementation unless they clearly grant permission.

If the user changes the scope, revise the plan and request approval again.

### 5. Implementation

After approval:

- implement only the approved scope;
- preserve existing data unless deletion is explicitly approved;
- read existing files before modifying them;
- use reproducible versions and documented configuration;
- avoid committing secrets;
- update documentation when behavior or setup changes.

For infrastructure work, keep local resource usage aligned with the approved limits. For Iteration 1, Spark workers are limited to one CPU core and 1 GB RAM each.

### 6. Verification

Verification must match the Definition of Done and should include, where applicable:

- static/configuration validation;
- unit or integration tests;
- Docker Compose configuration validation;
- container health checks;
- service connectivity checks;
- manual UI or notebook verification;
- persistence and restart checks;
- security and isolation checks.

A failed or unavailable test must be reported explicitly; it must not be presented as passing.

### 7. Completion Report

The completion report must include:

- summary of implemented work;
- changed files;
- commands and tests executed;
- pass/fail results;
- known limitations and risks;
- follow-up tasks.

Do not claim that a service or test was verified if it was not actually run.

## Approval and Status Model

Use the following conceptual states for significant tasks:

```text
DRAFT
  -> WAITING_FOR_CLARIFICATION
  -> READY_FOR_APPROVAL
  -> APPROVED
  -> IN_PROGRESS
  -> VERIFICATION
  -> DONE
```

If implementation cannot proceed because a required decision is missing, use `WAITING_FOR_CLARIFICATION`, not `IN_PROGRESS`.

## Iteration-Specific Verification

### Iteration 1

At minimum, verify:

- MinIO API and Console availability;
- MinIO administrator and student access configuration;
- Spark Master availability;
- registration of two Spark workers;
- worker CPU/RAM limits;
- JupyterLab access;
- PySpark-to-Spark connectivity;
- read from MinIO and write to MinIO;
- persistence after restart;
- reproducibility from a clean checkout.

### Iteration 2

At minimum, verify:

- access for 2–5 students;
- task discovery and submission;
- isolated Jupyter environments;
- student data separation;
- resource limits;
- instructor review flow;
- safe restart/recreation of one student environment.

### Iteration 3

At minimum, verify:

- authentication and authorization;
- automatic environment lifecycle;
- quotas and idle cleanup;
- backups;
- monitoring;
- deployment and rollback procedures.
