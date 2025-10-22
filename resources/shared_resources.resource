*** Settings ***
Documentation     Description of shared keywords and variables.
Library           BuiltIn
Library           OperatingSystem

*** Variables ***
${DEVICE_IP}     192.168.1.100
@{PORTS}         22 23

*** Keywords ***
Connect To Device
    [Arguments]    ${ip}=${DEVICE_IP}    ${port}=${PORTS}:[0]
    Open Connection    ${ip}    ${port}

Capture Logs
    [Arguments]    ${dest}=${EXECDIR}/logs
    Create Directory    ${dest}
    Copy File    ${REMOTE_LOG_PATH}    ${dest}/${TEST NAME}.log
