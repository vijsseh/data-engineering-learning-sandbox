Project Sandbox

Short description

A small web-service project with a Node.js backend and a minimal frontend. This repo contains the project scaffold, agent definitions, and an initial task vault to coordinate design, scaffold, and docs work.

Getting started

Prerequisites
- Node.js 18+ (or current LTS)
- npm or pnpm

Quick start
1. Clone the repo (if remote):
   git clone <repo-url>
2. Install dependencies:
   npm install
3. Create environment file:
   cp .env.example .env
   Edit .env with required values.
4. Run the development server:
   npm run dev

Running tests
- Unit tests: npm test
- Add a test runner (Jest/Mocha) to package.json and use npm test to run the suite.

Development workflow
- Branching:
  - Use feature/* for new features (e.g. feature/auth-signup)
  - Use fix/* for bug fixes
  - Use chore/* for non-functional changes (docs, tooling)
- Commit messages:
  - Use concise, imperative messages. Prefix with type when helpful: feat:, fix:, docs:, chore:
  - Example: feat(auth): add JWT refresh token flow
- Pull requests:
  - Link to relevant task(s) in the description and include testing steps
- Local checks before push:
  - npm run lint
  - npm test

Where to find things
- Agents and their roles: agents.md
- Tasks and project plan: vault/

