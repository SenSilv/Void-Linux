#!/bin/bash

## Update system
sudo xbps-install -Su

## Install video, audio, terminal emulator
sudo xbps-install i3-gaps st firefox-esr xorg-minimal ffmpeg apparmor
