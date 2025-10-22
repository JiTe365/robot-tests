*** Settings ***
Library    Browser
Resource   ../../resources/pages/Auth.resource

*** Variables ***
${VALID_USER}    standard_user
${VALID_PASS}    secret_sauce

*** Test Cases ***
Login happy path (ui)
    Login As       ${VALID_USER}    ${VALID_PASS}
    Assert Logged In

Login error shows toast (ui)
    Open Login Page
    Fill Credentials    ${VALID_USER}    wrong
    Click    ${SUBMIT_BTN}
    Wait For Elements State    ${TOAST_ERROR}    visible    timeout=${WAIT}
