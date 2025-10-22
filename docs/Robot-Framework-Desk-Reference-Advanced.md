# Robot Framework — Desk Reference (Advanced, Complete)
(See HTML for diagrams.)

## Stack
- Robot Framework 7 (Python 3.13)
- Browser (Playwright) for UI
- RequestsLibrary for API
- Python custom libraries & listeners
- Pipenv + Windows-friendly runner

## Key commands (Windows)
```
.	estrunner.bat
```
or
```
py -m pipenv run python -m Browser.entry init
py -m pipenv run robot -P "%CD%" -d results --listener listeners.auto_artifacts.AutoArtifacts:results/failures tests
```

## Troubleshooting
- Add empty `listeners/__init__.py` and `libs/__init__.py`
- Use `-P "%CD%"` to expose repo root on PYTHONPATH
- For httpbin TLS warnings, run API with `--variable VERIFY_TLS:${FALSE}`
