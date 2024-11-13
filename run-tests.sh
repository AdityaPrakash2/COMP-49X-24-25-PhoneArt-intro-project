#!/bin/bash
SCHEME='COMP-49X-24-25-PhoneArt-intro-project'
DESTINATION='platform=iOS Simulator,OS=18.0,name=iPhone 16 Pro'
xcodebuild test -scheme $SCHEME -destination "$DESTINATION" CODE_SIGNING_ALLOWED='NO'
