#!/bin/sh

getComposeFileFromServiceName() {
  echo "${PWD}/$1/docker-compose.yml"
}

doDockerComposeUp() {
  SERVICE_DOCKER_FILE_NAME=$(getComposeFileFromServiceName "$1")
  docker compose -f "$SERVICE_DOCKER_FILE_NAME" --project-name "$1" --env-file ${PWD}/"$1"/.env up --build -d
}

doDockerCompose() {
  SERVICE_DOCKER_FILE_NAME=$(getComposeFileFromServiceName "$2")
  docker compose -f "$SERVICE_DOCKER_FILE_NAME" --project-name "$2" --env-file ${PWD}/"$2"/.env "$1"
}

start() {
  docker volume create alfresco-migrator-db-volume
  docker volume create alfresco-migrator-acs-volume
  docker volume create alfresco-migrator-acs-log-volume
  docker volume create alfresco-migrator-acs-backup-volume
}

purge() {
  docker volume rm -f alfresco-migrator-db-volume
  docker volume rm -f alfresco-migrator-acs-volume
  docker volume rm -f alfresco-migrator-acs-log-volume
  docker volume rm -f alfresco-migrator-acs-backup-volume
}

case "$1" in
up)
  start
  doDockerComposeUp "active"
  ;;
down)
  doDockerCompose "down" "active"
  ;;
purge)
  doDockerCompose "down" "active"
  purge
  ;;
*)
  echo "Usage: $0 {up|down|purge}"
  ;;
esac
