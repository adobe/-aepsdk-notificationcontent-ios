export EXTENSION_NAME = AEPNotificationContent
export APP_NAME = DemoApp
CURRENT_DIRECTORY := ${CURDIR}
PROJECT_NAME = $(EXTENSION_NAME)
TARGET_NAME_XCFRAMEWORK = $(EXTENSION_NAME).xcframework
SCHEME_NAME_XCFRAMEWORK = AEPNotificationContentXCF

SIMULATOR_ARCHIVE_PATH = $(CURRENT_DIRECTORY)/build/ios_simulator.xcarchive/Products/Library/Frameworks/
SIMULATOR_ARCHIVE_DSYM_PATH = $(CURRENT_DIRECTORY)/build/ios_simulator.xcarchive/dSYMs/
IOS_ARCHIVE_PATH = $(CURRENT_DIRECTORY)/build/ios.xcarchive/Products/Library/Frameworks/
IOS_ARCHIVE_DSYM_PATH = $(CURRENT_DIRECTORY)/build/ios.xcarchive/dSYMs/
IOS_DESTINATION = 'platform=iOS Simulator,name=iPhone 15'


setup:
	(pod install)
	(cd TestApps/$(APP_NAME) && pod install)

setup-tools: install-githook

clean:
	(rm -rf build)

build:
	xcodebuild archive -workspace $(PROJECT_NAME).xcworkspace -scheme $(SCHEME_NAME_XCFRAMEWORK) -archivePath "./build/ios.xcarchive" -sdk iphoneos -destination="iOS" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
	xcodebuild archive -workspace $(PROJECT_NAME).xcworkspace -scheme $(SCHEME_NAME_XCFRAMEWORK) -archivePath "./build/ios_simulator.xcarchive" -sdk iphonesimulator -destination="iOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

format: lint-autocorrect swift-format

check-format:
	(swiftformat --lint $(PROJECT_NAME)/Sources --swiftversion 5.1)

install-swiftformat:
	(brew install swiftformat)

swift-format:
	(swiftformat $(PROJECT_NAME)/Sources --swiftversion 5.1)

lint-autocorrect:
	($(CURRENT_DIRECTORY)/Pods/SwiftLint/swiftlint --fix)

lint:
	(./Pods/SwiftLint/swiftlint lint $(PROJECT_NAME)/Sources)

check-version:
	(sh ./Script/version.sh $(VERSION))

test-SPM-integration:
	(sh ./Script/test-SPM.sh)

test-podspec:
	(sh ./Script/test-podspec.sh)

# used to test update-versions.sh script locally
test-versions:
	(sh ./Script/update-versions.sh -n AEPNotificationContent -v 5.0.0 -d "AEPCore 5.0.0, AEPServices 5.0.0, AEPEdge 5.0.0, AEPEdgeIdentity 5.0.0")