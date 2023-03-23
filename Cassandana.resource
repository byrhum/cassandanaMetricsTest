*** Settings ***
Documentation    Resource file for Cassanada.robot
Library    RequestsLibrary
Library    MQTTLibrary
Library    Collections
Library    String
Library    Helper.py

*** Variables ***
${HOST}         192.168.1.100
${MQTT_PORT}    9044
${METRIC_PATH}  /metrics
${CLIENT_ID}    test_client

*** Keywords ***
Make An HTTP Post Request For Metric Scrape
    ${response}=    GET    http://${HOST}:${MQTT_PORT}${METRIC_PATH}
    [return]  ${response.text}

Get Metrics From Cassandana
    ${response}=  Make An HTTP Post Request For Metric Scrape
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

Verify metric ${metric_name} on client connect with client id ${client_id}
    ${initial_metric}=  Get Value for Metric ${metric_name}
    ${expected_metric}=  Evaluate  ${initial_metric} + 1

    Connect  ${HOST}  client_id=${client_id}  clean_session=${true}
    Verify Cassandana Metric ${metric_name} equals ${expected_metric}

Connect to MQTT server
    [Arguments]    ${server_ip}  ${client_id}=${EMPTY}
    Connect    ${server_ip}  client_id=${client_id}

Disconnect from MQTT server
    Disconnect