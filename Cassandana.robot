*** Settings ***
Documentation    Main test suite for Cassanda Functional Tests
Resource    Cassandana.resource

*** Test Cases ***

Cassandana MQTT Broker Is Exposing Metrics
    Get metrics from cassandana

Casssandana Has A Metric For mqttConnectionAttempts
    Verify Cassandana Has Metric  mqttServerInitialized_total

Cassandana mqttServerInitialized_total is initialized with the correct value
    Verify Cassandana Metric mqttServerInitialized_total equals 0.0
