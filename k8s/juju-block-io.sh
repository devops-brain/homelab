#!/usr/bin/env bash

whoami
for i in `seq 1 30`
do
  sleep 5s
  echo ${i}
  echo $(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $2}' | sort | uniq)
  echo $(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $3}' | sort | uniq)
  until [ "$(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $3}' | sort | uniq | wc -l)" == "1" ]
  do
    until [ "$(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $3}' | sort | uniq)" == "idle" ]
    do
      until [ "$(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $2}' | sort | uniq | wc -l)" == "1" ]
      do
        until [ "$(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $2}' | sort | uniq)" == "active" ]
        do
          echo ${i}
          echo $(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $2}' | sort | uniq)
          echo $(juju status -m kube | grep 192.168. | grep '/' | grep -v 'default' | grep -v 'ubuntu' | awk '{print $3}' | sort | uniq)
          sleep 10s
        done
      done
    done
  done
done
