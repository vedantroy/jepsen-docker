#!/bin/bash
set -e

echo "Preparing shared Jepsen state" >> /var/log/jepsen-setup.log
mkdir -p /var/jepsen/shared/control
mkdir -p /var/jepsen/shared/node

if [ ! -f /var/jepsen/shared/control/id_rsa ]; then
  echo "Generating control's keys" >> /var/log/jepsen-setup.log
  ssh-keygen -t rsa -N "" -f /var/jepsen/shared/control/id_rsa
elif [ ! -f /var/jepsen/shared/control/id_rsa.pub ]; then
  echo "Regenerating missing control public key" >> /var/log/jepsen-setup.log
  ssh-keygen -y -f /var/jepsen/shared/control/id_rsa > /var/jepsen/shared/control/id_rsa.pub
else
  echo "Reusing existing control keys" >> /var/log/jepsen-setup.log
fi

echo "Refreshing node authorized_keys" >> /var/log/jepsen-setup.log
cp /var/jepsen/shared/control/id_rsa.pub /var/jepsen/shared/node/authorized_keys

echo "Resetting node inventory" >> /var/log/jepsen-setup.log
: > /var/jepsen/shared/nodes
