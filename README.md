# homelab
TODO:  add more status icons (shields)

![](https://img.shields.io/badge/kubernetes-1.19-brightgreen.svg) ![](https://img.shields.io/badge/juju-2.0+-brightgreen.svg)

# Overview
This is my private repo for my homelab.
I'd like to be able to make this public, but at this time my secrets management infra is not ready...

## Stack
services managed with helm  
on kubernetes  
managed with juju  
on MaaS  

Helm and Juju should be pushed with jenkins jobs
Jenkins agent is setup on the saltmaster (which is also the juju and helm host) using salt.  

## Current known issues
1. PXE boot is not operating reliably.  It appears to be nic to transceiver issues.  This may be resolved now, 2 bad transceivers removed.
2. juju's ceph and k8s charms are not currently compatible.  With my budget limitations and homelab scale, hosting multiple services per node is critical.  attempting to use rook to resolve.
3. secrets management is not configured outside of the legacy salt infrastructure.
4. saltmaster is a singular critical control node created with some manual steps.
5. Jenkins depends on salt to push agents to key hosts, this should be migrated to ansible or removed as a dependency.

# Usage
Everything in my homelab should be automated, as I don't have time to run everything as a sysadmin would.
The one exception is bootstrap of MaaS and juju, as the automation tools depend on those tools.

I'm using Github, Jenkins, and Dockerhub currently.  
I'm considering adding Azure Keyvault into the infrastructure.

### Manually deploy and configure MaaS
The unifi router should be already setup, where it counts more as HomeProd.
Use Nuc5ppyh-01 on a port with all vlans enabled.  Apply the following contents to the netplan file:

    # This file is nuc5ppyh-01's network config, found in the homelab readme.
    network:
      version: 2
      renderer: networkd
      ethernets:
        enp2s0:
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses:
          - 192.168.0.4/22
          gateway4: 192.168.0.2
          match:
            macaddress: b8:ae:ed:ea:74:50
          nameservers:
            addresses:
            - 192.168.0.2
            - 192.168.0.4
            search:
            - khoyi.io
      vlans:
        enp2s0.4:
          id: 4
          link: enp2s0
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses: 
          - 192.168.4.4/24
        enp2s0.5:
          id: 5
          link: enp2s0
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses:
          - 192.168.5.4/24
        enp2s0.6:
          id: 6
          link: enp2s0
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses:
          - 192.168.6.4/24
        enp2s0.7:
          id: 7
          link: enp2s0
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses:
          - 192.168.7.4/24
          gateway4: 192.168.7.2
          nameservers:
            addresses:
            - 192.168.7.4
            search: 
            - khoyi.io
            - khoyi.us
        enp2s0.8:
          id: 8
          link: enp2s0
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses:
          - 192.168.8.4/22
          gateway4: 192.168.8.2
          nameservers:
            addresses:
            - 192.168.8.4
            search: 
            - khoyi.io
            - khoyi.us
        enp2s0.69:
          id: 69
          link: enp2s0
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses:
          - 192.168.69.4/24
        enp2s0.77:
          id: 77
          link: enp2s0
          mtu: 9000
          dhcp4: false
          dhcp6: false
          addresses:
          - 192.168.76.4/22
          nameservers:
            addresses:
            - 192.168.76.4
            search:
            - khoyi.io
            - khoyi.us

Then configure MaaS to provide dhcp4 on 7 and 77.  set dns domain to khoyi.io.  
Add lts images and all architectures.  
Add a juju user using a second email address to track which nodes are manually managed and what is owned by juju.  
deploy steady-coral as a kvm host, with all disks in raid0 as /.
We're here for speed not durability:  we can redeploy if a drive fails.

### Manually Bootstrap juju into MaaS
This is currently setup on the saltmaster.  I'm not certain I'll end up keeping things that way...
it wouldn't scale well in a corp env and is a SPoF, and I'd like to be able to port any code of mine to be re-used by my employeer.
This deployment is kept manual for now, as it is a run once and may be replaced before run again.

install and download

    sudo snap install juju --classic
    mkdir ~/Projects
    cd ~/Projects
    git clone https://github.com/devops-brain/homelab.git
    
cache credentials, bad practice but acceptable shortcut in a homelab

    git config --global credential.helper store
    git pull
    
config juju

    mkdir ~/tmp
    echo '''clouds:
      HomeLab:
        type: maas
        auth-types: [oauth1]
        endpoint: http://192.168.76.4:5240/MAAS
    ''' > ~/tmp/maas.yaml
    juju add-cloud --client HomeLab ~/tmp/maas.yaml
    juju clouds
    echo '''credentials:
      HomeLab:
        HomeLab:
          auth-type: oauth1
          maas-oauth: << key grabbed from UI >>
    ''' > ~/tmp/juju.yaml
    juju add-credential HomeLab -f ~/tmp/juju.yaml
    juju credentials
    juju clouds
    rm -rfv ~/tmp

deploy controller

    #juju bootstrap HomeLab homelab --bootstrap-series=jammy --config autocert-dns-name=juju.khoyi.io --config default-series=jammy
    juju bootstrap HomeLab homelab --bootstrap-series=jammy --config default-series=jammy
    juju gui

