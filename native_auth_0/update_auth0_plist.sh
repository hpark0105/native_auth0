#!/bin/bash

# Extract values from Config.swift
CLIENT_ID=$(grep "static let clientId" Config.swift | cut -d'"' -f2)
DOMAIN=$(grep "static let domain" Config.swift | cut -d'"' -f2)

# Create the plist content
cat > Auth0.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>ClientId</key>
	<string>${CLIENT_ID}</string>
	<key>Domain</key>
	<string>${DOMAIN}</string>
</dict>
</plist>
EOF

echo "Auth0.plist has been updated with the latest configuration." 