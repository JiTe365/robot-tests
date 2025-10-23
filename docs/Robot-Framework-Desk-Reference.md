# Robot Framework — Desk Reference (Diagrams + Legends)

Use this one-pager while working with Robot Framework + Browser (Playwright). It contains three visuals:
1) Flow of references in a single `testsuite.robot`
2) Architecture / dependencies (repo & tools)
3) Runtime communication for “My First Test”

> Tip: Most editors (VS Code) can render Mermaid or export this Markdown to PDF for printing.

---

## 1) Flow of references (your `testsuite.robot`)
```mermaid
flowchart LR
    A["A: Test Suite file (.robot)\n— contains Settings, Variables, Keywords, Test Cases"]
    ST["ST: *** Settings ***\n— imports & config"]
    SV["SV: *** Variables ***\n— shared values"]
    SK["SK: *** Keywords ***\n— custom reusable steps"]
    SC["SC: *** Test Cases ***\n— executable scenarios"]

    L["L: Libraries (e.g., Browser)"]
    R["R: Resource files (.robot/.resource)"]
    VF["VF: Variable files (.py/.yaml/.robot)"]
    RK["RK: Keywords from resource files"]
    RV["RV: Variables from resource files"]
    LK["LK: Keywords provided by libraries"]

    A --> ST
    A --> SV
    A --> SK
    A --> SC

    ST -->|import| L
    ST -->|import| R
    ST -->|import| VF

    R --> RK
    R --> RV
    L --> LK

    SC -->|calls| SK
    SC -->|calls| RK
    SC -->|calls| LK
    SC -->|uses| SV
    SC -->|uses| RV

    SK -->|calls| LK
    SK -->|calls| RK
    SK -->|uses| SV
    SK -->|uses| RV

    VF -->|provides| SV
```

---

## 2) Architecture / dependencies (your repo & tools)
```mermaid
flowchart TB
  WS["WS: Windows Shell\n— runs testrunner.bat"]
  BAT["BAT: testrunner.bat\n— orchestrates pipenv + robot"]
  
  subgraph RT["RT: Project Root (C:\\robot-tests)"]
    PF["PF: Pipfile\n— dependency spec"]
    SUITE["SUITE: tests\\*.robot\n— your test suites"]
    INIT["INIT: tests\\__init__.robot\n— shared setup/teardown"]
    RES["RES: results\\\n— log.html, report.html"]
  end

  subgraph PE["PE: Pipenv Virtualenv"]
    PIPENV["PIPENV: pipenv\n— resolves & installs"]
    PKG["PKG: Packages\n— robotframework, robotframework-browser, pabot"]
    DL["DL: Browser.entry init\n— downloads Playwright browsers"]
  end

  subgraph PW["PW: Playwright Runtime"]
    DRV["DRV: Playwright driver"]
    BROW["BROW: Chromium/Firefox/WebKit"]
  end

  WEB["WEB: System Under Test (e.g., https://playwright.dev/)"]

  WS --> BAT
  BAT -->|sync/install| PIPENV
  PIPENV -->|reads| PF
  PIPENV -->|installs| PKG
  BAT -->|pipenv run python -m Browser.entry init| DL
  DL --> DRV

  BAT -->|pipenv run robot -d results tests| SUITE
  INIT --> SUITE
  SUITE -->|imports| PKG
  SUITE -->|calls keywords| DRV
  DRV -->|launch| BROW
  BROW -->|navigate| WEB
  SUITE --> RES
```

---

## 3) Runtime communication (your “My First Test”)
```mermaid
sequenceDiagram
  participant WS as WS: Windows Shell
  participant BAT as BAT: testrunner.bat
  participant PIP as PIP: pipenv (venv)
  participant ROB as ROB: robot (runner)
  participant ST as ST: testsuite.robot
  participant LIB as LIB: Browser (Robot lib)
  participant PW as PW: Playwright driver
  participant BR as BR: Browser (Chromium)
  participant SUT as SUT: Site (playwright.dev)

  WS->>BAT: Start
  BAT->>PIP: sync/install from Pipfile
  BAT->>PIP: run python -m Browser.entry init
  PIP->>PW: ensure drivers/browsers

  BAT->>ROB: run robot -d results tests
  ROB->>ST: parse & load suite
  ST->>LIB: import Browser

  Note over ST: New Browser chromium headless=False<br/>New Context<br/>New Page https://playwright.dev/<br/>Get Title → Should Contain "Playwright"
  ST->>LIB: New Browser
  LIB->>PW: launch chromium
  PW->>BR: start process

  ST->>LIB: New Page https://playwright.dev/
  LIB->>PW: context.new_page + page.goto(url)
  PW->>BR: open tab & navigate
  BR->>SUT: GET /
  SUT-->>BR: HTML/CSS/JS

  ST->>LIB: Get Title
  LIB->>PW: page.title()
  PW-->>LIB: "Playwright"
  ST->>ROB: assertion passes
  ROB-->>BAT: write results/log.html & report.html
```

---

## Legends (abbreviations used above)

### General
- **WS** — Windows Shell (PowerShell/CMD)
- **BAT** — `testrunner.bat` (your batch runner)
- **PIP** / **PIPENV** — pipenv virtual environment/command
- **PF** — Pipfile (dependency spec)
- **PKG** — Installed packages (e.g., `robotframework`, `robotframework-browser`)
- **DL** — `Browser.entry init` step (downloads Playwright browsers)
- **PW** — Playwright driver (core engine used by Browser library)
- **BR / BROW** — Actual browser process (Chromium/Firefox/WebKit)
- **WEB / SUT** — System Under Test (your application/website)
- **RES** — results directory (`log.html`, `report.html`)

### Suite internals
- **A** — (not used as a node ID here) *Test Suite file as a whole*
- **ST** — `*** Settings ***` section (imports & configuration) **/ or** `testsuite.robot` in sequence diagram context label
- **SV** — `*** Variables ***` section
- **SK** — `*** Keywords ***` section (your custom keywords)
- **SC** — `*** Test Cases ***` section (your tests)
- **L** — Libraries (e.g., `Browser`)
- **R** — Resource files (`.robot` / `.resource` providing keywords/vars)
- **RK** — Keywords from resource files
- **RV** — Variables from resource files
- **VF** — Variable files (`.py`/`.yaml`/`.robot` providing data)
- **LK** — Keywords provided by libraries (e.g., `New Page`, `Get Title`)
- **INIT** — `__init__.robot` (directory-level suite config)

---

## Minimal working snippets (reference)

**tests\\__init__.robot**
```robot
*** Settings ***
Library         Browser
Suite Setup     New Browser    chromium    headless=${FALSE}
Suite Teardown  Close Browser
Test Setup      New Context    viewport={"width":1280, "height":800}
```

**tests\\testsuite.robot**
```robot
*** Settings ***
Library    Browser

*** Test Cases ***
My First Test
    New Page    https://playwright.dev/
    ${title}=   Get Title
    Should Contain    ${title}    Playwright
```
