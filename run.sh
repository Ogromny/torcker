#!/usr/bin/env bash

### CONFIGURATIONS
gateway_name="torkcer_gateway"

workstation_name="torcker_workstation"

network_name="torcker_bridge"
network_ip="192.168.0.222"

### COLORS
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
white="\033[1;37m"

### STRINGS
str_padding=13
str_network="[NETWORK]"
str_workstation="[WORKSTATION]"
str_gateway="[GATEWAY]"
str_system="[SYSTEM]"
str_command="[COMMAND]"

## CREATE
function cn {
  local networks=$(docker network ls -qf name=${network_name})
  if [[ -z "${networks}" ]]; then
    docker network create -d=bridge --subnet=192.168.0.0/24 ${network_name} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "The network has been successfully created"
    else
      printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "error during network creation, see errors above"
    fi
  else
    printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "The network already exist"
  fi
}

## DELETE
function dn {
  dg

  local networks=$(docker network ls -qf name=${network_name})

  if [[ ! -z "${networks}" ]]; then
    docker network rm ${networks} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "The network has been successfully removed"
    else
      printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "error during network deletion, see errors above"
    fi
  else
    printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "The network doesn't exist"
  fi
}

## RUN
function rw {
  biw

  local containers=$(docker ps -aqf ancestor=${workstation_name})
  if [[ -z "${containers}" ]]; then
    docker run -d -p 5900:5900 ${workstation_name} 1>/dev/null
    if [[ $? -eq 0 ]]; then
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
    docker stop ${containers} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container was successfully stopped"
    else
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
    docker rm ${containers} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "The container has been successfully removed"
    else
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
    if [[ $? -eq 0 ]]; then
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
    docker rmi ${images} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Images successfully deleted"
    else
      printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "Error during image deletion, see errors above"
    fi
  fi

  biw
}

## RUN
function rg {
  cn
  big

  local containers=$(docker ps -aqf ancestor=${gateway_name})
  if [[ -z "${containers}" ]]; then
    docker run -d --privileged ${gateway_name} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The container has been successfully created"
    else
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Error during container creation, see errors above"
    fi
  else
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The container already exist"
  fi

  local containers=$(docker ps -aqf ancestor=${gateway_name})
  docker network connect --ip ${network_ip} ${network_name} ${containers} 1>/dev/null
  if [[ $? -eq 0 ]]; then
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The container has been successfully connected to the network"
  else
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Error during network connection, see errors above"
  fi

  docker exec -d -e USER=root ${containers} /usr/bin/tor
}

## STOP
function sg {
  local containers=$(docker ps -aqf ancestor=${gateway_name})
  if [[ ! -z "${containers}" ]]; then
    docker stop ${containers} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The container was successfully stopped"
    else
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Error during container stop, see errors above"
    fi
  else
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The container isn't launched"
  fi
}

## DELETE
function dg {
  sg

  local containers=$(docker ps -aqf ancestor=${gateway_name})
  if [[ ! -z "${containers}" ]]; then
    docker rm ${containers} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The container has been successfully removed"
    else
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Error while deleting container, see errors above"
    fi
  else
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The container doesn't exist"
  fi
}

## BUILD IMAGE
function big {
  local image=$(docker images -q ${gateway_name})
  if [[ -z ${image} ]]; then
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "The image doesn't exist let us create it"
    docker build -t ${gateway_name} Gateway/
    if [[ $? -eq 0 ]]; then
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Image successfully created"
    else
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Error during image creation, see errors above"
    fi
  else
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Image already exist"
  fi
}

## REBUILD IMAGE
function rig {
  local images=$(docker images -q ${gateway_name})
  if [[ ! -z "${images}" ]]; then
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Deleting all images of ${gateway_name}"
    docker rmi ${images} 1>/dev/null
    if [[ $? -eq 0 ]]; then
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Images successfully deleted"
    else
      printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "Error during image deletion, see errors above"
    fi
  fi

  big
}

function s {
  local containers=$(docker ps -aqf ancestor=${workstation_name})
  if [[ -z "${containers}" ]]; then
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "STOPPED"
  else
    printf "\n${blue}%*s${white} %s"   "${str_padding}" "${str_workstation}" "RUNNING"
  fi

  local containers=$(docker ps -aqf ancestor=${gateway_name})
  if [[ -z "${containers}" ]]; then
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "STOPPED"
  else
    printf "\n${green}%*s${white} %s"   "${str_padding}" "${str_gateway}" "RUNNING"
  fi

  local networks=$(docker network ls -qf name=${network_name})
  if [[ -z "${networks}" ]]; then
    printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "STOPPED"
  else
    printf "\n${yellow}%*s${white} %s"   "${str_padding}" "${str_network}" "RUNNING"
  fi
}

function q {
  dw
  dg
  dn

  exit 0
}

while [[ "${REPLY}" != "quit" ]]; do
  printf "${yellow}%*s${white} %s %s"     "${str_padding}" "${str_network}"     "Create"         "(cn)"
  printf "\n${yellow}%*s${white} %s %s"   "${str_padding}" "${str_network}"     "Delete"         "(dn)"
  printf "\n${blue}%*s${white} %s %s"     "${str_padding}" "${str_workstation}" "Run"            "(rw)"
  printf "\n${blue}%*s${white} %s %s"     "${str_padding}" "${str_workstation}" "Delete"         "(dw)"
  printf "\n${blue}%*s${white} %s %s"     "${str_padding}" "${str_workstation}" "Rebuild image"  "(riw)"
  printf "\n${green}%*s${white} %s %s"    "${str_padding}" "${str_gateway}"     "Run"            "(rg)"
  printf "\n${green}%*s${white} %s %s"    "${str_padding}" "${str_gateway}"     "Delete"         "(dg)"
  printf "\n${green}%*s${white} %s %s"    "${str_padding}" "${str_gateway}"     "Rebuild image"  "(rig)"
  printf "\n${white}%*s${white} %s %s"    "${str_padding}" "${str_system}"      "Status"         "(s)"
  printf "\n${white}%*s${white} %s %s"    "${str_padding}" "${str_system}"      "Quit"           "(q)"
  printf "\n${white}%*s${white} "         "${str_padding}" "${str_command}"

  read

  case ${REPLY} in
    "cn")   cn;;
    "dn")   dn;;
    "rw")   rw;;
    "dw")   dw;;
    "riw")  riw;;
    "rg")   rg;;
    "dg")   dg;;
    "rig")  rig;;
    "s")    s;;
    "q")    q;;
    *)      printf "${red}%s" "Unknow command"
  esac

  printf "\n\n"
done