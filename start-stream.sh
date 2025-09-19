#!/bin/bash

# Final Google Meet Stream Automation
# Works with TamperMonkey script for Cmd+Shift+P

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Load configuration
if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a
    source "$SCRIPT_DIR/.env"
    set +a
fi

echo "🎬 Starting Google Meet stream with full automation..."

# AppleScript to create Meet and automate sharing
osascript <<'END'
tell application "Google Chrome"
    activate

    -- Create new Meet
    make new window
    set URL of active tab of window 1 to "https://meet.google.com/new"

    -- Wait for Meet to load and redirect
    delay 4

    -- Get the actual Meet URL
    set meetURL to URL of active tab of window 1

    -- Auto-join the meeting
    tell active tab of window 1
        execute javascript "
            // Click Join button
            setTimeout(() => {
                let joinBtn = document.querySelector('[jsname=\"Qx7uuf\"]') ||
                             document.querySelector('button[data-mdc-dialog-action=\"accept\"]') ||
                             Array.from(document.querySelectorAll('button')).find(b =>
                                 b.textContent.includes('Join now') ||
                                 b.textContent.includes('Ask to join'));
                if (joinBtn) {
                    joinBtn.click();
                    console.log('Clicked join button');
                }
            }, 2000);
        "
    end tell

    -- Copy URL to clipboard
    set the clipboard to meetURL

    -- Wait for join to complete
    delay 5

    -- Trigger Cmd+Shift+P via System Events (your TamperMonkey script will handle this)
    tell application "System Events"
        -- Trigger the TamperMonkey shortcut
        key code 35 using {command down, shift down} -- P key with Cmd+Shift

        -- Wait for share dialog to open
        delay 2

        -- Tab once to focus on tab navigation
        keystroke tab
        delay 0.5

        -- Right arrow twice to get to "Entire Screen"
        key code 124 -- Right arrow
        delay 0.3
        key code 124 -- Right arrow again
        delay 0.5

        -- Tab to focus on screen selection (Screen 1 is already selected by default)
        keystroke tab
        delay 0.5

        -- Press Enter to share Screen 1
        keystroke return
    end tell

    -- Wait for screen sharing to start
    delay 3

    -- Hide the "Stop sharing" modal
    tell application "System Events"
        keystroke tab
        delay 0.2
        keystroke tab
        delay 0.2
        keystroke space
        delay 0.5

        -- Open a new tab for clean workspace
        keystroke "t" using command down
    end tell

    return meetURL
end tell
END

# Get Meet URL from clipboard
MEET_URL=$(pbpaste)

if [[ "$MEET_URL" == *"meet.google.com"* ]] && [[ "$MEET_URL" != *"meet.google.com/new"* ]]; then
    echo "✅ Meet created: $MEET_URL"

    # Post to Slack
    if [ -n "$SLACK_WEBHOOK_URL" ]; then
        MESSAGE="${SLACK_MESSAGE/\{url\}/$MEET_URL}"
        response=$(curl -s -X POST "$SLACK_WEBHOOK_URL" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"$MESSAGE\"}")

        if [[ "$response" == *"ok"* ]]; then
            echo "✅ Posted to Slack #${SLACK_CHANNEL}"
        fi
    fi

    echo ""
    echo "🎉 Stream started with screen sharing!"
    echo "📺 Your entire Screen 1 should now be shared"
else
    echo "⚠️  Check if Meet was created properly"
fi