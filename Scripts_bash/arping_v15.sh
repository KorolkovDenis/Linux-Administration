#!/bin/bash

ROOTUSER_NAME=root
username=`id -nu`
if [ "$username" != "$ROOTUSER_NAME" ]
then
        echo "Must be root to run \"`basename $0`\"."
        exit 1
fi

trap 'echo "Ping exit (CTRL-C)"; exit 1' 2

INTERFACE="$1"
PREFIX="${2:-NOT_SET}"
SUBNET="$3"
HOST="$4"

echo "Введите INTERFACE PREFIX SUBNET HOST. Если SUBNET или HOST не будут введены, значения будут взяты с {0..255}"

if [[ -z "$INTERFACE" ]]; then
    echo "\$INTERFACE must be passed as first positional argument"
    exit 1
fi

[[ "$INTERFACE" =~ [a-z]+[0-9]+|"ip a |awk '/state UP/{print $2}'" ]] \
|| { echo "ERROR: INTERFACE must match WORD DIGIT+ (P.S. INTERFACE = `ls /sys/class/net`)"; exit 1; }

[[ "$PREFIX" = "NOT_SET" ]] && { echo "\$PREFIX must be passed as second positional argument"; exit 1; }
[[ "$PREFIX" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]] \
|| { echo "ERROR: PREFIX must match DIGIT+ DOT DIGIT+ and {0..255}"; exit 1; }

if [[ -z "$SUBNET" ]]; then
    echo "\$SUBNET not set, must be passed as 3-th positional argument"
      for SUBNET in {0..255}
      do
          echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
          arping -c 3 -I "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
             if [[ -z "$HOST" ]]; then
                 echo "\$HOST not set"
                 exit 1
             fi
      done
fi

[[ "$SUBNET" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]] \
|| { echo "ERROR: SUBNET must match DIGIT {0..255}"; exit 1; }

if [[ -z "$HOST" ]]; then
    echo "\$HOST must be passed as 4-th positional argument"
      for HOST in {1..255}
      do
          echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
          arping -c 3 -I "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
      done
fi
[[ "$HOST" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]] \
|| { echo  "ERROR: HOST must match DIGIT {1..255}"; exit 1; }
arping -c 3 -I "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null






