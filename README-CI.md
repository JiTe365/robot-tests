# CI Quick Start

This repo includes a ready-to-run GitHub Actions pipeline at
`.github/workflows/robot-ci.yml`.

## Steps
1. Create a new GitHub repo and push this project.
2. Actions will run on push/PR; or trigger manually via **Run workflow**.
3. Download HTML logs and artifacts from each job.

## Local vs CI differences
- CI uses `xvfb-run` for Browser UI runs on Ubuntu.
- We set `PYTHONPATH` to the repo so `listeners.*` and `libs.*` import without `-P`.
- If your CI network MITMs TLS, for API jobs you may set:
  ```yaml
  env:
    ROBOT_OPTIONS: '--variable VERIFY_TLS:${FALSE}'
  ```
