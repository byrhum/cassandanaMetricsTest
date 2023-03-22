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

Verify Cassandana Metric ${metric_name} increases by ${expected_increase}
    ${initial_metric}=  Get Value for Metric ${metric_name}
    ${expected_metric}=  Evaluate  ${initial_metric} + ${expected_increase}
    Verify Cassandana Metric ${metric_name} equals ${expected_metric}

Get Value for Metric ${metric_name}
    ${response}=  Get Metrics From Cassandana
    ${match}=  Should Match Regexp    ${response}    \\b(?=\\w)${metric_name}\\s\\d+\\.\\d+
    ${return_value}=  Get Value From Metric Value Pair  ${match}
    [Return]  ${return_value}

Verify Metrics Increase On Connect
    ${metric_increase}=  Set Variable  1.0
    ${initial_metric}=  Get Value For Metric mqttHandleMessageConnect_total
    ${expected_metric}=  Evaluate  ${initial_metric} + ${metric_increase}
    Connect to MQTT server  ${HOST}  ${CLIENT_ID}
    Verify Cassandana Metric mqttHandleMessageConnect_total equals ${expected_metric}
    Disconnect From MQTT Server    

Connect To MQTT Server With NULL Client ID
    ${metric_increase}=  Set Variable  2.0
    ${initial_metric}=  Get Value For Metric mqttConnectionNullIdNotAllowed_total
    ${expected_metric}=  Evaluate  ${initial_metric} + ${metric_increase}
    Connect  ${HOST}  client_id=

Connect to MQTT Server With Clean Session False and NULL Client ID
    ${metric_name}=  Set Variable  mqttConnectionNullIdNotAllowed_total
    ${metric_increment}=  Set Variable  1
    ${initial_metric}=  Get Value for Metric ${metric_name}
    ${expected_metric}=  Evaluate  ${initial_metric} + ${metric_increment}

    Connect  ${HOST}  client_id=  clean_session=${false}
    Verify Cassandana Metric ${metric_name} equals ${expected_metric}

Connect to MQTT Server With Clean Session True and NULL Client ID
    ${metric_name}=  Set Variable  mqttConnectionClientIdGenerated_total
    ${metric_increment}=  Set Variable  1
    ${initial_metric}=  Get Value for Metric ${metric_name}
    ${expected_metric}=  Evaluate  ${initial_metric} + ${metric_increment}

    Connect  ${HOST}  client_id=  clean_session=${true}
    Verify Cassandana Metric ${metric_name} equals ${expected_metric}

Connect to MQTT server
    [Arguments]    ${server_ip}  ${client_id}=""
    Connect    ${server_ip}  client_id=${client_id}

Disconnect from MQTT server
    Disconnect