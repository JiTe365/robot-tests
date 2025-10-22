*** Settings ***
Resource   ../../resources/api/RestClient.robot

*** Variables ***
${BASE_URL}    https://httpbin.org

*** Test Cases ***
GET /status/200 returns 200
    Create API Session    api    ${BASE_URL}
    ${out}=    GET JSON    api    /status/200    200
    Should Be Equal As Integers    ${out}[status]    200

POST /anything echoes payload
    Create API Session    api    ${BASE_URL}
    ${payload}=    Create Dictionary    hello=world    answer=42
    ${out}=    POST JSON    api    /anything    ${payload}    200
    Dictionary Should Contain Item    ${out}[json]    hello    world
