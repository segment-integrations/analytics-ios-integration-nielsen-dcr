Change Log
==========
Version 1.2.0 *(19th July, 2019)*
-------------------------------------------
* Adds functionality support setting custom length property ("contentLengthPropertyName") in Segment UI. This is mapped to Nielsen's length. If a property is not provided in the settings, Segment will default to Segment specced property, `total_length`. 

Version 1.2.0 *(17th July, 2019)*
-------------------------------------------
* Adds functionality support setting custom assetid ("assetIdPropertyName") in Segment UI. This is used to override default property mapping for Segment property 'asset_id' to Nielsen 'assetid' when present.
* Adds functionality support setting custom clientid ("clientIdPropertyName") in Segment UI. This is used to override the 'cid'/'clientid' value sent to Nielsen in 'loadMetadata()' events.
* Adds functionality support setting custom subbrand ("subbrandPropertyName") in Segment UI. This is used to override the 'vcid'/'subbrand' value sent to Nielsen in 'loadMetadata()' events.

Version 1.1.2 *(16th July, 2019)*
-------------------------------------------
* Fix syntax errors of Content Metadata and AppInformation.

Version 1.1.1 *(15th July, 2019)*
-------------------------------------------
* Fix casing of mediaUrl and channelName to have  parity with Android.

Version 1.1.0 *(11th July, 2019)*
-------------------------------------------
* Add debug flag/setting
* Migrates from travis to CircleCI
* Updates build and Readme per SDK bundling
* Adds `hasAds` and `crossId2` to content metadata

Version 1.0.0-beta *(13th September, 2017)*
-------------------------------------------
*(Supports analytics-ios 3.6.+ and Nielsen-DCR 5.1.1.25+)*

Initial release.
