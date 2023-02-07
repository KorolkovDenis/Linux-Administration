#!/bin/bash

ROOTUSER_NAME=root
username=`id -nu`
if [ "$username" != "$ROOTUSER_NAME" ]
then
        echo "Must be root to run \"`basename $0`\"."
        exit 1
fi

die() {
    warn "$*"
    exit 1
}

warn() {
    echo "$*" >&2
}

[ $# -eq 4 ] || die "Usage: $0 PREFIX SUBNET HOST INTERFACE"


[[ "$1" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$ ]] \
|| die "ERROR: PREFIX must match DIGIT+ DOT DIGIT+ and {0..255}"

[[ "$2" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]] \
|| die "ERROR: SUBNET must match DIGIT {0..255}"

[[ "$3" =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]] \
|| die "ERROR: HOST must match DIGIT {0..255}"

[[ "$4" =~ [a-z]+[0-9]+|"ip a |awk '/state UP/{print $2}'" ]] \
|| die "ERROR: INTERFACE must match WORD DIGIT+ (P.S. INTERFACE = `ls /sys/class/net`)"

PREFIX="$1"
SUBNET="$2"
HOST="$3"
INTERFACE="$4"

printf '%s\n' $PREFIX.${SUBNET}.${HOST} | xargs -t -IX arping -c 3 -I "$INTERFACE" X
