# Segment-Nielsen-DCR

[![CI Status](http://img.shields.io/travis/segment-integrations/analytics-ios-integration-nielsen-dcr.svg?style=flat)](https://travis-ci.org/segment-integrations/analytics-ios-integration-nielsen-dcr)
[![Version](https://img.shields.io/cocoapods/v/Segment-Nielsen-DCR.svg?style=flat)](http://cocoapods.org/pods/Segment-Nielsen-DCR)
[![License](https://img.shields.io/cocoapods/l/Segment-Nielsen-DCR.svg?style=flat)](http://cocoapods.org/pods/Segment-Nielsen-DCR)
[![Platform](https://img.shields.io/cocoapods/p/Segment-Nielsen-DCR.svg?style=flat)](http://cocoapods.org/pods/Segment-Nielsen-DCR)

## Installation

Nielsen App SDK is compatible with Apple iOS versions 7.0 and above.

Segment-Nielsen SDK is available through [CocoaPods](http://cocoapods.org). To install
it, add the following line to your Podfile:

```ruby
pod "Segment-Nielsen-DCR"
```

The integration relies on the the Nielsen framework, which is not available on Cocoapods. You must manually include the framework in your project. Navigate to [Nielsen's Engineering Site](https://engineeringforum.nielsen.com/sdk/developers/downloads.php) and download the following Video framework:

![](http://i.imgur.com/Xp1kRWd.png+)

Nielsen also requires the following frameworks, which must be included into Link Binary with Libraries (within app target’s Build Phases)
  - AdSupport.framework
  - SystemConfiguration.framework
  - CoreLocation.framework (Not applicable for International (Germany))
  - libsqlite3

After extracting the “NielsenAppApi.framework” from the Nielsen App SDK package and copying it to the ‘Frameworks’ folder of the Xcode project, import the Segment-Nielsen SDK header file in your `AppDelegate` :

`#import <Segment-Nielsen-DCR/SEGNielsenDCRIntegrationFactory.h>`

Then register the factory with the Segment SDK:

```
NSString *const SEGMENT_WRITE_KEY = @" ... ";
SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:SEGMENT_WRITE_KEY];

[config use:[SEGNielsenDCRIntegrationFactory instance]];

[SEGAnalytics setupWithConfiguration:config];
```

## License

Segment-Nielsen is available under the MIT license. See the LICENSE file for more info.
