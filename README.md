# homelab
TODO:  add more status icons (shields)

![](https://img.shields.io/badge/juju-2.0+-brightgreen.svg)

## Overview
This is my private repo for my homelab.
I'd like to be able to make this public, but at this time my secrets management infra is ont ready...

## Usage
Everything in my homelab should be automated, as I don't have time to run everything as a sysadmin would.

I'm using Github, Jenkins, and Dockerhub currently.  
I'm considering adding Azure Keyvault into the infrastructure.


## Current known issues
1. PXE boot is not operating reliably.  It appears to be nic to transceiver issues.
2. juju's ceph and k8s charms are not currently compatible.  With my budget limitations and homelab scale, hosting multiple services per node is critical.
3. secrets management is not yet configured outside of the legacy salt infrastructure.

