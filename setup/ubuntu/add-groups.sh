#!/usr/bin/env bash

source ./privileges.sh

function add_group ()
{
  GROUPID="airi-data"
  /bin/egrep -i "^${GROUPID}:" /etc/group

  if [ $? -eq 0 ]; then
    echo "Group $GROUPID exists in /etc/group."
  else
    echo "Group $GROUPID does not exist in /etc/group."
    addgroup --gid 3009 airi-data
  fi
}

if has_root_permissions; then
  add_group
else
  exit 1
fi
