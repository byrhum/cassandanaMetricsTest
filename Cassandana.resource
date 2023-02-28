*** Settings ***
Documentation    Resource file for Cassanada.robot
Library    RequestsLibrary
Library    MQTTLibrary
Library    Collections
Library    String
Library    Helper.py

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

Verify Cassandana Has Metric
    [Arguments]    ${metric_name}
    Verify Metric Exists In Response  ${metric_name}

Verify Cassandana Metric ${metric_name} equals ${expected_metric_value}
    ${expected_metric_regex}=  get regex for metric value  ${expected_metric_value}
    ${response}=  Get Metrics From Cassandana
    Log to console  "Expected regex ${expected_metric_regex}"
    ${match}=    Should Match Regexp    ${response}    \\b(?=\\w)${metric_name}\\s${expected_metric_regex}
    Log To Console    MATCH ${match} \n

Connect to MQTT server
    [Arguments]    ${server_ip}
    Connect    ${server_ip}

Disconnect from MQTT server
    Disconnect
