# Robot Tests — Complete
A production-style Robot Framework project that runs **UI (Playwright)**, **API (RequestsLibrary)**, and **trace/video** demos locally and in **GitHub Actions**.

## What's included
- Robot Framework 7 (Python 3.13), Browser (Playwright), RequestsLibrary, pabot
- Windows-friendly runner (`testrunner.bat`) with local Pipenv `.venv`
- Safe failure screenshot listener (`listeners/auto_artifacts.py`)
- Python custom library example (`libs/datastore.py`)
- Resource modules for UI (`resources/pages/Auth.resource`) and API (`resources/api/RestClient.robot`)
- CI workflow: `.github/workflows/robot-ci.yml`
- Desk reference: `docs/Robot-Framework-Desk-Reference-Advanced.(md|html)`

## Quick start (Windows)
```bat
.\testrunner.bat
```

Or run manually (Windows):
```bat
py -m pipenv sync
py -m pipenv run python -m Browser.entry init
py -m pipenv run robot -P "%CD%" -d results --listener listeners.auto_artifacts.AutoArtifacts:results/failures tests
```

POSIX (macOS/Linux) equivalent:
```bash
python -m pipenv sync
python -m pipenv run python -m Browser.entry init
python -m pipenv run robot -P "$PWD" -d results --listener listeners.auto_artifacts.AutoArtifacts:results/failures tests
```

## Run subsets
Windows:
```bat
:: Only UI
py -m pipenv run robot -P "%CD%" -d results -s ui tests

:: Only API
py -m pipenv run robot -P "%CD%" -d results -s api tests
```

POSIX:
```bash
# Only UI
python -m pipenv run robot -P "$PWD" -d results -s ui tests

# Only API
python -m pipenv run robot -P "$PWD" -d results -s api tests
```

> Note: If your network intercepts TLS, disable verify via a test variable your suite supports (e.g., `--variable VERIFY_SSL:False`) or configure a CA bundle.

## Project layout
```
.
├─ Pipfile
├─ testrunner.bat
├─ listeners/
├─ libs/
├─ resources/
├─ tests/
└─ docs/
```

## CI (GitHub Actions)
- Workflow at `.github/workflows/robot-ci.yml`
- Uploads Robot results as artifacts for API, UI, and Trace jobs
- Sets `PYTHONPATH` to repo root so `listeners.*` and `libs.*` are importable
- Add a README badge:
  ```markdown
  ![Robot CI](https://github.com/<org-or-user>/<repo>/actions/workflows/robot-ci.yml/badge.svg)
  ```

## Troubleshooting
- `ModuleNotFoundError: listeners` or `ModuleNotFoundError: libs`
  - Ensure `__init__.py` exists where needed (package discovery)
  - Run Robot with `-P "%CD%"` (Windows) or `-P "$PWD"` (POSIX), or set `PYTHONPATH` to the repo root
