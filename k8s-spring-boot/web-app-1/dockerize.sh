#!/bin/bash

export WEB_APP_PATH="$(find . -iname 'web-app-1*.jar')"
export WEB_APP_NAME="$(find . -iname 'web-app-1*.jar' -exec basename {} .jar \;)"
export WEB_APP_VERSION="${WEB_APP_NAME#*web-app-1-}"





