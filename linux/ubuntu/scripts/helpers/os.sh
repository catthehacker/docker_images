#!/bin/bash -e
################################################################################
##  File:  install-helpers.sh
##  Desc:  Helper functions for installing tools
################################################################################

function isUbuntu18() {
  . /etc/os-release
  [[ "${VERSION_ID}" =~ ^18\.(.*)$ ]]
}

function isUbuntu20() {
  . /etc/os-release
  [[ "${VERSION_ID}" =~ ^20\.(.*)$ ]]
}

function getOSVersionLabel() {
  . /etc/os-release
  echo "${VERSION_CODENAME}"
}
