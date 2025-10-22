*** Settings ***
Library         Browser

*** Variables ***
${BROWSER}   chromium
${HEADLESS}  ${TRUE}

*** Test Cases ***
Playwright title shows correctly
    Given a browser is open
    When I open "https://playwright.dev/"
    Then the title contains "Playwright"

*** Keywords ***
a browser is open
    New Browser    ${BROWSER}    headless=${HEADLESS}
    New Context    viewport={"width":1280, "height":800}

I open "${url}"
    New Page    ${url}

the title contains "${text}"
    ${title}=    Get Title
    Should Contain    ${title}    ${text}    