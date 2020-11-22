#!/usr/bin/env bash

until [ "$(juju show-status kubernetes-master/0 | grep kubernetes-master/0 | awk '{print $2}')" = "active" ]
do
  sleep 1m
done
