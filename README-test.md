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
```
.\testrunner.bat
```

Or manual:
```
py -m pipenv sync
py -m pipenv run python -m Browser.entry init
py -m pipenv run robot -P "%CD%" -d results --listener listeners.auto_artifacts.AutoArtifacts:results/failures tests
```

## Run subsets
```
:: Only UI
py -m pipenv run robot -P "%CD%" -d results -s ui tests

:: Only API (disable TLS verify if your network intercepts)
py -m pipenv run robot -P "$PWD" -d results -s ui --variable HEADLESS:False tests
```

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
- Uploads Robot results as artifacts for API, UI, and Trace jobs.
- Set `PYTHONPATH` to repo root so `listeners.*` and `libs.*` are importable.
- Add a README badge:
  ```md
  ![Robot CI](https://github.com/<org-or-user>/<repo>/actions/workflows/robot-ci.yml/badge.svg)
  ```

## Troubleshooting
- `ModuleNotFoundError: listeners/libs` → ensure empty `__init__.py` files and run Robot with `-P "%CD%"` (or set `PYTHONPATH`).
- `Open Context And Page not found` → the top-level `tests/__init__.robot` sets Test Setup; make sure file and path are correct.
- API TLS warnings → run API with `--variable VERIFY_TLS:${FALSE}` or configure your corporate CA.
