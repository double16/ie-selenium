#!/bin/bash

#set -x
#set -e

# Updates all Vagrant machines based on modernie to run selenium

for ID in .vagrant/machines/*/virtualbox/id; do
    $(dirname $0)/post-boot-machine.sh $(cat $ID) || exit 1
done
