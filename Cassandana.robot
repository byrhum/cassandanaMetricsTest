*** Settings ***
Documentation    Main test suite for Cassanda Functional Tests
Resource    Cassandana.resource

*** Test Cases ***

Cassandana MQTT Broker Is Exposing Metrics
    Get metrics from cassandana

Casssandana Has A Metric For mqttConnectionAttempts
    Verify Cassandana Has Metric mqttServerInitialized_total

Cassandana metrics are initialized with the correct values
    Verify Cassandana Metric mqttServerInitialized_total equals 1.0
    Verify Cassandana Metric mqttHandleMessageConnect_total equals 0.0
    Verify Cassandana Metric mqttHandleMessage_total equals 0.0
    Verify Cassandana Metric mqttConnectionNullIdNotAllowed equals 0.0

Cassandana metric for mqttConnectionAttempts_total is increased on MQTT connect
    Verify Metrics Increase On Connect

