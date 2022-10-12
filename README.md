# 3204_coursework_1

## Architecture (current, TBC)
View/edit the lucidchart diagram [here](https://lucid.app/lucidchart/6e6578d6-0ba2-476d-b156-56c140aab2bd/edit?viewport_loc=-393%2C-96%2C2219%2C979%2C0_0&invitationId=inv_5979f7e6-9a73-4b7e-b835-07418f9dae9d#)

### Setup
1. Install vagrant https://www.vagrantup.com/downloads
2. Install vagrant-vmware-utility https://www.vagrantup.com/vmware/downloads
3. Install vagrant-vmware-desktop plugin
```
vagrant plugin install vagrant-vmware-desktop
```

### Run
```
# cd to project dir
vagrant up
```
### View logs
Browse to `http://localhost:5601/app/dashboard` to view the log dashboards. (e.g [Packetbeat] Overview ECS)

## Initial Access
### CVE-2022-26134 - Confluence 7.12.4 RCE
https://github.com/Debajyoti0-0/CVE-2022-26134

#### E.g output of exploit
![image](https://user-images.githubusercontent.com/63487456/194700550-61e765b9-cc48-4789-88f1-bf01eeb86ac1.png)
