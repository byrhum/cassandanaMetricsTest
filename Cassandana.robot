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
    Verify Cassandana Metric mqttConnectionNullIdNotAllowed_total equals 0.0
    Verify Cassandana Metric mqttConnectionClientIdGenerated_total equals 0.0
    Verify Cassandana Metric mqttConnectionSessionBindAttempt_total equals 0.0

Cassandana metric for mqttConnectionAttempts_total is increased on MQTT connect
    Verify Metrics Increase On Connect

Cassandana metric for mqttConnectionNullIdNotAllowed_total is increased
    Connect To MQTT Server With NULL Client ID
    Disconnect from MQTT Server

Cassandana metric for mqttConnectionSessionBindAttempt_total is increased with client connect
    Verify metric mqttConnectionSessionBindAttempt_total on succesful client connect

#  This test requires configuration allow_zero_byte_client_id: yes.
#
#Cassandana metric for mqttConnectionClientIdGenerated_total is increased
#    Connect to MQTT Server With Clean Session True and NULL Client ID
#    Disconnect from MQTT Server


