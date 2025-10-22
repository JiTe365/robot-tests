*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${DEFAULT_TIMEOUT}    10
${RETRY_TIMES}        3
${RETRY_SLEEP}        0.5
${VERIFY_TLS}         ${TRUE}

*** Keywords ***
Create API Session
    [Arguments]    ${alias}    ${base_url}    ${headers}={}
    Create Session    ${alias}    ${base_url}
    ...    headers=${headers}
    ...    timeout=${DEFAULT_TIMEOUT}
    ...    verify=${VERIFY_TLS}

GET JSON
    [Arguments]    ${alias}    ${path}    ${expected_status}=200
    ${resp}=    GET On Session    ${alias}    ${path}
    Should Be Equal As Integers    ${resp.status_code}    ${expected_status}
    # httpbin /status/200 has no body; only parse when there is one
    ${body}=    Set Variable    ${resp.text}
    IF    '${body}' != ''
        ${data}=    Call Method    ${resp}    json
    ELSE
        ${data}=    Create Dictionary    status=${resp.status_code}
    END
    RETURN    ${data}

POST JSON
    [Arguments]    ${alias}    ${path}    ${payload}    ${expected_status}=200
    ${resp}=    POST On Session    ${alias}    ${path}    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    ${expected_status}
    ${data}=    Call Method    ${resp}    json
    RETURN    ${data}

GET With Retry
    [Arguments]    ${alias}    ${path}    ${expected_status}=200
    :FOR    ${i}    IN RANGE    ${RETRY_TIMES}
    \    ${ok}    ${json}=    Run Keyword And Ignore Error    GET JSON    ${alias}    ${path}    ${expected_status}
    \    Run Keyword If    '${ok}'=='PASS'    Return From Keyword    ${json}
    \    Sleep    ${RETRY_SLEEP}
    Fail    GET ${path} failed ${RETRY_TIMES} times
