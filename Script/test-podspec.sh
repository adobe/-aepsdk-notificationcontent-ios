#!/bin/bash
#
# Copyright 2021 Adobe. All rights reserved.
# This file is licensed to you under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License. You may obtain a copy
# of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
# OF ANY KIND, either express or implied. See the License for the specific language
# governing permissions and limitations under the License.

set -e # Any subsequent(*) commands which fail will cause the shell script to exit immediately

PROJECT_NAME=TestProject

help()
{
   echo ""
   echo "Usage: $0 -n FRAMEWORK_NAME"
   echo ""
   echo "    -n\t- Name of the framework being validated. \n\t  Example: NotificationContent, SwiftUI\n"
   echo "    -v\t- iOS version being targeted. \n\t  Example: 12.0, 15.0\n"
   exit 1 # Exit script after printing help
}

while getopts "n:v:" opt
do
   case "$opt" in
      n ) NAME="$OPTARG" ;;
      v ) IOS_VERSION="$OPTARG" ;;
      ? ) help ;; # Print help in case parameter is non-existent
   esac
done

# Clean up.
rm -rf $PROJECT_NAME

mkdir -p $PROJECT_NAME && cd $PROJECT_NAME

# Create a new Xcode project.
swift package init

# Use Xcodegen to generate the project.
echo "
name: $PROJECT_NAME
options:
  bundleIdPrefix: $PROJECT_NAME
targets:
  $PROJECT_NAME:
    type: framework
    sources: Sources
    platform: iOS
    deploymentTarget: "$IOS_VERSION"
    settings:
      GENERATE_INFOPLIST_FILE: YES
" >>project.yml

xcodegen generate

# Create a Podfile with our pod as dependency.
echo "
platform :ios, '$IOS_VERSION'
target '$PROJECT_NAME' do
  use_frameworks!
  pod '$NAME', :path => '../$NAME.podspec'
end
" >>Podfile

# Install the pods.
pod update

# Archive for generic iOS device
echo '############# Archive for generic iOS device ###############'
xcodebuild archive -scheme TestProject -workspace TestProject.xcworkspace -destination 'generic/platform=iOS'

# Build for generic iOS device
echo '############# Build for generic iOS device ###############'
xcodebuild clean build -scheme TestProject -workspace TestProject.xcworkspace -destination 'generic/platform=iOS'

# Archive for x86_64 simulator
echo '############# Archive for simulator ###############'
xcodebuild archive -scheme TestProject -workspace TestProject.xcworkspace -destination 'generic/platform=iOS Simulator'

# Build for x86_64 simulator
echo '############# Build for simulator ###############'
xcodebuild clean build -scheme TestProject -workspace TestProject.xcworkspace -destination 'generic/platform=iOS Simulator'

# Clean up.
cd ../
rm -rf $PROJECT_NAME