*** Settings ***
Library    Browser
Library    Collections
Library    String

*** Variables ***
${BASE_URL}          https://www.saucedemo.com        # <— default so import never fails
${LOGIN_URL}         ${BASE_URL}
${USER_FIELD}        id=user-name
${PASS_FIELD}        id=password
${SUBMIT_BTN}        id=login-button
${TOAST_ERROR}       [data-test="error"]
${SUCCESS_MARKER}    [data-test="title"]              # shows “Products” after login

${WAIT}              10s
${RETRY_TIMEOUT}     25s
${RETRY_INTERVAL}    500ms

*** Keywords ***
Open Login Page
    Go To    ${LOGIN_URL}
    Wait For Elements State    ${USER_FIELD}    visible    timeout=${WAIT}

Fill Credentials
    [Arguments]    ${username}    ${password}
    Clear Text    ${USER_FIELD}
    Fill Text     ${USER_FIELD}    ${username}
    Clear Text    ${PASS_FIELD}
    Fill Text     ${PASS_FIELD}    ${password}

Submit Login
    Click         ${SUBMIT_BTN}
    Wait Until Keyword Succeeds    ${RETRY_TIMEOUT}    ${RETRY_INTERVAL}
    ...    Run Keyword    _Wait For Login Result

_Wait For Login Result
    ${ok}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${SUCCESS_MARKER}    visible    timeout=1s
    Run Keyword If    ${ok}    Return From Keyword
    ${has_err}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${TOAST_ERROR}    visible    timeout=1s
    Run Keyword If    ${has_err}
    ...    Fail    Login failed: ${TOAST_ERROR} visible after submit
    Fail    Not ready

Login As
    [Arguments]    ${username}    ${password}
    Open Login Page
    Fill Credentials    ${username}    ${password}
    Submit Login

Assert Logged In
    Wait For Elements State    ${SUCCESS_MARKER}    visible    timeout=${WAIT}
    
Submit Login Expecting Error
    Click    ${SUBMIT_BTN}
    Wait For Elements State    ${TOAST_ERROR}    visible    timeout=${WAIT}
