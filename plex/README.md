# My plex running in k8s 
TODO:  add more/correct status icons (shields)

![](https://img.shields.io/badge/juju-2.0+-brightgreen.svg)

## Overview
The Plexmedia service, runs from a single instance container with multiple storage pools.
The storage that is shared will need to be cephfs,  

| path | performance | amount | shared | persist |
|---|---|---|---|---|
| /transcode  | io optimized |   | false |   |
| /config  | io optimized | 20 GB | false |   |
| /srv/\<share\> | throughput readonly | 40+ TB | true |   |
| /srv/plexmedia_symlinks | high-read speed | 4 GB | true |   |
| /srv/plexmedia_pictures | high-read speed |   |   |   |

you need to make these secrets manually currently:
kubectl create secret generic jnlp-key --from-literal=jnlp-key='a_real_key'


## Usage
Run the Jenkins job, or read it and run commands manually if you're against automation making life easier  ;)

