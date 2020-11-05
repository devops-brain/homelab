# My homelab ceph cluster
TODO:  add more/correct status icons (shields)

![](https://img.shields.io/badge/juju-2.0+-brightgreen.svg)

## Overview
This is the second ceph cluster infra code I'm trying out in 2020.  It uses Ceph on K8s.
It is running on my homelab k8s hardware.
Storage is one place where it can be more cost effective to run your own hardware than to use a cloud service, so long as the electricity rates are not too bad.

The juju charms can not colocate k8s workers and ceph osds, which with my hardware would leave a lot of storage or cpu un used.
Since this is an IaC lab and I don't like manual steps, I'm using the helm to deploy rook into k8s.
This depends on the k8s infra code being deployed already.

Instruction page:  https://rook.io/docs/rook/v1.4/helm-operator.html

## Usage
Run the Jenkins job, or read it and run commands manually if you're against automation making life better  ;)

## Note
The .kube/config file must be loaded into the saltmaster manually before this can work
