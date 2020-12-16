#!/usr/bin/env bash



for i in `seq 1 15`
do
  sleep 1s
  until [ "$(juju show-status kubernetes-master/0 | grep kubernetes-master/0 | awk '{print $2}')" = "active" ]
  do
    sleep 1s
  done
done
