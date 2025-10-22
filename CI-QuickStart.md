# CI Quick Start — Robot Framework + Playwright (GitHub Actions)

This guide shows how to run your Robot + Browser (Playwright) tests in **GitHub Actions** (no Jenkins needed).

## 1) Prereqs
- A GitHub account
- VS Code with extensions:
  - **GitHub Actions** (by GitHub)
  - **GitHub Pull Requests and Issues** (optional)

## 2) Push this project to GitHub
1. Open folder in VS Code.
2. Initialize Git & commit:
   ```bash
   git init
   git add .
   git commit -m "Init Robot + Playwright with CI"
   ```
3. Create repo and push:
   ```bash
   gh repo create <your-repo-name> --private --source=. --push
   # or use VS Code "Publish Branch"
   ```

## 3) What the workflow does
File: `.github/workflows/ci.yml`
- **API job**: installs with `pipenv`, runs `tests/api`, uploads `results/api` as artifact.
- **UI job**: installs Playwright browsers, runs UI suites (headed via `xvfb-run` on Linux),
  uploads artifacts under `results/ui-*` (with videos/traces if enabled).

View progress in the repo’s **Actions** tab. Click a run → download artifacts (contains `log.html` etc.).

## 4) Run locally (sanity check)
```bash
py -m pipenv sync
py -m pipenv run python -m Browser.entry init
py -m pipenv run robot -d results tests
```

## 5) Configure variables (optional)
Set browser/headless from the CLI (and in CI):
```bash
py -m pipenv run robot --variable BROWSER:chromium --variable HEADLESS:${TRUE} -d results tests
```
In `tests/__init__.robot` you can define defaults:
```robot
*** Variables ***
${BROWSER}   chromium
${HEADLESS}  ${TRUE}
```

## 6) Secrets (if your tests need them)
- Add under **GitHub → Repo → Settings → Secrets and variables → Actions**:
  - Example: `BASE_URL`, `API_TOKEN`, etc.
- Reference in workflow with `${{ secrets.API_TOKEN }}` or pass to Robot:
  ```yaml
  - name: Run
    run: pipenv run robot --variable API_TOKEN:${{ secrets.API_TOKEN }} -d results tests
  ```

## 7) Matrix (optional, run multiple browsers/OSes)
Add a matrix to `ci.yml` to run Chromium/Firefox/WebKit (and/or Windows/Ubuntu).
Example snippet:
```yaml
strategy:
  fail-fast: false
  matrix:
    browser: [chromium, firefox, webkit]
# In run step:
# --variable BROWSER:${{ matrix.browser }}
```

## 8) Artifacts & retention
- Artifacts contain `log.html`, videos, traces.
- Default retention is ~90 days (can be changed at organization/repo level).

## 9) Common issues
- **Playwright init fails**: corporate proxy/firewall → try again or configure proxy.
- **Headed tests on Linux**: we use `xvfb-run`. If you force headless, set `--variable HEADLESS:${TRUE}`.
- **Pipenv lock errors**: delete `Pipfile.lock` and re-run `pipenv lock` locally, then push.

Happy testing!
