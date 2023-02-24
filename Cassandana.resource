*** Settings ***
Documentation    Resource file for Cassanada.robot
Library    RequestsLibrary
Library    Collections
Library    String

*** Keywords ***
Make An HTTP Post Request
    [Arguments]    ${server_ip}    ${port}    ${path}
    ${response}=    GET    http://${server_ip}:${port}${path}
    [return]  ${response.text}

Get Metrics From Cassandana
    ${response}=  Make An HTTP Post Request    192.168.1.100    9044    /metrics
    [return]  ${response}

Verify Metric Exists In Response
    [Arguments]    ${metric_name}
    ${response}=  Get Metrics From Cassandana
    ${matched}=  Should Match Regexp    ${response}  ^|\\n${metric_name}\\s
    Log  ${matched}

Verify Cassandana Has Metric
    [Arguments]    ${metric_name}
    Verify Metric Exists In Response  ${metric_name}


