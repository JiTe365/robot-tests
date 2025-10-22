*** Settings ***
Library         Browser
Suite Setup     New Browser    ${BROWSER}    headless=${HEADLESS}
Suite Teardown  Close Browser
Test Setup      Run Keywords    New Context    viewport={"width":1280, "height":800}    AND    New Page    about:blank

*** Variables ***
${BROWSER}      chromium
${HEADLESS}     ${TRUE}
# Optionally override Auth.resource default:
# ${BASE_URL}     https://www.saucedemo.com
 