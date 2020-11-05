#!/usr/bin/env bash

set -o errexit

function usage() {
 cat <<EOT 1>&2
Usage: docker run <arguments> <the-docker-image-name> (produce|serve|help)

  This script is responsible for producing and serving a valid mkdocs project using docker.

  Commands:

  1. Produce

    - Reads the local directory that contains a valid Mkdocs project.
    - Internally use Mkdocs to build the project.
    - Write out to the stdout a .tar.gz file that includes all the resources produced by mkdocs.

    $ docker run --mount type=bind,source="\$(pwd)",target=/src/mkdocs mkdockerize produce


  2. Serve

    - Read the .tar.gz file produced from the produce command from stdin
    - Use Mkdocs internally to serve it on port 8000

    $ docker run -p 8000:8000 --mount type=bind,source="\$(pwd)",target=/src/mkdocs -d mkdockerize serve

EOT
}

DOCKER_IMAGE_NAME="mkdockerize"

# To prettify our logs.
function log_it() {
  local msg="$@"
  yellow=33
  echo -e "\033[${yellow}m==> [${DOCKER_IMAGE_NAME}] ${msg}\033[m"
}

function success_msg() {
  local msg="$@"
  green=32
  echo -e "\033[${green}m==> [${DOCKER_IMAGE_NAME}] ${msg}\033[m"
}

function error_msg() {
  local msg="$@"
  red=31
  echo -e "\033[${red}m==> [${DOCKER_IMAGE_NAME}] Error: ${msg}\033[m"
}

COMMAND=$@
MKDOCS_SITE_PATH=/src/mkdocs
OUTPUT_FILE=site.tar.gz

function produce() {
  test -d "${MKDOCS_SITE_PATH}" || {
    error_msg "Missing arguments for 'produce' command."
    usage
    exit 1;
  }

  # By passing the following args, we can read the local directory that contains the mkdocs project.
  #   --mount type=bind,source="$(pwd)",target=/src/mkdocs
  cd $MKDOCS_SITE_PATH

  log_it "Building mkdocs project..."

  test -a "${MKDOCS_SITE_PATH}/mkdocs.yml" || {
    error_msg "Current directory is not a valid mkdocs project because the file mkdocs.yml is missing."
    log_it "For reference, kindly visit this page https://www.mkdocs.org/#getting-started"
    exit 1;
  }

  # Internally use mkdocs (for building the project).
  mkdocs build

  # Ensure dev_addr is present in mkdocs.yml


  # Write out to STDOUT a .tar.gz file.
  tar -czvf - site > $OUTPUT_FILE

  success_msg "File ${OUTPUT_FILE} created!"
}

function serve() {
  # By passing the following args, we can read the .tar.gz file produced from produce command.
  #   --mount type=bind,source="$(pwd)",target=/src/mkdocs
  cd $MKDOCS_SITE_PATH

  log_it "Extracting $OUTPUT_FILE in the working directory..."

  # Read the .tar.gz file produced from produce command from STDIN
  cat $OUTPUT_FILE | tar -xzvf -

  # Use mkdocs internally to serve it on port 8000.
  # NOTE: By default, mkdocs will bind to 127.0.0.1:8000 so when we run serve in a container, it's not accessible to the host machine even with the right ports are published in the docker command line.
  mkdocs serve --dev-addr "0.0.0.0:8000"

  log_it "Mkdocs server is now running!"
}

# Main control flow
function main() {
  log_it "Running command '${COMMAND}'... "

  case $COMMAND in
    produce) produce;;
      serve) serve;;
       help) usage; exit 0;;
          *) $COMMAND;; # pass the intended command
  esac
}

main "$@"
