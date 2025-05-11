#!/bin/bash

# Check if tun0 (VPN interface) exists
if ip link show tun0 >/dev/null 2>&1; then
  # Fetch country using public IP
  country=$(curl -s https://ipinfo.io/country 2>/dev/null)
  echo "{\"text\": \" ${country:-VPN}\", \"class\": \"vpn-on\"}"
else
  echo "{\"text\": \"\", \"class\": \"vpn-off\"}"
fi
