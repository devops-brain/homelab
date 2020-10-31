# My homelab ceph cluster
TODO:  add more status icons (shields)

![](https://img.shields.io/badge/juju-2.0+-brightgreen.svg)

## Overview
This is the ceph cluster infra code I'm trying out in 2020.  It uses Ceph on my MaaS cluster.
Storage is one place where it can be more cost effective to run your own hardware than to use a cloud service.

Juju has the advantage of doing all config and orchestration required to deploy complex services, using an IaC approach.
It ties into MaaS to provision the bare metal hosts, allowing me to try it out without having to deploy and enlist the hosts for each deployment being tested.
Plus as a nice feature the controller allows the service model to be shown visually, helping less technical people to better understand what's involved.

## Usage
This should be put into a jenkins job if the tooling is adopted.  

This first step is not idempotent, and would need to be in a strong conditional...
It assigns a name for the model and enlist hosts matching hardware needs.
Juju connecting to MaaS tends to try to pick VMs when KVM is configured, which would not work for this purpose.

    juju add-model ceph HomeLab
    juju model-config -m ceph default-series=focal
    juju add-machine -m ceph wired-clam.khoyi.io
    juju add-machine -m ceph fast-stag.khoyi.io
    juju add-machine -m ceph hairy-hyena.khoyi.io

These are the commands to 

    cd ~/Projects/homelab/ceph/juju
    git pull
    juju deploy -m ceph --map-machines=existing --dry-run ./bundle.yaml
    juju deploy -m ceph --map-machines=existing ./bundle.yaml

## Bootstrap juju into MaaS
This is currently setup on the saltmaster.  I'm not certain I'll end up keeping things that way...

install and download

    sudo snap install juju --classic
    mkdir ~/Projects
    cd ~/Projects
    git clone https://github.com/devops-brain/homelab.git
    
cache credentials, bad practice but acceptable shortcut in a homelab

    git config --global credential.helper store
    git pull
    
config juju

    echo '''clouds:
      HomeLab:
        type: maas
        auth-types: [oauth1]
        endpoint: http://192.168.76.4:5240/MAAS
    ''' > /tmp/maas.yaml
    juju add-cloud --local HomeLab /tmp/maas.yaml
    juju clouds
    echo '''credentials:
      HomeLab:
        HomeLab:
          auth-type: oauth1
          maas-oauth: << key grabbed from UI >>
    ''' > /tmp/juju.yaml
    juju add-credential HomeLab -f /tmp/juju.yaml
    juju credentials
    juju credentials --local
    juju clouds
    
deploy controller

    #juju bootstrap HomeLab homelab --bootstrap-series=focal --config autocert-dns-name=juju.khoyi.io --config default-series=focal
    juju bootstrap HomeLab homelab --bootstrap-series=focal --config default-series=focal
    juju gui

