# 🎬 Google Meet Stream Automation

One-click automation to start a Google Meet livestream with screen sharing and Slack notifications. Perfect for remote teams who want to enable spontaneous collaboration and "working in public" culture.

## ✨ Features

- **🚀 One-Key Launch**: Start streaming with a single Raycast hotkey
- **📺 Auto Screen Sharing**: Automatically shares your primary screen
- **💬 Slack Integration**: Posts meeting link to your team channel
- **🎯 UI Cleanup**: Hides distracting UI elements for clean streaming
- **⚡ Fast Setup**: ~5 second from hotkey to live stream

## 🎥 Demo

<div align="center">
  <a href="https://www.loom.com/share/88d80793a10349efae7274fceafa22fc">
    <img src="https://cdn.loom.com/sessions/thumbnails/88d80793a10349efae7274fceafa22fc-1734640977337-with-play.gif" width="600" alt="Watch the demo">
  </a>
</div>

<p align="center">
  <strong><a href="https://www.loom.com/share/88d80793a10349efae7274fceafa22fc">▶️ Watch the full demo and explanation on Loom</a></strong>
</p>

With one keypress, the automation:
1. Creates a new Google Meet
2. Auto-joins the meeting
3. Starts screen sharing
4. Hides the "Stop sharing" modal
5. Opens a new tab for working
6. Posts the Meet link to Slack

## 📋 Prerequisites

- **macOS** (tested on macOS 15+)
- **Google Chrome** (logged into your Google account)
- **Raycast** (for hotkey triggering)
- **TamperMonkey** Chrome extension
- **Slack Webhook** (optional, for team notifications)

## 🔧 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/meet-stream-automation.git
cd meet-stream-automation
```

### 2. Chrome Setup

Enable JavaScript automation in Chrome:
1. Open Chrome
2. Go to **View → Developer → Allow JavaScript from Apple Events**
3. Click "Allow" in the popup

### 3. System Preferences

Enable Full Keyboard Access:
1. **System Settings → Keyboard → Keyboard navigation**
2. Turn ON "Use keyboard navigation to move focus between controls"

Grant Accessibility permissions:
1. **System Settings → Privacy & Security → Accessibility**
2. Add and enable Terminal (for testing) and Raycast (for production)

### 4. TamperMonkey Setup

Install the TamperMonkey extension and add this script for the Cmd+Shift+P shortcut:

```javascript
// ==UserScript==
// @name         Meet: Present Now (Cmd+Shift+P)
// @namespace    meet.present.automation
// @version      1.0
// @description  Trigger Share/Present in Google Meet with Cmd+Shift+P
// @match        https://meet.google.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    document.addEventListener('keydown', function(e) {
        // Cmd+Shift+P (Mac) or Ctrl+Shift+P (Windows/Linux)
        if ((e.metaKey || e.ctrlKey) && e.shiftKey && e.key === 'P') {
            e.preventDefault();

            // Click Present button
            const presentButton = document.querySelector('[aria-label*="Present"]') ||
                                  document.querySelector('[jsname="r8qRAd"]');
            if (presentButton) {
                presentButton.click();
            }
        }
    });
})();
```

### 5. Slack Webhook (Optional)

To enable Slack notifications:

1. **Create a Slack Workflow**:
   - In Slack: **Tools → Workflow Builder**
   - Create workflow → From a webhook
   - Add variable: `text` (Type: Text)
   - Add step: Send message to channel
   - Insert the `{text}` variable in the message
   - Select your channel (e.g., #associates)
   - Publish and copy the webhook URL

2. **Configure the Script**:
   ```bash
   cp .env.example .env
   # Edit .env and add your webhook URL
   ```

### 6. Raycast Integration

1. Open Raycast Preferences
2. Go to **Extensions → Script Commands**
3. Click **"Add Script Directory"**
4. Select the cloned repository folder
5. Find "Start Work Stream" in your commands
6. Assign a hotkey (e.g., ⌘⇧S)

## 🚀 Usage

### Via Raycast (Recommended)
Press your configured hotkey (e.g., ⌘⇧S)

### Via Terminal
```bash
./start-stream.sh
```

### Test Slack Integration
```bash
./test-slack.sh
```

## ⚙️ Configuration

Edit `.env` to customize:

```bash
# Slack Webhook URL (get from Slack Workflow Builder)
SLACK_WEBHOOK_URL="https://hooks.slack.com/triggers/..."

# Slack channel (without #)
SLACK_CHANNEL="associates"

# Custom message ({url} will be replaced with Meet URL)
SLACK_MESSAGE="Hey team! I'm streaming live while working. Feel free to join: {url}"
```

## 🏗️ How It Works

The automation uses:
- **AppleScript** to control Chrome and create the Meet
- **JavaScript injection** for clicking UI elements
- **System Events** for keyboard navigation
- **TamperMonkey** to add the Cmd+Shift+P shortcut
- **Slack Webhooks** for team notifications

### Automation Sequence

1. Opens Chrome with `meet.google.com/new`
2. Waits for Meet to generate unique URL
3. Auto-clicks "Join now" button
4. Triggers Cmd+Shift+P (via TamperMonkey)
5. Navigates: Tab → Right → Right → Tab → Enter
6. Hides modal: Tab → Tab → Space
7. Opens new tab with Cmd+T
8. Posts to Slack via webhook

## 🐛 Troubleshooting

### Meet doesn't auto-join
- Check Chrome JavaScript permissions (View → Developer menu)
- Verify you're logged into Google account
- Try running `./start-stream.sh` in Terminal to see errors

### Screen sharing doesn't start
- Ensure Full Keyboard Access is enabled
- Check TamperMonkey script is active
- Grant screen recording permissions to Chrome

### Slack not posting
- Verify webhook URL in `.env`
- Test with `./test-slack.sh`
- Check webhook is active in Slack Workflow Builder

### Raycast not working
- Ensure script has execute permissions: `chmod +x *.sh`
- Check Raycast has Accessibility permissions
- Try running directly: `./start-stream-raycast.sh`

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test thoroughly on macOS
4. Submit a pull request

### Ideas for Enhancement
- Support for multiple screens
- Custom camera settings
- Meeting scheduling integration
- Support for other browsers
- Windows/Linux compatibility

## 📄 License

MIT License - see [LICENSE](LICENSE) file

## 🙏 Acknowledgments

- Built for teams embracing "working in public" culture
- Inspired by the need for frictionless remote collaboration
- Thanks to the Raycast and TamperMonkey communities

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/meet-stream-automation/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/meet-stream-automation/discussions)

---

Made with ☕ by teams who stream their work