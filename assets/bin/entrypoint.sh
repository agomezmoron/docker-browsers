#!/bin/bash
#=====================
# Environment variables
#=====================
set -x

ENTRYPOINT_ARGS="$@"
PROJECT_DIR="/src"

# Running commands for tests
if [ -n "$DOCKER_TESTS_COMMAND" ]
then
  cd $PROJECT_DIR
  # perform the command
  /bin/bash --login -c $DOCKER_TESTS_COMMAND
fi