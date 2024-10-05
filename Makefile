export APP_NAME = DemoApp
CURRENT_DIRECTORY := ${CURDIR}
FRAMEWORKS_DIRECTORY = $(CURRENT_DIRECTORY)/Frameworks

# per-framework variables

AEPNOTIFICATIONCONTENT = AEPNotificationContent
AEPNOTIFICATIONCONTENT_PATH = $(FRAMEWORKS_DIRECTORY)/$(AEPNOTIFICATIONCONTENT)
AEPNOTIFICATIONCONTENT_WORKSPACE = $(AEPNOTIFICATIONCONTENT_PATH)/$(AEPNOTIFICATIONCONTENT).xcworkspace
AEPNOTIFICATIONCONTENT_TARGET_NAME_XCFRAMEWORK = $(AEPNOTIFICATIONCONTENT).xcframework
AEPNOTIFICATIONCONTENT_SCHEME_NAME_XCFRAMEWORK = $(AEPNOTIFICATIONCONTENT)XCF

AEPSWIFTUI = AEPSwiftUI
AEPSWIFTUI_PATH = $(FRAMEWORKS_DIRECTORY)/$(AEPSWIFTUI)
AEPSWIFTUI_WORKSPACE = $(AEPSWIFTUI_PATH)/$(AEPSWIFTUI).xcworkspace
AEPSWIFTUI_TARGET_NAME_XCFRAMEWORK = $(AEPSWIFTUI).xcframework
AEPSWIFTUI_SCHEME_NAME_XCFRAMEWORK = $(AEPSWIFTUI)XCF

# build libraries and environments

SIMULATOR_ARCHIVE_PATH = $(CURRENT_DIRECTORY)/build/ios_simulator.xcarchive/Products/Library/Frameworks/
SIMULATOR_ARCHIVE_DSYM_PATH = $(CURRENT_DIRECTORY)/build/ios_simulator.xcarchive/dSYMs/
IOS_ARCHIVE_PATH = $(CURRENT_DIRECTORY)/build/ios.xcarchive/Products/Library/Frameworks/
IOS_ARCHIVE_DSYM_PATH = $(CURRENT_DIRECTORY)/build/ios.xcarchive/dSYMs/
IOS_DESTINATION = 'platform=iOS Simulator,name=iPhone 15'

# testing targets

test: clean aep-notification-content-unit-test aep-swift-ui-unit-test

aep-notification-content-unit-test: 
	@echo "######################################################################"
	@echo "### Unit Testing AEPNotificationContent"
	@echo "######################################################################"
	xcodebuild test -workspace $(AEPNOTIFICATIONCONTENT_WORKSPACE) \
		-scheme "UnitTests" -destination $(IOS_DESTINATION) -derivedDataPath build/out \
		-resultBundlePath build/$(AEPNOTIFICATIONCONTENT).xcresult -enableCodeCoverage YES

aep-swift-ui-unit-test: 
	@echo "######################################################################"
	@echo "### Unit Testing AEPSwiftUI"
	@echo "######################################################################"
	xcodebuild test -workspace $(AEPSWIFTUI_WORKSPACE) \
		-scheme "UnitTests" -destination $(IOS_DESTINATION) -derivedDataPath build/out \
		-resultBundlePath build/$(AEPSWIFTUI).xcresult -enableCodeCoverage YES

# build and archive targets

archive: pod-install _archive

ci-archive: ci-pod-install _archive

_archive: clean archive-notification-content archive-aep-swift-ui

archive-notification-content: build-notification-content
	xcodebuild -create-xcframework \
		-framework $(SIMULATOR_ARCHIVE_PATH)$(AEPNOTIFICATIONCONTENT).framework -debug-symbols $(SIMULATOR_ARCHIVE_DSYM_PATH)$(AEPNOTIFICATIONCONTENT).framework.dSYM \
		-framework $(IOS_ARCHIVE_PATH)$(AEPNOTIFICATIONCONTENT).framework -debug-symbols $(IOS_ARCHIVE_DSYM_PATH)$(AEPNOTIFICATIONCONTENT).framework.dSYM \
		-output ./build/$(AEPNOTIFICATIONCONTENT).xcframework

