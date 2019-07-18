# Segment-Nielsen-DCR

[![Circle CI](https://circleci.com/gh/segment-integrations/analytics-ios-integration-nielsen-dcr.svg?style=svg&circle-token=9df3a0f8385bd1f43655f79cf649035cfe538035)](https://circleci.com/gh/segment-integrations/analytics-ios-integration-nielsen-dcr)
[![Version](https://img.shields.io/cocoapods/v/Segment-Nielsen-DCR.svg?style=flat)](http://cocoapods.org/pods/Segment-Nielsen-DCR)
[![License](https://img.shields.io/cocoapods/l/Segment-Nielsen-DCR.svg?style=flat)](http://cocoapods.org/pods/Segment-Nielsen-DCR)
[![Platform](https://img.shields.io/cocoapods/p/Segment-Nielsen-DCR.svg?style=flat)](http://cocoapods.org/pods/Segment-Nielsen-DCR)

## Installation

The Nielsen App SDK as of version 6.0.0.0 is compatible with Apple iOS version 8.0 and above.

Segment-Nielsen-DCR SDK is available through [CocoaPods](http://cocoapods.org). To install
it, add the following line to your Podfile:

```ruby
pod "Segment-Nielsen-DCR"
```

The integration relies on the the Nielsen framework, which can either be installed via Cocoapods or by manually adding the framework. You will need to have a Nielsen representative to get started.

## Cocoapods

When using the Nielsen SDK version 6.2.0.0 and above, Nielsen recommends installation via Cocoapods, and Apple recommends using the dynamic framework.

Installation of the Dynamic Nielsen App Framework SDK via Cocoapods requires a Cocoapods version 1.6.1 or higher. Installation of the Static Nielsen App Framework SDK via Cocoapods requires a Cocoapods version 1.4.0 or higher.

1. **Set your repository credentials.** The first step is to add the credentials received from Nielsen into your `.netrc` file. Navigate to your home folder and create a file called `.netrc`
```
cd ~/
vi .netrc
```
You will need to fill out a license agreement form and have the contact information for your Nielsen representative in order to obtain the credentials [here](https://engineeringportal.nielsen.com/docs/Special:Downloads). Add the credentials in the following format:
```
machine raw.githubusercontent.com
login <Nielsen App SDK client>
password <Auth token>
```

2. **Add the source to your Podfile**

  Dynamic Framework (Note: you will need to include `use_frameworks!`)
```
source 'https://github.com/NielsenDigitalSDK/nielsenappsdk-ios-specs-dynamic.git'
```
Static Framework
```
source 'https://github.com/NielsenDigitalSDK/nielsenappsdk-ios-specs.git'
```

3. **Add the pod to your Podfile**

  `pod NielsenAppSDK`

4. **Install the pods**

  `pod install`

***A list of full instructions can be found [here](https://engineeringportal.nielsen.com/docs/Digital_Measurement_iOS_Artifactory_Guide)***

## Manual

Navigate to [Nielsen's Engineering Site](https://engineeringportal.nielsen.com/docs/Main_Page) and download the following Video framework:

![](http://g.recordit.co/IvvLm8oAY2.gif)

There will be an NDA to sign prior to accessing the download. Nielsen requires you fill out your company info and have a Nielsen representative before getting started.

Nielsen also requires the following frameworks, which must be included into Link Binary with Libraries (within app target’s Build Phases)
  - AdSupport.framework
  - SystemConfiguration.framework
  - CoreLocation.framework (Not applicable for International (Germany))
  - libsqlite3

## Usage

After you have properly installed the Nielsen App SDK, Register the factory with Segment SDK in the `application:didFinishLaunchingWithOptions`  method of your `AppDelegate`:

`#import <Segment-Nielsen-DCR/SEGNielsenDCRIntegrationFactory.h>`


```
NSString *const SEGMENT_WRITE_KEY = @" ... ";
SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:SEGMENT_WRITE_KEY];

[config use:[SEGNielsenDCRIntegrationFactory instance]];

[SEGAnalytics setupWithConfiguration:config];
```

## License

Segment-Nielsen-DCR is available under the MIT license. See the LICENSE file for more info.
