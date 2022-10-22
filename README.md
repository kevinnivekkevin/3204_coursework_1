# ICT3204 - Coursework Assignment 1

- To plan and implement a attack simulation utilizing `ATT&CK tactics`, `techniques`
- To integrate the usage of `Vagrant Scripts` and `Docker Containers`
- To perform log `collection`, `cleaning` and `visualisation` with the use of the `ELK` stack

#### Members
- `2000941` - Ian Peh Shun Wei
- `2001174` - Kevin Pook Yuan Kai
- `2001209` - Lim Jin Tao Benjamin
- `2001267` - Foong Jun Hui
- `2001558` - Jeremy Jevon Chow Zi You
- `2001689` - Cham Zheng Han Donovan

#### MITRE ATT&CK Techniques Chosen
- Initial Access - `Exploit Public-Facing Application`
- Privilege Escalation - `lorem ipsum`
- Persistence - `lorem ipsum`
- Credential Access - `lorem ipsum`
- Collection & Exfiltration - `lorem ipsum`
- Impact - `lorem ipsum`

#### Dependencies
1. `Vagrant` - https://www.vagrantup.com/downloads
2. `Docker Engine` - https://www.docker.com/
3. `Python 3` - https://www.python.org/

## Architecture (current, TBC)
View/edit the lucidchart diagram [here](https://lucid.app/lucidchart/6e6578d6-0ba2-476d-b156-56c140aab2bd/edit?viewport_loc=-393%2C-96%2C2219%2C979%2C0_0&invitationId=inv_5979f7e6-9a73-4b7e-b835-07418f9dae9d#)

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

## Usage 
Sections
1. [Part 1 - Spinning up the Infrastructure](https://github.com/kevinnivekkevin/3204_coursework_1/edit/rewrite2/README.md#part-1---spinning-up-the-infrastructure)
2. [Part 2 - Logs, Dashboards and Services](https://github.com/kevinnivekkevin/3204_coursework_1/edit/rewrite2/README.md#part-2---logs-dashboards-and-services)
3. [Part 3 - Attack Vector and Exploits](https://github.com/kevinnivekkevin/3204_coursework_1/edit/rewrite2/README.md#part-3---attack-vector-and-exploits)
    - [Initial Access](https://github.com/kevinnivekkevin/3204_coursework_1/edit/main/README.md#initial-access)
    - [Privilege Escalation](https://github.com/kevinnivekkevin/3204_coursework_1/edit/main/README.md#privilege-escalation)
    - [Persistence](https://github.com/kevinnivekkevin/3204_coursework_1/edit/main/README.md#persistence)
    - [Credential Access](https://github.com/kevinnivekkevin/3204_coursework_1/edit/main/README.md#credential-access)
    - [Collection & Exfiltration](https://github.com/kevinnivekkevin/3204_coursework_1/edit/main/README.md#collection--exfiltration)
    - [Impact](https://github.com/kevinnivekkevin/3204_coursework_1/edit/main/README.md#impact)

### Part 1 - Spinning up the Infrastructure
1. Ensure Docker Engine is **running**
2. From within project folder
    ```
    vagrant up
    ```
    > Expected output
      ```
      $ vagrant up
      Bringing machine 'elk' up with 'docker' provider...
      Bringing machine 'kali' up with 'docker' provider...
      Bringing machine 'postgres' up with 'docker' provider...
      Bringing machine 'confluence' up with 'docker' provider...
      ...
      ...
      ```
      ```
      $ docker container ls
      CONTAINER ID   IMAGE                           COMMAND                    CREATED           STATUS          PORTS                                                                                                      NAMES
      ...            postgres:14                     "docker-entrypoint.s…"     .. minutes ago    Up xx minutes   0.0.0.0:5432->5432/tcp                                                                                     postgres
      ...            kevinpook/confluence-7.13.0     "/bin/sh -c '/usr/sb…"     .. minutes ago    Up xx minutes   127.0.0.1:2201->22/tcp, 0.0.0.0:80->8090/tcp                                                               confluence
      ...            sebp/elk                        "/usr/local/bin/star…"     .. minutes ago    Up xx minutes   0.0.0.0:5044->5044/tcp, 0.0.0.0:5601->5601/tcp, 0.0.0.0:9200->9200/tcp, 0.0.0.0:9600->9600/tcp, 9300/tcp   elk
      ...            tknerr/baseimage-ubuntu:18.04   "/bin/sh -c '/usr/sb…"     .. minutes ago    Up xx minutes   127.0.0.1:2222->22/tcp                                                                                     kali
      ```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

### Part 2 - Logs, Dashboards and Services

#### Confluence - Attack target
- Simulated Network - `10.0.0.3`
- Testing and User Access - `http://127.0.0.1:80`

#### Kibana(ELK) Dashboard
- Simulated Network - `10.0.0.2`
- User Access - `http://127.0.0.1:5601`
- Browse to `http://localhost:5601/app/dashboards` to view the log dashboards. (e.g [Packetbeat] Overview ECS)

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

### Part 3 - Attack Vector and Exploits
The simulated attacker that is used to perform the relevant [MITRE ATT&CK](https://attack.mitre.org) techniques can be accessed by utilizing the **Attacker/Kali Docker container**
```
docker exec -it kali /bin/bash
```

### Initial Access
##### CVE-2022-26134 - Confluence RCE
- https://github.com/jbaines-r7/through_the_wire

    <img src="https://user-images.githubusercontent.com/1593214/197329877-ef4c952d-2de8-49e2-84ab-fde8a30edea3.png" width="512">

Steps:
  ```
  host-machine $ docker exec -it kali /bin/bash
  root@kali # cd /tmo/1_InitialAccess
  root@kali # bash runme.sh
  ...
  ...
  confluence@confluence:/opt/atlassian/confluence/bin $
  ```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

### Privilege Escalation
```
lorem ipsum
```
<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

### Persistence
```
lorem ipsum
```
<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

### Credential Access
```
lorem ipsum
```
<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

### Collection & Exfiltration
#### Exfiltrate data over ICMP
https://github.com/ariary/QueenSono
#### Exfiltrate data over DNS
https://github.com/m57/dnsteal

- Collected files are tar-ed from the Confluence server sent to the attacker server via ICMP and DNS
- All files that are to be exfiltrated can be placed at `/tmp/exfiltrate` on the Confluence server
- Files received by the attacker can be found at `/tmp/qs/` (ICMP) and `/tmp/dnsteal/` (DNS)
- Data is exfiltrated to the attacker at X minute intervals (currently set to 1).

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

### Impact
```
lorem ipsum
```
<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>
