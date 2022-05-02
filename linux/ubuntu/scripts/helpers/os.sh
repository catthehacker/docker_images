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

function isUbuntu22() {
  . /etc/os-release
  [[ "${VERSION_ID}" =~ ^22\.(.*)$ ]]
}

function isUbuntuVer() {
  local ver=$1
  . /etc/os-release
  [[ "${VERSION_ID}" =~ ^$ver\.(.*)$ ]]
}

function getOSVersionLabel() {
  . /etc/os-release
  echo "${VERSION_CODENAME}"
}