archive-aep-swift-ui: build-aep-swift-ui
	xcodebuild -create-xcframework \
		-framework $(SIMULATOR_ARCHIVE_PATH)$(AEPSWIFTUI).framework -debug-symbols $(SIMULATOR_ARCHIVE_DSYM_PATH)$(AEPSWIFTUI).framework.dSYM \
		-framework $(IOS_ARCHIVE_PATH)$(AEPSWIFTUI).framework -debug-symbols $(IOS_ARCHIVE_DSYM_PATH)$(AEPSWIFTUI).framework.dSYM \
		-output ./build/$(AEPSWIFTUI).xcframework

build: build-notification-content build-aep-swift-ui

build-notification-content:
	xcodebuild archive -workspace $(AEPNOTIFICATIONCONTENT_WORKSPACE) -scheme $(AEPNOTIFICATIONCONTENT_SCHEME_NAME_XCFRAMEWORK) \
		-archivePath "./build/ios.xcarchive" -sdk iphoneos -destination="iOS" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
	xcodebuild archive -workspace $(AEPNOTIFICATIONCONTENT_WORKSPACE) -scheme $(AEPNOTIFICATIONCONTENT_SCHEME_NAME_XCFRAMEWORK) \
		-archivePath "./build/ios_simulator.xcarchive" -sdk iphonesimulator -destination="iOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

build-aep-swift-ui:
	xcodebuild archive -workspace $(AEPSWIFTUI_WORKSPACE) -scheme $(AEPSWIFTUI_SCHEME_NAME_XCFRAMEWORK) \
		-archivePath "./build/ios.xcarchive" -sdk iphoneos -destination="iOS" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
	xcodebuild archive -workspace $(AEPSWIFTUI_WORKSPACE) -scheme $(AEPSWIFTUI_SCHEME_NAME_XCFRAMEWORK) \
		-archivePath "./build/ios_simulator.xcarchive" -sdk iphonesimulator -destination="iOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# utility targets

pod-install:
	(cd $(AEPNOTIFICATIONCONTENT_PATH) && pod install --repo-update)
	(cd $(AEPSWIFTUI_PATH) && pod install --repo-update)	

ci-pod-install:
	(cd $(AEPNOTIFICATIONCONTENT_PATH) && bundle exec pod install --repo-update)
	(cd $(AEPSWIFTUI_PATH) && bundle exec pod install --repo-update)
	(cd TestApps/$(APP_NAME) && bundle exec pod install --repo-update)

clean:
	(rm -rf build)

zip:
	cd build && zip -r -X $(AEPNOTIFICATIONCONTENT).xcframework.zip $(AEPNOTIFICATIONCONTENT).xcframework/
	swift package compute-checksum build/$(AEPNOTIFICATIONCONTENT).xcframework.zip
	cd build && zip -r -X $(AEPSWIFTUI).xcframework.zip $(AEPSWIFTUI).xcframework/
	swift package compute-checksum build/$(AEPSWIFTUI).xcframework.zip

# formatting and linting targets

format: lint-autocorrect swift-format

check-format:
	(swiftformat --lint $(AEPNOTIFICATIONCONTENT_PATH)/Sources --swiftversion 5.1)
	(swiftformat --lint $(AEPSWIFTUI_PATH)/Sources --swiftversion 5.1)

swift-format:
	(swiftformat $(AEPNOTIFICATIONCONTENT_PATH)/Sources --swiftversion 5.1)
	(swiftformat $(AEPSWIFTUI_PATH)/Sources --swiftversion 5.1)

install-swiftformat:
	(brew install swiftformat)

lint-autocorrect:
	(cd $(AEPNOTIFICATIONCONTENT_PATH) && ./Pods/SwiftLint/swiftlint --fix)

lint: swift-lint check-format

swift-lint:
	($(AEPNOTIFICATIONCONTENT_PATH)/Pods/SwiftLint/swiftlint lint)

check-version:
	(sh ./Script/version.sh $(VERSION))

test-SPM-integration:
	(sh ./Script/test-SPM.sh)

test-podspec:
	(sh ./Script/test-podspec.sh -n AEPNotificationContent -v 12.0)
	(sh ./Script/test-podspec.sh -n AEPSwiftUI -v 15.0)

# used to test update-versions.sh script locally
test-versions:
	(sh ./Script/update-versions.sh -n NotificationContent -v 5.9.9)