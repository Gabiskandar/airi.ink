#!/usr/bin/env bash

function has_root_permissions ()
{
  local response=0

  # if user id is not 0, user is not root
  if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    response=1
  else
    response=0
  fi

  return $response
}
