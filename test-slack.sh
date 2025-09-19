#!/bin/bash

# Test script to verify Slack webhook is working

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Load configuration
if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a
    source "$SCRIPT_DIR/.env"
    set +a
else
    echo "❌ No .env file found"
    echo "   Please create one based on .env.example"
    exit 1
fi

if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "❌ SLACK_WEBHOOK_URL not set in .env"
    exit 1
fi

echo "🧪 Testing Slack webhook..."
echo "   Channel: #${SLACK_CHANNEL:-general}"
echo ""

# Send test message
response=$(curl -s -w "\n%{http_code}" -X POST "$SLACK_WEBHOOK_URL" \
    -H 'Content-Type: application/json' \
    -d "{
        \"text\": \"🧪 Test message from stream automation script\",
        \"channel\": \"#${SLACK_CHANNEL:-general}\"
    }")

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n-1)

if [ "$http_code" = "200" ]; then
    echo "✅ Success! Check your Slack channel"
else
    echo "❌ Failed with HTTP $http_code"
    echo "   Response: $body"
    echo ""
    echo "Common issues:"
    echo "- Invalid webhook URL"
    echo "- Webhook disabled or deleted"
    echo "- Channel doesn't exist"
fi