*** Settings ***
Library         Browser
Suite Setup     Open Browser With Artifacts
Suite Teardown  Close Browser
Test Setup      New Traced Context
Test Teardown   Export Video And Close Context

*** Variables ***
${BROWSER}      chromium
${VIDEO_DIR}    ${OUTPUT DIR}${/}video
${TRACE_ZIP}    ${OUTPUT DIR}${/}trace.zip
${VIEWPORT}     {"width": 1280, "height": 800}

*** Keywords ***
Open Browser With Artifacts
    New Browser    ${BROWSER}    headless=${TRUE}

New Traced Context
    ${record}=    Create Dictionary    dir=${VIDEO_DIR}
    New Context    viewport=${VIEWPORT}    recordVideo=${record}
    New Page       about:blank
    Run Keyword And Ignore Error    Start Tracing    screenshots=${TRUE}    snapshots=${TRUE}

Export Video And Close Context
    ${status}    ${msg}=    Run Keyword And Ignore Error    Stop Tracing    path=${TRACE_ZIP}
    Close Context

*** Test Cases ***
Trace and Video Demo
    New Page    https://playwright.dev/
    ${title}=    Get Title
    Should Contain    ${title}    Playwright
