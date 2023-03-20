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

Verify Cassandana Has Metric ${metric_name}
    Verify Metric Exists In Response  ${metric_name}

Verify Cassandana Metric ${metric_name} equals ${expected_metric_value}
    ${metric_as_string}=  convert to string  ${expected_metric_value}
    ${expected_metric_regex}=  get regex for metric value  ${metric_as_string}
    ${response}=  Get Metrics From Cassandana
    ${match}=    Should Match Regexp    ${response}    \\b(?=\\w)${metric_name}\\s${expected_metric_regex}

Get Value for Metric ${metric_name}
    ${response}=  Get Metrics From Cassandana
    ${match}=  Should Match Regexp    ${response}    \\b(?=\\w)${metric_name}\\s\\d+\\.\\d+
    ${return_value}=  Get Value From Metric Value Pair  ${match}
    [Return]  ${return_value}

Verify Metrics Increase On Connect
    ${metric_increase}=  Set Variable  2.0
    ${initial_metric}=  Get Value For Metric mqttHandleMessageConnect_total
    ${expected_metric}=  Evaluate  ${initial_metric} + ${metric_increase}
    Connect to MQTT server  192.168.1.100
    Verify Cassandana Metric mqttHandleMessageConnect_total equals ${expected_metric}
    Disconnect From MQTT Server    

Connect to MQTT server
    [Arguments]    ${server_ip}
    Connect    ${server_ip}

Disconnect from MQTT server
    Disconnect