#!/bin/bash

RELEASE_NAME=unit-test

helm template ../charts --namespace k8s-prometheus-dev \
--name-template ${RELEASE_NAME} \
-f test-values.yaml \
--debug
