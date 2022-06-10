#!/bin/bash

find . -iname "*.swift" -exec swift-format -i --configuration swift_format.json {} \;
