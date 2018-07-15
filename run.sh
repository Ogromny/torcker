#!/usr/bin/env bash

### CONFIGURATIONS
gateway_name="torkcer_gateway"

workstation_name="torcker_workstation"
workstation_id=

bridge_name="torcker_bridge"

### COLORS
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
white="\033[1;37m"

### STRINGS
str_padding=13
str_workstation="[WORKSTATION]"
str_system="[SYSTEM]"
str_command="[COMMAND]"

## RUN
function rw {
  biw

  local containers=$(docker ps -aqf ancestor=${workstation_name})
  if [[ -z "${containers}" ]]; then
    workstation_id=$(docker run -d -p 5900:5900 ${workstation_name})
    if [[ $? == 0 ]]; then
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container has been successfully created"
    else
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Error during container creation, see errors above"
    fi
  else
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container already exist"
  fi
}

## STOP
function sw {
  local containers=$(docker ps -aqf ancestor=${workstation_name})
  if [[ ! -z "${containers}" ]]; then
    local err
    err=$(docker stop ${containers} 2>&1)
    if [[ $? == 0 ]]; then
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container was successfully stopped"
    else
      printf "${err}"
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Error during container stop, see errors above"
    fi
  else
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container isn't launched"
  fi
}

## DELETE
function dw {
  sw

  local containers=$(docker ps -aqf ancestor=${workstation_name})
  if [[ ! -z "${containers}" ]]; then
    local err
    err=$(docker rm ${containers} 2>&1)
    if [[ $? == 0 ]]; then
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container has been successfully removed"
    else
      printf "${err}"
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Error while deleting container, see errors above"
    fi
  else
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container doesn't exist"
  fi
}

## BUILD IMAGE
function biw {
  local image=$(docker images -q ${workstation_name})
  if [[ -z ${image} ]]; then
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The image doesn't exist let us create it"
    docker build -t ${workstation_name} Workstation/

    if [[ $? == 0 ]]; then
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Image successfully created"
    else
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Error during image creation, see errors above"
    fi
  else
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Image already exist"
  fi
}

## REBUILD IMAGE
function riw {
  local images=$(docker images -q ${workstation_name})
  if [[ ! -z  "${images}" ]]; then
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Deleting all images of ${workstation_name}"
    docker rmi ${images}
  fi

  biw
}

function q {
  sw
  dw
}

while [[ "${REPLY}" != "quit" ]]; do
  printf "\n\n${blue}%*s${white} %s %s"   "${str_padding}" "${str_workstation}" "Run"  "(rw)"
#  printf "\n${blue}%*s${white} %s %s"   "${str_padding}" "${str_workstation}" "Stop"  "(sw)"
  printf "\n${blue}%*s${white} %s %s"   "${str_padding}" "${str_workstation}" "Delete"  "(dw)"
  printf "\n${blue}%*s${white} %s %s"   "${str_padding}" "${str_workstation}" "Rebuild image"  "(riw)"
  printf "\n${yellow}%*s${white} %s %s" "${str_padding}" "${str_system}"      "Quit" "(q)"
  printf "\n${red}%*s${white} "         "${str_padding}" "${str_command}"

  read

  case ${REPLY} in
    "rw") rw;;
#    "sw") sw;;
    "dw") dw;;
    "riw") riw;;
    "q")  q;;
    *)    printf "${red}%s" "Unknow command"
  esac
done