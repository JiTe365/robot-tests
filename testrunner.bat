@echo off
setlocal
cd /d %~dp0

REM Create the venv inside the project (avoid profile/OneDrive locks)
set PIPENV_VENV_IN_PROJECT=1
set PIPENV_IGNORE_VIRTUALENVS=1

REM Use your installed Python 3.13
py -m pip install --upgrade pip
py -m pip install --user pipenv==2024.0.1

REM Install from Pipfile / lock
py -m pipenv sync || py -m pipenv install

REM One-time: download Playwright browsers for Robot Browser lib
py -m pipenv run python -m Browser.entry init

REM Run Robot with repo root on PYTHONPATH and listener class
py -m pipenv run robot ^
  -P "%CD%" ^
  --listener listeners.auto_artifacts.AutoArtifacts:results/failures ^
  -d results ^
  tests

endlocal

