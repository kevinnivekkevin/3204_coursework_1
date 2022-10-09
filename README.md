# 3204_coursework_1

## Architecture (current, TBC)
![image](https://user-images.githubusercontent.com/63487456/194746738-c0f65eb9-98e6-4bfd-8140-73d109fbb44d.png)

### Setup
1. Install vagrant https://www.vagrantup.com/downloads
2. Install vagrant-vmware-utility https://www.vagrantup.com/vmware/downloads
3. Install vagrant plugins
```
vagrant plugin install vagrant-vmware-desktop
vagrant plugin install vagrant-docker-compose
```

### Run
```
# cd to project dir
vagrant up
```
### View logs
1. Browse to `http://[Vmware_IP]:8090` (confluence) or http://<IP>:8000 (apache) to generate some logs first.
2. Browse to `http://[Vmware_IP]:5601` and login with `elastic:changeme`
3. Browse to `http://[Vmware_IP]:5601/app/discover` to view the logs.

## Initial Access
### Confluence 7.12.4

### CVE-2022-26134 - Confluence Server RCE
https://github.com/Debajyoti0-0/CVE-2022-26134

#### E.g output of exploit
![image](https://user-images.githubusercontent.com/63487456/194700550-61e765b9-cc48-4789-88f1-bf01eeb86ac1.png)
