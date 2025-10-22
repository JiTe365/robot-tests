*** Settings ***
Library    Browser

*** Test Cases ***
My First Test
    New Page    https://playwright.dev/
    ${title}=   Get Title
    Should Contain    ${title}    Playwright
    