#!/usr/bin/env bash


for i in `seq 1 15`
do
  sleep 1s
  echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq | wc -l)
  echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq)
  until [ "$(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq | wc -l)" == "1" ]
  do
    echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq | wc -l)
    echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq)
    #until ["$(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq)" = "idle"]
    #do
    #  echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq | wc -l)
    #  echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq)
    sleep 1s
    #done
  done
done
