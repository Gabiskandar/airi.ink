#!/usr/bin/env bash

source ./privileges.sh

# Usage: add-users.sh <username>
function add_user ()
{
  # only add user if username was passed.
  if [ "$1" ] ; then
    # add if user doesn't exist.
    id -u $1 &>/dev/null || useradd $1
    adduser $1 airi-data
  fi
}

function add_sudo_user ()
{
  if [ "$1" ] ; then
    id -u $1 &>/dev/null || useradd $1
    useradd -s /bin/bash -m $1
    usermod -aG airi-data adm sudo
  fi
}

# Usage: add-users.sh <key>
function add_key ()
{
  # only add SSH key is one was passed.
  if [ "$1" ] ; then

    # make sure we have a folder for known SSH keys.
    mkdir -p ~/.ssh

    # create the authorized_keys file if it doesn't exist.
    if [ ! -e ~/.ssh/authorized_keys ] ; then
      touch ~/.ssh/authorized_keys
    fi

  fi

  # restart sshd to pick up new config.
  service ssh restart
}
