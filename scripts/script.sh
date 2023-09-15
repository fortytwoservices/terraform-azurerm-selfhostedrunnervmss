#!/bin/sh
user=$3

if [ "`whoami`" != $user ]; then
  useradd -m $user
  cd /home/$user
  curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh > create-latest-svc.sh
  chown $user:$user /home/$user/create-latest-svc.sh
  chmod 750 /home/$user/create-latest-svc.sh
  export RUNNER_CFG_PAT=$2
  bash "/home/$user/create-latest-svc.sh" -s $1 -u $user -l $4 -f
  exit
fi
