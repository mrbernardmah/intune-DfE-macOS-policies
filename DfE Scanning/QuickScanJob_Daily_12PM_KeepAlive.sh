#!/bin/bash
#set -x

# Define variables
log="/var/log/schedquickscan.log"
plistname="com.microsoft.wdav.schedquickscan"
plistfile="/Library/LaunchDaemons/com.microsoft.wdav.schedquickscan.plist"
exec 1>> $log 2>&1

if test -f "$plistfile"; then
    echo "$(date) - Found existing $plistfile"
    echo "$(date) - Unloading $plistname"
    launchctl unload $plistfile
    echo "$(date) - Removing $plistfile"
    rm -rf $plistfile
fi

echo "$(date) - Installing new $plistfile"
cat > $plistfile <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
	<key>Label</key>
	<string>com.microsoft.wdav.schedquickscan</string>
	<key>ProgramArguments</key>
	<array>
		<string>sh</string>
		<string>-c</string>
		<string>/usr/local/bin/mdatp scan quick</string>
	</array>
	<key>StartCalendarInterval</key>
	<dict>
		<key>Hour</key>
		<integer>12</integer>
		<key>Minute</key>
		<integer>0</integer>
	</dict>
	<key>WorkingDirectory</key>
	<string>/usr/local/bin</string>
</dict>
</plist>
EOF

echo "$(date) - Loading $plistfile"
launchctl load $plistfile

echo "$(date) - Starting $plistname"
launchctl start $plistname

exit 0
