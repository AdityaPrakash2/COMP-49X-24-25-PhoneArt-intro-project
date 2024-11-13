#!/bin/bash
SCHEME='COMP-49X-24-25-PhoneArt-intro-project'
DESTINATION='platform=iOS Simulator,OS=18.1,name=iPhone 16 Pro'
xcodebuild -project COMP-49X-24-25-PhoneArt-intro-project.xcodeproj -scheme $SCHEME -destination "$DESTINATION" build test CODE_SIGNING_ALLOWED='NO'
