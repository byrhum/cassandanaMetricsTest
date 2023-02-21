*** Settings ***
Documentation    Resource file for Cassanada.robot
Library    RequestsLibrary

*** Keywords ***
Make an HTTP Request
    [Arguments]    ${server_ip}    ${port}
    ${response}=    POST    http://${server_ip}:${port}/metrics
