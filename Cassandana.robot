*** Settings ***
Documentation    Main test suite for Cassanda Functional Tests
Resource    Cassandana.resource

*** Test Cases ***

Cassandana MQTT Broker Is Exposing Metrics
    Get metrics from cassandana

Casssandana Has A Metric For mqttConnectionAttempts
    Verify Cassandana Has Metric  mqttServerInitialized_total
