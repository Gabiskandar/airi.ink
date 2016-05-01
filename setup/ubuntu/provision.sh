#!/usr/bin/env bash

source ./privileges.sh

function install_ssh ()
{
  apt-get -y install openssh-server
}

# configures SSH server
function configure_ssh ()
{
  # turn off SSH password authentication and disable root user to log in.
  sed -i.bak '/PermitRootLogin/d' /etc/ssh/sshd_config
  sed -i.bak '/PasswordAuthentication/d' /etc/ssh/sshd_config
  echo PermitRootLogin no >> /etc/ssh/sshd_config
  echo PasswordAuthentication no >> /etc/ssh/sshd_config
  # allow access on firewall for default port 22
  ufw allow 22
}

# updates base installation of Ubuntu
function update_base ()
{
  # update Aptitude (apt) and pull dependencies
  apt-get -y update
}

# if script returns 0, something is invalid
if has_root_permissions; then
  update_base
  install_ssh
  configure_ssh
  service ssh restart
else
  exit 1
fi
