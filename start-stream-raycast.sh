#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Work Stream
# @raycast.mode compact
# @raycast.packageName Work Tools

# Optional parameters:
# @raycast.icon 🎬
# @raycast.description Start a Google Meet stream with screen sharing and notify Slack
# @raycast.author Christian Ulstrup
# @raycast.authorURL https://github.com/culstrup

# Documentation:
# @raycast.description Starts a Google Meet, shares screen, and posts to Slack #associates channel

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Execute the main stream automation script
"$SCRIPT_DIR/start-stream.sh"
