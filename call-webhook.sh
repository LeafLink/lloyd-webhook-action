#!/bin/bash

set -e

# Setup input variables
BUILD_URL="https://github.com/${GITHUB_REPOSITORY}/runs/${GITHUB_RUN_ID}"
EVENT="${INPUT_EVENT:-}"
REPO="${INPUT_REPO:-$(echo $GITHUB_REPOSITORY | awk -F '/' '{print $2}')}"
TAG="${INPUT_TAG:-$RELEASE_TAG}"
WEBHOOK_URL="${INPUT_WEBHOOK_URL:-}"
WEBHOOK_TOKEN="${INPUT_WEBHOOK_TOKEN:-}"

# Main functionality of the script
main() {
    echo "Calling LLoyd webhook..."
    echo "    DEBUG: Webhook URL - ${WEBHOOK_URL}"
    echo "    DEBUG: Webhook Token - ${WEBHOOK_TOKEN:0:4}******"
    echo "    DEBUG: Event - ${EVENT}"
    echo "    DEBUG: Build URL - ${BUILD_URL}"
    echo "    DEBUG: Repo - ${REPO}"
    echo "    DEBUG: Tag - ${TAG}"

    curl --request POST "${WEBHOOK_URL}" \
        --header "Authorization: Bearer ${WEBHOOK_TOKEN}" \
        --header "Content-Type: application/json" \
        --data-raw "{\"event\": \"${EVENT}\", \"build_url\":\"${BUILD_URL}\", \"repo\": \"${REPO}\", \"tag\": \"${TAG}\"}"
}

# Function that verifies required input was passed in
verify_input() {
  # Verify required inputs are not empty
  [ ! -z "$WEBHOOK_URL" ] && [ ! -z "$WEBHOOK_TOKEN" ] && [ ! -z "$EVENT" ]
}

# Function that outputs usage information
usage() {
  cat <<EOF

Usage: $(basename $0) <options>

Script used to call LLoyd webhooks

Options:
  --event (required)            The type of event that has occurred
  --repo                        The name of the GitHub repository the Action is being run from
  --tag                         The git tag corresponding to the Action run
  --webhook-token (required)    Authentication bearer token for the webhook
  --webhook-url (required)      Webhook URL to call

  -h, --help                    Print this message and quit

EOF
  exit 0
}

# Parse input options
while getopts "h-:" opt; do
  case "$opt" in
    h) usage && exit 0;;
    -)
      case "${OPTARG}" in
        event) EVENT="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
        repo) REPO="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
        tag) TAG="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
        webhook-token) WEBHOOK_TOKEN="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
        webhook-url) WEBHOOK_URL="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
        help) usage && exit 0;;
        *) echo "Invalid option: --$OPTARG." && usage && exit 1;;
      esac
    ;;
    \?) echo "Invalid option: -$OPTARG." && usage;;
    :) echo >&2 "Option -$OPTARG requires an argument." && exit 1;;
  esac
done

# Verify input
! verify_input && echo "Missing script options." && usage

# Execute main functionality
main
