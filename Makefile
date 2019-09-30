
XCPRETTY := xcpretty -c

SDK ?= "iphonesimulator"
DESTINATION ?= "platform=iOS Simulator,name=iPhone 8"
PROJECT := Segment-Nielsen-DCR
XC_ARGS := -scheme $(PROJECT)-Example -workspace Example/$(PROJECT).xcworkspace -sdk $(SDK) -destination $(DESTINATION) ONLY_ACTIVE_ARCH=NO

install: Example/Podfile Segment-Nielsen-DCR.podspec
	pod repo update
	pod install --project-directory=Example

clean:
	xcodebuild $(XC_ARGS) clean | $(XCPRETTY)

build:
	xcodebuild $(XC_ARGS)

build-dev:
	xcodebuild $(XC_ARGS) | $(XCPRETTY)

test:
	xcodebuild test $(XC_ARGS)

test-dev:
	xcodebuild test $(XC_ARGS) | $(XCPRETTY)

lint:
	pod lib lint --use-libraries --allow-warnings

xcbuild:
	xctool $(XC_ARGS)

xctest:
	xctool test $(XC_ARGS)

.PHONY: test test-dev build build-dev xctest xcbuild clean
.SILENT:
