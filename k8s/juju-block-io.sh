#!/usr/bin/env bash


for i in `seq 1 15`
do
  sleep 1s
  #echo ${i}
  #echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq | wc -l)
  #echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq)
  until [ "$(juju status | grep 192.168. | grep '/' | grep -v 'default' | awk '{print $3}' | sort | uniq | wc -l)" == "1" ]
  do
    until [ "$(juju status | grep 192.168. | grep '/' | grep -v 'default' | awk '{print $3}' | sort | uniq)" == "idle" ]
    do
      until [ "$(juju status | grep 192.168. | grep '/' | grep -v 'default' | awk '{print $2}' | sort | uniq | wc -l)" == "1" ]
      do
        until [ "$(juju status | grep 192.168. | grep '/' | grep -v 'default' | awk '{print $2}' | sort | uniq)" == "active" ]
        do
          #echo $(juju status | grep 192.168. | grep '/' | awk '{print $2}' | sort | uniq)
          #echo $(juju status | grep 192.168. | grep '/' | awk '{print $3}' | sort | uniq)
          sleep 1s
        done
      done
    done
  done
done
