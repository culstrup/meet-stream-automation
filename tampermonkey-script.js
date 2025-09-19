// ==UserScript==
// @name         Meet: Present Now (Cmd+Shift+P)
// @namespace    meet.present.automation
// @version      1.0
// @description  Trigger Share/Present in Google Meet with Cmd+Shift+P
// @author       GSD at Work
// @match        https://meet.google.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Helper function to check if element is visible
    const isVisible = (el) => {
        if (!el) return false;
        const rect = el.getBoundingClientRect();
        const style = getComputedStyle(el);
        return rect.width > 0 && rect.height > 0 &&
               style.visibility !== 'hidden' && style.display !== 'none';
    };

    // Simulate real click event
    const realClick = (el) => {
        const rect = el.getBoundingClientRect();
        const x = rect.left + rect.width / 2;
        const y = rect.top + rect.height / 2;
        const ev = (type) => el.dispatchEvent(new MouseEvent(type, {
            bubbles: true,
            cancelable: true,
            view: window,
            clientX: x,
            clientY: y,
            buttons: 1
        }));

        ev('pointerdown');
        ev('mousedown');
        ev('mouseup');
        ev('click');
    };

    // Find and click the Present/Share button
    const triggerPresent = () => {
        const selectors = [
            '[aria-label*="Present"]',
            '[aria-label*="Share screen"]',
            '[jsname="r8qRAd"]',
            '[data-tooltip*="Present"]'
        ];

        for (const selector of selectors) {
            const button = document.querySelector(selector);
            if (button && isVisible(button)) {
                realClick(button);
                console.log('Triggered present/share button');
                return true;
            }
        }

        console.warn('Present/Share button not found');
        return false;
    };

    // Listen for keyboard shortcut
    document.addEventListener('keydown', function(e) {
        // Don't trigger in input fields
        if (e.target.matches('input, textarea, [contenteditable="true"]')) {
            return;
        }

        // Cmd+Shift+P (Mac) or Ctrl+Shift+P (Windows/Linux)
        const metaOrCtrl = navigator.platform.includes('Mac') ? e.metaKey : e.ctrlKey;

        if (metaOrCtrl && e.shiftKey && (e.key === 'P' || e.key === 'p')) {
            e.preventDefault();
            e.stopPropagation();
            triggerPresent();
        }
    }, true);
})();